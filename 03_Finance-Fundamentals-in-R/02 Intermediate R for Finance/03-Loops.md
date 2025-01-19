Intermediate R for Finance
================

### Module 03 - Loops

#### repeat

You must specify when you want to **break** out of the loop.

``` r
# Stock price
stock_price <- 126.34

repeat {
  # New stock price
  stock_price <- stock_price * runif(1, .985, 1)
  print(stock_price)
  
  # Check
  if(stock_price < 125) {
    print("Stock price is below 125! Buy it while it's cheap!")
    break
  }
}
```

    ## [1] 126.2403
    ## [1] 124.6942
    ## [1] "Stock price is below 125! Buy it while it's cheap!"

#### while

``` r
# Initial debt
debt <- 5000

# While loop to pay off your debt
while (debt > 0) {
  debt <- debt - 500
  print(paste("Debt remaining", debt))
}
```

    ## [1] "Debt remaining 4500"
    ## [1] "Debt remaining 4000"
    ## [1] "Debt remaining 3500"
    ## [1] "Debt remaining 3000"
    ## [1] "Debt remaining 2500"
    ## [1] "Debt remaining 2000"
    ## [1] "Debt remaining 1500"
    ## [1] "Debt remaining 1000"
    ## [1] "Debt remaining 500"
    ## [1] "Debt remaining 0"

while with break:

``` r
# debt and cash
debt <- 5000
cash <- 4000

# Pay off your debt...if you can!
while (debt > 0) {
  debt <- debt - 500
  cash <- cash - 500
  print(paste("Debt remaining:", debt, "and Cash remaining:", cash))

  if (cash == 0) {
    print("You ran out of cash!")
    break
  }
}
```

    ## [1] "Debt remaining: 4500 and Cash remaining: 3500"
    ## [1] "Debt remaining: 4000 and Cash remaining: 3000"
    ## [1] "Debt remaining: 3500 and Cash remaining: 2500"
    ## [1] "Debt remaining: 3000 and Cash remaining: 2000"
    ## [1] "Debt remaining: 2500 and Cash remaining: 1500"
    ## [1] "Debt remaining: 2000 and Cash remaining: 1000"
    ## [1] "Debt remaining: 1500 and Cash remaining: 500"
    ## [1] "Debt remaining: 1000 and Cash remaining: 0"
    ## [1] "You ran out of cash!"

#### for loop

``` r
# Sequence
seq <- c(1:10)

# Print loop
for (value in seq) {
    print(value)
}
```

    ## [1] 1
    ## [1] 2
    ## [1] 3
    ## [1] 4
    ## [1] 5
    ## [1] 6
    ## [1] 7
    ## [1] 8
    ## [1] 9
    ## [1] 10

``` r
# A sum variable
sum <- 0

# Sum loop
for (value in seq) {
    sum <- sum + value
    print(sum)
}
```

    ## [1] 1
    ## [1] 3
    ## [1] 6
    ## [1] 10
    ## [1] 15
    ## [1] 21
    ## [1] 28
    ## [1] 36
    ## [1] 45
    ## [1] 55

Looping over data frame rows:

``` r
# Loop over stock rows
for (row in 1:nrow(stock)) {
    price <- stock[row, "apple"]
    date  <- stock[row, "date"]

    if(price > 116) {
        print(paste("On", date, 
                    "the stock price was", price))
    } else {
        print(paste("The date:", date, 
                    "is not an important day!"))
    }
}
```

**break** and **next** in for loop:

``` r
# Print apple
apple

# Loop through apple. Next if NA. Break if above 117.
for (value in apple) {
    if(is.na(value)) {
        print("Skipping NA")
        next
    }
    
    if(value > 117) {
        print("Time to sell!")
        break
    } else {
        print("Nothing to do here!")
    }
}
```
