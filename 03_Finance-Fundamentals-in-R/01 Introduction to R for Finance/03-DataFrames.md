Introduction to R for Finance
================

### Module 03 - DataFrames

DataFrames can store different types of data.

Use constructor **data.frame()** to create one.

``` r
# Variables
company <- c("A", "A", "A", "B", "B", "B", "B")
cash_flow <- c(1000, 4000, 550, 1500, 1100, 750, 6000)
year <- c(1, 3, 4, 1, 2, 4, 5)

# DataFrame
cash <- data.frame(company, cash_flow, year)
cash
```

    ##   company cash_flow year
    ## 1       A      1000    1
    ## 2       A      4000    3
    ## 3       A       550    4
    ## 4       B      1500    1
    ## 5       B      1100    2
    ## 6       B       750    4
    ## 7       B      6000    5

``` r
head(cash, n=4)
```

    ##   company cash_flow year
    ## 1       A      1000    1
    ## 2       A      4000    3
    ## 3       A       550    4
    ## 4       B      1500    1

``` r
tail(cash, n=3)
```

    ##   company cash_flow year
    ## 5       B      1100    2
    ## 6       B       750    4
    ## 7       B      6000    5

``` r
# Structure of the DataFrame
str(cash)
```

    ## 'data.frame':    7 obs. of  3 variables:
    ##  $ company  : chr  "A" "A" "A" "B" ...
    ##  $ cash_flow: num  1000 4000 550 1500 1100 750 6000
    ##  $ year     : num  1 3 4 1 2 4 5

Use **colnames()** and **rownames()** to rename col/row functions.

``` r
colnames(cash)
```

    ## [1] "company"   "cash_flow" "year"

``` r
colnames(cash) <- c("company", "cashflow", "year")
colnames(cash)
```

    ## [1] "company"  "cashflow" "year"

``` r
rownames(cash)
```

    ## [1] "1" "2" "3" "4" "5" "6" "7"

To subset a DataFrame use brackets: **dataframe\[row, col\]**

``` r
cash[3,2]
```

    ## [1] 550

``` r
cash[,"company"]
```

    ## [1] "A" "A" "A" "B" "B" "B" "B"

To acccess a column in a df, you can also use: **dataframe\$col**

``` r
cash$year
```

    ## [1] 1 3 4 1 2 4 5

``` r
cash$cashflow * 2
```

    ## [1]  2000  8000  1100  3000  2200  1500 12000

``` r
# Delete a column
cash$company <- NULL
cash
```

    ##   cashflow year
    ## 1     1000    1
    ## 2     4000    3
    ## 3      550    4
    ## 4     1500    1
    ## 5     1100    2
    ## 6      750    4
    ## 7     6000    5

To filter a df with conditions, use function **subset()**

``` r
subset(cash, company == "B")
```

    ##   cashflow year
    ## 4     1500    1
    ## 5     1100    2
    ## 6      750    4
    ## 7     6000    5

``` r
subset(cash, year == 1)
```

    ##   cashflow year
    ## 1     1000    1
    ## 4     1500    1

To append a new column, **dataframe\$new_col**

``` r
cash$double_year <- cash$year * 2
```

To append a new row, use **rbind()**

``` r
df1 <- c(10, 1000)
names(df1) <- c("eta", "valore")

df2 <- c(15, 800)
names(df2) <- c("eta", "valore")

df <- rbind(df1, df2)
df
```

    ##     eta valore
    ## df1  10   1000
    ## df2  15    800

Exercise: calculate the present value of projected cash flows.

``` r
# Present value of $4000, in 3 years, at 5%
present_value_4k <- 4000 * (1.05)^-3

# Present value of all cash flows at 5%
cash$present_value <- cash$cashflow * (1.05)^-cash$year
cash
```

    ##   cashflow year double_year present_value
    ## 1     1000    1           2      952.3810
    ## 2     4000    3           6     3455.3504
    ## 3      550    4           8      452.4864
    ## 4     1500    1           2     1428.5714
    ## 5     1100    2           4      997.7324
    ## 6      750    4           8      617.0269
    ## 7     6000    5          10     4701.1570
