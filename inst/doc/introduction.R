
## ----, echo = FALSE, message = FALSE-------------------------------------
library(dplyr)
library(ggplot2)
knitr::opts_chunk$set(
  comment = "#>",
  error = FALSE,
  tidy = FALSE)
options(dplyr.print_min = 4L, dplyr.print_max = 4L)


## ------------------------------------------------------------------------
library(hflights)
dim(hflights)
head(hflights)


## ------------------------------------------------------------------------
hflights_df <- tbl_df(hflights)
hflights_df


## ------------------------------------------------------------------------
filter(hflights_df, Month == 1, DayofMonth == 1)


## ----, eval = FALSE------------------------------------------------------
## hflights[hflights$Month == 1 & hflights$DayofMonth == 1, ]


## ----, eval = FALSE------------------------------------------------------
## filter(hflights_df, Month == 1 | Month == 2)


## ------------------------------------------------------------------------
arrange(hflights_df, DayofMonth, Month, Year)


## ------------------------------------------------------------------------
arrange(hflights_df, desc(ArrDelay))


## ----, eval = FALSE------------------------------------------------------
## hflights[order(hflights$DayofMonth, hflights$Month, hflights$Year), ]
## hflights[order(desc(hflights$ArrDelay)), ]


## ------------------------------------------------------------------------
# Select columns by name
select(hflights_df, Year, Month, DayOfWeek)
# Select all columns between Year and DayOfWeek (inclusive)
select(hflights_df, Year:DayOfWeek)
# Select all columns except those from Year to DayOfWeek (inclusive)
select(hflights_df, -(Year:DayOfWeek))


## ------------------------------------------------------------------------
mutate(hflights_df,
  gain = ArrDelay - DepDelay,
  speed = Distance / AirTime * 60)


## ------------------------------------------------------------------------
mutate(hflights_df,
  gain = ArrDelay - DepDelay,
  gain_per_hour = gain / (AirTime / 60)
)


## ----, eval = FALSE------------------------------------------------------
## transform(hflights,
##   gain = ArrDelay - DepDelay,
##   gain_per_hour = gain / (AirTime / 60)
## )
## #> Error: object 'gain' not found


## ------------------------------------------------------------------------
summarise(hflights_df,
  delay = mean(DepDelay, na.rm = TRUE))


## ----, warning = FALSE, message = FALSE----------------------------------
planes <- group_by(hflights_df, TailNum)
delay <- summarise(planes,
  count = n(),
  dist = mean(Distance, na.rm = TRUE),
  delay = mean(ArrDelay, na.rm = TRUE))
delay <- filter(delay, count > 20, dist < 2000)

# Interestingly, the average delay is only slightly related to the
# average distance flown a plane.
ggplot(delay, aes(dist, delay)) +
  geom_point(aes(size = count), alpha = 1/2) +
  geom_smooth() +
  scale_size_area()


## ------------------------------------------------------------------------
destinations <- group_by(hflights_df, Dest)
summarise(destinations,
  planes = n_distinct(TailNum),
  flights = n()
)


## ------------------------------------------------------------------------
daily <- group_by(hflights_df, Year, Month, DayofMonth)
(per_day   <- summarise(daily, flights = n()))
(per_month <- summarise(per_day, flights = sum(flights)))
(per_year  <- summarise(per_month, flights = sum(flights)))


## ----, eval = FALSE------------------------------------------------------
## a1 <- group_by(hflights, Year, Month, DayofMonth)
## a2 <- select(a1, Year:DayofMonth, ArrDelay, DepDelay)
## a3 <- summarise(a2,
##   arr = mean(ArrDelay, na.rm = TRUE),
##   dep = mean(DepDelay, na.rm = TRUE))
## a4 <- filter(a3, arr > 30 | dep > 30)


## ------------------------------------------------------------------------
filter(
  summarise(
    select(
      group_by(hflights, Year, Month, DayofMonth),
      Year:DayofMonth, ArrDelay, DepDelay
    ),
    arr = mean(ArrDelay, na.rm = TRUE),
    dep = mean(DepDelay, na.rm = TRUE)
  ),
  arr > 30 | dep > 30
)


## ----, eval = FALSE------------------------------------------------------
## hflights %>%
##   group_by(Year, Month, DayofMonth) %>%
##   select(Year:DayofMonth, ArrDelay, DepDelay) %>%
##   summarise(
##     arr = mean(ArrDelay, na.rm = TRUE),
##     dep = mean(DepDelay, na.rm = TRUE)
##   ) %>%
##   filter(arr > 30 | dep > 30)


