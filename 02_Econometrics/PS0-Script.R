# 1)

v1 <- c(1:20)
v2 <- c(19:1)
v <- c(v1,v2)
sum(v)
mean(v)

# 2)

sample <- rnorm(40, mean=10, sd=sqrt(9))
sample

# 3)

sample_mean <- mean(sample)
sample_red <- sample - sample_mean

# 4)

sample_red_shuffle <- sample(sample_red, 40)
sample_red_shuffle

# 5)

sample_max <- which(sample == max(sample))
sample_min <- which(sample == min(sample))

# 6)

sample[sample_max] <- NA
sample[sample_min] <- NA
range(sample, na.rm=TRUE)

# 7)

sum <- 0
for(i in 10:100){
  sum <- sum + i^3 + 4*(i^2)
}

# 8)

isSquare <- function(x) {
  x <- ifelse(x>0, x, NA)
  (sqrt(x) %% 1) == 0
}

for(i in 18354:18796){
  if(isSquare(i))
    print(i)
}

# 9)

v <- c(1:9)
matrix(v, 3, 3)

# 10)

v1 <- c(1:3)
v2 <- c(2:4)
v3 <- c(3:5)
cbind(v1,v2,v3)
cbind(1:3,2:4,3:5)

# 11)

# Generate a dataset for the Munich housing market
set.seed(123)
n <- 10000
house_size <- rnorm(n, mean = 100, sd = 25)
num_rooms <- rpois(n, lambda = 4)
school_quality <- sample(1:10, n, replace = TRUE)
is_renovated <- rbinom(n, 1, prob = 0.2)
house_price <- 200 + 3 * house_size + 20 * num_rooms + 10 * school_quality +
  50 * is_renovated + rnorm(n, mean = 0, sd = 50)

data <- data.frame(house_size, num_rooms, school_quality, is_renovated, house_price)

# Load required library
library(ggplot2)

# Simple Linear Regression: house_price ~ school_quality
fit1 <- lm(house_price ~ house_size, data=data)

# Summary of the fit
summary(fit1)

# Plotting
ggplot(data, aes(x = house_size, y = house_price)) + geom_point() + geom_smooth(method = "lm")

# Interpretation: The coefficient for ’house_size’ represents the change in ’house_price’
# for a one-unit change in ’house_size’.