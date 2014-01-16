
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

options(digits = 3)


## ----setup---------------------------------------------------------------
batting_df <- tbl_df(Batting)
players_df <- group_by(batting_df, playerID)

batting_dt <- tbl_dt(Batting)
players_dt <- group_by(batting_dt, playerID)


## ----summarise-mean------------------------------------------------------
microbenchmark(
  dplyr_df = summarise(players_df, ab = mean(AB)),
  dplyr_dt = summarise(players_dt, ab = mean(AB)),
  dt_raw =   players_dt[, list(ab = mean(AB)), by = playerID],
  base =     tapply(batting_df$AB, batting_df$playerID, FUN = mean),
  times = 5, 
  unit = "ms"
)


## ----sumarise-mean_------------------------------------------------------
mean_ <- function(x) .Internal(mean(x))
microbenchmark(
  dplyr_df = summarise(players_df, ab = mean_(AB)),
  dplyr_dt = summarise(players_dt, ab = mean_(AB)),
  dt_raw =   players_dt[, list(ab = mean_(AB)), by = playerID],
  base =     tapply(batting_df$AB, batting_df$playerID, FUN = mean_),
  times = 5, 
  unit = "ms"
)


## ----arrange-------------------------------------------------------------
microbenchmark(
  dplyr_df = arrange(players_df, yearID),
  dplyr_dt = arrange(players_dt, yearID),
  dt_raw =   batting_dt[order(playerID, yearID), ],
  base   =   batting_df[order(batting_df$playerID, batting_df$yearID), ],
  times = 2, 
  unit = "ms"
)  


## ----filter--------------------------------------------------------------
microbenchmark(
  dplyr_df = filter(players_df, G == max(G)),
  dplyr_dt = filter(players_dt, G == max(G)),
  base   =   batting_df[ave(batting_df$G, batting_df$playerID, FUN = max) ==
    batting_df$G, ],
  times = 2, 
  unit = "ms"  
)


## ----mutate--------------------------------------------------------------
microbenchmark(
  dplyr_df  = mutate(players_df, rank = rank(desc(AB))),
  dplyr_dt  = mutate(players_dt, rank = rank(desc(AB))),
  dt_raw =    players_dt[, list(rank = rank(desc(AB))), by = playerID],
  times = 2, 
  unit = "ms"
)


## ----mutate2-------------------------------------------------------------
microbenchmark(
  dplyr_df = mutate(players_df, cyear = yearID - min(yearID) + 1),
  dplyr_dt = mutate(players_dt, cyear = yearID - min(yearID) + 1),
  dt_raw =   players_dt[, list(cyear = yearID - min(yearID) + 1), by = playerID],
  times = 5, 
  unit = "ms"
)


## ----mutate_hybrid-------------------------------------------------------
microbenchmark(
  dplyr_df  = mutate(players_df, rank = min_rank(AB)),
  dplyr_dt  = mutate(players_dt, rank = min_rank(AB)),
  dt_raw =    players_dt[, list(rank = min_rank(AB)), by = playerID],
  times = 2, 
  unit = "ms"
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
  times = 10, 
  unit = "ms"
)

microbenchmark(
  dplyr_df = inner_join(master_df, hall_of_fame_df, by = "hofID"),
  dplyr_dt = inner_join(master_dt, hall_of_fame_dt, by = "hofID"),
  base     = merge(master_df, hall_of_fame_df, by = "hofID"),
  times = 10, 
  unit = "ms"
)

microbenchmark(
  dplyr_df = semi_join(master_df, hall_of_fame_df, by = "hofID"),
  dplyr_dt = semi_join(master_dt, hall_of_fame_dt, by = "hofID"),
  times = 10, 
  unit = "ms"
)

microbenchmark(
  dplyr_df = anti_join(master_df, hall_of_fame_df, by = "hofID"),
  dplyr_dt = anti_join(master_dt, hall_of_fame_dt, by = "hofID"),
  times = 10, 
  unit = "ms"
)


