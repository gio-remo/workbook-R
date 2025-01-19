Intermediate R for Finance
================

### Module 05 - apply

#### lapply()

When you have a list, and you want to apply the same function to each
element of the list.

``` r
v <- list(c(1:10), c("a", "b", "c"))
lapply(v, FUN=length)
```

    ## [[1]]
    ## [1] 10
    ## 
    ## [[2]]
    ## [1] 3

Call lapply() with custom function

``` r
# Print stock_return
stock_return

# lapply to get the average returns
lapply(stock_return, FUN = mean)

# Sharpe ratio
sharpe <- function(returns) {
    (mean(returns) - .0003) / sd(returns)
}

# lapply to get the sharpe ratio
lapply(stock_return, FUN = sharpe)
```

Call lapply() with custom function & parameters

``` r
# Extend sharpe() to allow optional argument
sharpe <- function(returns, rf = .0003) {
    (mean(returns) - rf) / sd(returns)
}

# First lapply()
lapply(stock_return, FUN=sharpe, rf=.0004)

# Second lapply()
lapply(stock_return, FUN=sharpe, rf=.0009)
```
