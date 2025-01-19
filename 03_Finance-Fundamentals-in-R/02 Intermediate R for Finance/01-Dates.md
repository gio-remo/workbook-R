Intermediate R for Finance
================

### Module 01 - Dates

The two main classes of data for this are Date and POSIXct:

- Date is used for calendar date objects like “2015-01-22”

- POSIXct is a way to represent datetime objects like “2015-01-22
  08:39:40 EST”

``` r
# Current date
Sys.Date()
```

    ## [1] "2025-01-19"

``` r
# Current date+time
Sys.time()
```

    ## [1] "2025-01-19 17:47:49 CET"

``` r
today <- Sys.Date()
class(today)
```

    ## [1] "Date"

To convert string (yyyy-mm-dd) to Date use as.Date():

``` r
# Date
crash <- as.Date("2008-09-29")
crash
```

    ## [1] "2008-09-29"

``` r
# String as Numeric (= days since January, 1 1970)
as.numeric(crash)
```

    ## [1] 14151

``` r
as.numeric(Sys.time())
```

    ## [1] 1737305270

To convert multiple dates from character to date format, you can do this
all at once using *vectors*.

``` r
# Vector
dates <- c("2017-02-05", "2017-02-06", "2017-02-07", "2017-02-08")

# Names
names(dates) <- c("Sunday", "Monday", "Tuesday", "Wednesday")
dates
```

    ##       Sunday       Monday      Tuesday    Wednesday 
    ## "2017-02-05" "2017-02-06" "2017-02-07" "2017-02-08"

``` r
# Subset "Monday"
dates[2]
```

    ##       Monday 
    ## "2017-02-06"

Specify Date format with its parameter:

``` r
as.Date("Ago 30, 1930", format = "%b %d, %Y")
## [1] "1930-08-30"

as.Date("12.05.00", format="%d.%m.%y")
## [1] "2000-05-12"

# Vector
char_dates <- c("1gen17", "2gen17", "3gen17", "4gen17", "5gen7")

# Create dates using as.Date() and the correct format 
dates <- as.Date(char_dates, format = "%e%b%y")

# Use format() to go from "2017-01-04" -> "Jan 04, 17"
format(dates, format = "%b %d, %y")
## [1] "gen 01, 17" "gen 02, 17" "gen 03, 17" "gen 04, 17" "gen 05, 07"

# Use format() to go from "2017-01-04" -> "01,04,2017"
format(dates, format = "%m,%d,%Y")
## [1] "01,01,2017" "01,02,2017" "01,03,2017" "01,04,2017" "01,05,2007"
```

Date difference:

``` r
today <- Sys.Date()
today
## [1] "2025-01-19"

tomor <- Sys.Date() + 1
tomor
## [1] "2025-01-20"

# Difference
tomor - today
## Time difference of 1 days

# Difference format
difftime(tomor, today, units = "hours")
## Time difference of 24 hours
```

A few functions useful for extracting date components: **months()
weekdays() quarters()**

``` r
dates <- as.Date(c("2017-01-02", "2017-05-03", "2017-08-04", "2017-10-17"))

# Months
months(dates)
## [1] "gennaio" "maggio"  "agosto"  "ottobre"

# Quarters
quarters(dates)
## [1] "Q1" "Q2" "Q3" "Q4"

dates2 <- as.Date(c("2017-01-02", "2017-01-03", "2017-01-04", "2017-01-05"))

# Assign the weekdays() of dates2 as the names()
names(dates2) <- weekdays(dates2)

# Print dates2
dates2
##       lunedì      martedì    mercoledì      giovedì 
## "2017-01-02" "2017-01-03" "2017-01-04" "2017-01-05"
```
