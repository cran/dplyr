
## ----, echo = FALSE, message = FALSE-------------------------------------
library(dplyr)
library(microbenchmark)
library(data.table)
library(Lahman)
knitr::opts_chunk$set(
  comment = "#>",
  error = FALSE,
  tidy = FALSE
)

options(digits = 3, microbenchmark.unit = "ms")


## ----setup---------------------------------------------------------------
batting_df <- tbl_df(Batting)
batting_dt <- tbl_dt(Batting)


## ----summarise-mean------------------------------------------------------
microbenchmark(
  dplyr_df = batting_df %.% group_by(playerID) %.% summarise(ab = mean(AB)),
  dplyr_dt = batting_dt %.% group_by(playerID) %.% summarise(ab = mean(AB)),
  dt_raw =   batting_dt[, list(ab = mean(AB)), by = playerID],
  base =     tapply(batting_df$AB, batting_df$playerID, FUN = mean),
  times = 5
)


## ----sumarise-mean_------------------------------------------------------
mean_ <- function(x) .Internal(mean(x))
microbenchmark(
  dplyr_df = batting_df %.% group_by(playerID) %.% summarise(ab = mean_(AB)),
  dplyr_dt = batting_dt %.% group_by(playerID) %.% summarise(ab = mean_(AB)),
  dt_raw =   batting_dt[, list(ab = mean_(AB)), by = playerID],
  base =     tapply(batting_df$AB, batting_df$playerID, FUN = mean_),
  times = 5
)


## ----arrange-------------------------------------------------------------
microbenchmark(
  dplyr_df = batting_df %.% arrange(playerID, yearID),
  dplyr_dt = batting_dt %.% arrange(playerID, yearID),
  dt_raw =   setkey(copy(batting_dt), playerID, yearID),
  base   =   batting_dt[order(batting_df$playerID, batting_df$yearID), ],
  times = 2
)


## ----filter--------------------------------------------------------------
microbenchmark(
  dplyr_df = batting_df %.% group_by(playerID) %.% filter(G == max(G)),
  dplyr_dt = batting_dt %.% group_by(playerID) %.% filter(G == max(G)),
  dt_raw   = batting_dt[batting_dt[, .I[G == max(G)], by = playerID]$V1],
  base   =   batting_df[ave(batting_df$G, batting_df$playerID, FUN = max) ==
    batting_df$G, ],
  times = 2
)


## ----mutate--------------------------------------------------------------
microbenchmark(
  dplyr_df  = batting_df %.% group_by(playerID) %.% mutate(r = rank(desc(AB))),
  dplyr_dt  = batting_dt %.% group_by(playerID) %.% mutate(r = rank(desc(AB))),
  dt_raw =    copy(batting_dt)[, rank := rank(desc(AB)), by = playerID],
  times = 2
)


## ----mutate2-------------------------------------------------------------
microbenchmark(
  dplyr_df = batting_df %.% group_by(playerID) %.%
    mutate(cyear = yearID - min(yearID) + 1),
  dplyr_dt = batting_dt %.% group_by(playerID) %.%
    mutate(cyear = yearID - min(yearID) + 1),
  dt_raw =   copy(batting_dt)[, cyear := yearID - min(yearID) + 1,
    by = playerID],
  times = 5
)


## ----mutate_hybrid-------------------------------------------------------
min_rank_ <- min_rank
microbenchmark(
  hybrid  = batting_df %.% group_by(playerID) %.% mutate(r = min_rank(AB)),
  regular  = batting_df %.% group_by(playerID) %.% mutate(r = min_rank_(AB)),
  times = 2
)


## ------------------------------------------------------------------------
master_df <- tbl_df(Master) %.% select(playerID, hofID, birthYear)
hall_of_fame_df <- tbl_df(HallOfFame) %.% filter(inducted == "Y") %.%
  select(hofID, votedBy, category)

master_dt <- tbl_dt(Master) %.% select(playerID, hofID, birthYear)
hall_of_fame_dt <- tbl_dt(HallOfFame) %.% filter(inducted == "Y") %.%
  select(hofID, votedBy, category)


## ------------------------------------------------------------------------
microbenchmark(
  dplyr_df = left_join(master_df, hall_of_fame_df, by = "hofID"),
  dplyr_dt = left_join(master_dt, hall_of_fame_dt, by = "hofID"),
  base     = merge(master_df, hall_of_fame_df, by = "hofID", all.x = TRUE),
  times = 10
)

microbenchmark(
  dplyr_df = inner_join(master_df, hall_of_fame_df, by = "hofID"),
  dplyr_dt = inner_join(master_dt, hall_of_fame_dt, by = "hofID"),
  base     = merge(master_df, hall_of_fame_df, by = "hofID"),
  times = 10
)

microbenchmark(
  dplyr_df = semi_join(master_df, hall_of_fame_df, by = "hofID"),
  dplyr_dt = semi_join(master_dt, hall_of_fame_dt, by = "hofID"),
  times = 10
)

microbenchmark(
  dplyr_df = anti_join(master_df, hall_of_fame_df, by = "hofID"),
  dplyr_dt = anti_join(master_dt, hall_of_fame_dt, by = "hofID"),
  times = 10
)


