Intermediate R for Finance
================

### Module 02 - Logical Operators

``` r
# Stock prices
apple <- 48.99
micr <- 77.93

# Apple vs. Microsoft
apple > micr
## [1] FALSE

# Not equals
apple != micr
## [1] TRUE

# Dates - today and tomorrow
today <- as.Date(Sys.Date())
tomorrow <- as.Date(Sys.Date() + 1)

# Today vs. Tomorrow
tomorrow < today
## [1] FALSE
```

``` r
# IBM buy range 
stocks$ibm_buy_range <- (stocks$ibm > 171) & (stocks$ibm < 176)

# Panera spikes 
stocks$panera_spike <- (stocks$panera < 213.2) | (stocks$panera > 216.5)

# Date range
stocks$good_dates <- (stocks$date > as.Date("2017-01-21")) & (stocks$date < as.Date("2017-01-25"))

###

# Missing data
missing <- c(24.5, 25.7, NA, 28, 28.6, NA)

# Is missing?
is.na(missing)

# Not missing?
!(is.na(missing))

###

# Panera range
subset(stocks, panera > 216)

# Specific date
subset(stocks, date == as.Date("2017-01-23"))

# IBM and Panera joint range
subset(stocks, ibm < 175 & panera < 216.5)

###

# Weekday investigation
stocks$weekday <- weekdays(stocks$date)

# Remove missing data
stocks_no_NA <- subset(stocks, !is.na(apple))

# Apple and Microsoft joint range
subset(stocks_no_NA, apple > 117 | micr > 63)
```

If statement

``` r
micr <- 48.55

if( micr < 55 ) {
    print("Buy!")
}
## [1] "Buy!"

###

micr <- 57.44

# Fill in the blanks
if( micr < 55 ) {
    print("Buy!")
} else {
    print("Do nothing!")
}
## [1] "Do nothing!"

###

micr <- 105.67

# Fill in the blanks
if( micr < 55 ) {
    print("Buy!")
} else if( micr >= 55 & micr < 75 ){
    print("Do nothing!")
} else { 
    print("Sell!")
}
## [1] "Sell!"

###

micr <- 105.67
shares <- 1

# Fill in the blanks
if( micr < 55 ) {
    print("Buy!")
} else if( micr >= 55 & micr < 75 ) {
    print("Do nothing!")
} else { 
    if( shares >= 1 ) {
        print("Sell!")
    } else {
        print("Not enough shares to sell!")
    }
}
## [1] "Sell!"
```

**ifelse()** creates an if statement in 1 line of code

``` r
# Microsoft test
stocks$micr_buy <- ifelse(test = stocks$micr > 60 & stocks$micr < 62, yes = 1, no = 0)

# Apple test
stocks$apple_date <- ifelse(test = stocks$apple > 117, yes = stocks$date, no = NA)

# Change the class() of apple_date.
class(stocks$apple_date) <- "Date"
```
