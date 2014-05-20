
## ----, echo = FALSE, message = FALSE-------------------------------------
library(dplyr)
knitr::opts_chunk$set(
  comment = "#>",
  error = FALSE,
  tidy = FALSE)
options(dplyr.print_min = 4L, dplyr.print_max = 4L)


## ----, eval = FALSE------------------------------------------------------
## my_db <- src_sqlite("my_db.sqlite3", create = T)


## ----, eval = FALSE------------------------------------------------------
## data("hflights", package = "hflights")
## hflights_sqlite <- copy_to(my_db, hflights, temporary = FALSE, indexes = list(
##   c("Year", "Month", "DayofMonth"), "UniqueCarrier", "TailNum"))


## ------------------------------------------------------------------------
hflights_sqlite <- tbl(hflights_sqlite(), "hflights")
hflights_sqlite


## ----, eval = FALSE------------------------------------------------------
## tbl(my_db, sql("SELECT * FROM hflights"))


## ------------------------------------------------------------------------
select(hflights_sqlite, Year:DayofMonth, DepDelay, ArrDelay)
filter(hflights_sqlite, depDelay > 240)
arrange(hflights_sqlite, Year, Month, DayofMonth)
mutate(hflights_sqlite, speed = AirTime / Distance)
summarise(hflights_sqlite, delay = mean(DepTime))


## ------------------------------------------------------------------------
c1 <- filter(hflights_sqlite, DepDelay > 0)
c2 <- select(c1, Year, Month, DayofMonth, UniqueCarrier, DepDelay, AirTime, Distance)
c3 <- mutate(c2, Speed = Distance / AirTime * 60)
c4 <- arrange(c3, Year, Month, DayofMonth, UniqueCarrier)


## ------------------------------------------------------------------------
c4


## ------------------------------------------------------------------------
collect(c4)


## ------------------------------------------------------------------------
c4$query


## ------------------------------------------------------------------------
explain(c4)


## ------------------------------------------------------------------------
# In SQLite variable names are escaped by double quotes:
translate_sql(x)
# And strings are escaped by single quotes
translate_sql("x")

# Many functions have slightly different names
translate_sql(x == 1 && (y < 2 || z > 3))
translate_sql(x ^ 2 < 10)
translate_sql(x %% 2 == 10)

# R and SQL have different defaults for integers vs reals.
# In R, 1 is an real, and 1L is an integer
# In SQL, 1 is an integer, and 1.0 is a real
translate_sql(1)
translate_sql(1L)


## ----, eval = FALSE------------------------------------------------------
## translate_sql(mean(x, trim = T))
## # Error: Invalid number of args to SQL AVG. Expecting 1


## ------------------------------------------------------------------------
translate_sql(glob(x, y))
translate_sql(x %like% "ab*")


## ------------------------------------------------------------------------
planes <- group_by(hflights_sqlite, TailNum)
delay <- summarise(planes,
  count = n(),
  dist = mean(Distance),
  delay = mean(ArrDelay)
)
delay <- filter(delay, count > 20, dist < 2000)
delay_local <- collect(delay)


## ------------------------------------------------------------------------
if (has_lahman("postgres")) {
  hflights_postgres <- tbl(src_postgres("hflights"), "hflights")
}


## ------------------------------------------------------------------------
if (has_lahman("postgres")) {
  daily <- group_by(hflights_postgres, Year, Month, DayofMonth)

  # Find the most and least delayed flight each day
  bestworst <- filter(daily, ArrDelay == min(ArrDelay) ||
    ArrDelay == max(ArrDelay))
  bestworst$query

  # Rank each flight within a daily
  ranked <- mutate(daily, rank = rank(desc(ArrDelay)))
  ranked$query
}


