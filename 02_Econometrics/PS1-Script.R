####### ECONOMETRICS FOR M.Sc. STUDENTS #####
####### PROBLEM SET 1: R CODE ###############
#############################################

setwd("/home/sebastian/github/metrics/tutorials/tutorial_1")

library(pacman)
p_load(dplyr, cowplot, grid, gridGraphics, readr, ggplot2)

params <- list(show_solutions = FALSE, show_explain = TRUE)

set.seed(241023)

## Q 12 -----------------------------------------------------------------------

# With sample size 100

samp_size<-100
r<-1000
mu<-10
sigma2<-9

draw_est<- function(n) {
  samp<- rnorm(n=n, mean= mu, sd=sqrt(sigma2))
  mu_hat <- mean(samp)
  return(mu_hat)
}

mu_hats <- replicate(r, draw_est(n = samp_size))
head(mu_hats)

rnorm(n=10, mean = 0, sd = 1)

## Q 13 -----------------------------------------------------------------------

mean(mu_hats)
var(mu_hats)

## Q 14 -----------------------------------------------------------------------

n_max <- 1000

mu_hat <- sapply(
  1:n_max,
  draw_est
)

plot(mu_hat, type = "l", xlab = "N")
abline(h = mu, lty = "dashed")

start_point <- 51
plot(start_point:n_max, mu_hat[start_point:n_max], type = "l", xlab = "N", xlim = c(start_point, n_max))
abline(h = mu, lty = "dashed")

## Q 15 -----------------------------------------------------------------------

draw_est<- function(n) {
  samp<- rnorm(n=n, mean= mu, sd=sqrt(sigma2))
  mu_hat <- sqrt(n)*(mean(samp) - mu)
  return(mu_hat)
}

sim_dist<- function(n) {
  mu_hats<-replicate(r, draw_est(n))
  return(mu_hats)
}

mu_hats<-sim_dist(samp_size)

title <-paste0("N=", samp_size)
xlabel<- expression(sqrt(N) %*%(hat(mu) - mu))
# type ?plotmath for more info on written in mathematical notation

hist(mu_hats, breaks = 30, freq = FALSE, main =title, xlab = xlabel)

# With normal curve
hist(mu_hats, breaks = 30, freq = FALSE, main = title, xlab = xlabel)
curve(dnorm(x, sd = sqrt(sigma2)), add = TRUE)


# With 4 different sample sizes
require(cowplot)
ns <- c(2, 100, 1000, 4000)

graph_dist <- function(n) {
  mu_hats <- sim_dist(n)
  title <- paste0("N=", n)
  xlabel <- "sqrt(N) X (hat(mu) - mu)"
  return({
    hist(mu_hats, breaks = 30, freq = FALSE, main = title, xlab = xlabel)
    curve(dnorm(x, sd = sqrt(sigma2)), add = TRUE)
  })
}

# Calculate means and variances
cat("Means:", sep = "\n")
sapply(ns, function(x) mean(sim_dist(x)))
cat("Variances:", sep = "\n")
sapply(ns, function(x) var(sim_dist(x)))

# Note the "~" before the function!
p1 <- ~graph_dist(ns[1])
p2 <- ~graph_dist(ns[2])
p3 <- ~graph_dist(ns[3])
p4 <- ~graph_dist(ns[4])

plot_grid(p1,p2,p3,p4)
plot_grid(p4)

## Q 16 -----------------------------------------------------------------------

ns <- c(2, 10, 30, 50)
df <- 1

mu <- df # mean of chi2 dist is k (degrees-of-freedom)
sigma2 <- 2 * df # variance of chi2 dist is 2k

draw_est <- function(n) {
  samp <- rchisq(n = n, df = df)
  mu_hat <- sqrt(n) * (mean(samp) - mu)
  return(mu_hat)
}

graph_dist <- function(n) {
  mu_hats <- sim_dist(n)
  title <- paste0("N=", n)
  xlabel <- "sqrt(N) X (hat(mu) - mu)"
  return({
    hist(
      mu_hats, breaks = 30, freq = FALSE, main = title, xlab = xlabel, xlim = c(-4, 10)
    )
    curve(dnorm(x, sd = sqrt(sigma2)), add = TRUE) })
}

# Calculate means and variances
cat("Means:", sep = "\n")
sapply(ns, function(x) mean(sim_dist(x)))
cat("Variances:", sep = "\n")
sapply(ns, function(x) var(sim_dist(x)))

# Plot the distributions for the 4 different sample sizes
p1 <- ~graph_dist(ns[1])
p2 <- ~graph_dist(ns[2])
p3 <- ~graph_dist(ns[3])
p4 <- ~graph_dist(ns[4])

plot_grid(p1,p2,p3,p4)


## Q 17 -----------------------------------------------------------------------

ns <- c(2, 10, 30, 50)
mu <- 10
sigma2 <- 9

draw_est <- function(n) {
  samp <- rnorm(n=n, mean = mu, sd = sqrt(sigma2))
  mu_hat <- samp[1] # the estimation of mu'
  return(mu_hat)
}

graph_dist <- function(n) {
  mu_hats <- sim_dist(n)
  title <- paste0("N=", n)
  xlabel <- "mu[1]"
  return({
    hist(
    mu_hats, breaks = 30, freq = FALSE, main = title, xlab = xlabel, xlim = c(0,20)
    )
  })
}

# Calculate means and variances
cat("Means:", sep = "\n")
sapply(ns, function(x) mean(sim_dist(x)))
cat("Variances:", sep = "\n")
sapply(ns, function(x) var(sim_dist(x)))

# Plot the distributions for the 4 different sample sizes
p1 <- ~graph_dist(ns[1])
p2 <- ~graph_dist(ns[2])
p3 <- ~graph_dist(ns[3])
p4 <- ~graph_dist(ns[4])

plot_grid(p1,p2,p3,p4)


## Q 18 -----------------------------------------------------------------------

ns <- c(2, 10, 30, 50) 
samp_size <- 5
r <- 1000


draw_est <- function(n) {
  samp <- rnorm(n=n, mean = mu, sd = sqrt(sigma2))
  mu_hat <- (5 * (samp[1] / n)) + n^(-1) * sum(samp) # the estimation of mu*
  return(mu_hat)
}

graph_dist <- function(n) {
  mu_hats <- sim_dist(n)
  title <- paste0("N=", n)
  xlabel <- "5 X mu[1]/n + 1/n X mu"
return({ hist(
  mu_hats, breaks = 30, freq = FALSE, main = title, xlab = xlabel,
  xlim = c(0, 60) )
  })
}

# Calculate means and variances
cat("Means:", sep = "\n")
sapply(ns, function(x) mean(sim_dist(x)))
cat("Variances:", sep = "\n")
sapply(ns, function(x) var(sim_dist(x)))

# Plot the distributions for the 4 different sample sizes
p1 <- ~graph_dist(ns[1])
p2 <- ~graph_dist(ns[2])
p3 <- ~graph_dist(ns[3])
p4 <- ~graph_dist(ns[4])

plot_grid(p1,p2,p3,p4)


## Q 20 -----------------------------------------------------------------------

X <- read_csv("X.csv")
View(X)
x_plot <- ggplot(X, aes( x = x, y = y)) +
  geom_point()
x_plot


## Q21: Calculate conditional means using dplyr --------------------------------
con_means <- X %>% 
  group_by(x) %>% 
  summarise(mean_y = mean(y)) %>% 
  rename(m = x)


## Q 22 -----------------------------------------------------------------------

lfit <- lm(y ~ x, data = X)

# Create a ggplot object
p <- ggplot(X, aes(x = x, y = y)) +
  geom_point() +  # Plot the points
  geom_smooth(method = "lm", se = FALSE)  # Add a linear fit

# Display the plot
p

## Q 23 -----------------------------------------------------------------------
p_cond <- ggplot(X, aes(x = x, y = y)) +
  geom_point(aes(color = "Data Points")) +  # Plot the raw data points
  geom_smooth(method = "lm", aes(color = "Linear Fit"), se = FALSE, color = "black") +  # Add a linear fit
  geom_point(data = con_means, aes(y = mean_y, x = m, color = "Conditional Means"))  # Add conditional means

# Display the plot
p_cond

## Q 24 -----------------------------------------------------------------------
# Create the base ggplot object
p2 <- ggplot(X, aes(x = x, y = y))

# Add the original data points
p2 <- p2 + geom_point(aes(color = "Data Points"), size = 3)

# Add the linear fit
p2 <- p2 + geom_smooth(method = "lm", aes(color = "Linear Fit"), se = FALSE)

# Add the conditional means
p2 <- p2 + geom_point(data = con_means, aes(x = m, y = mean_y, color = "Conditional Means"), size = 5)

# Add the polynomial curve
lfit2 <- lm(y ~ poly(x, 2, raw = TRUE), data = X)
p2 <- p2 + stat_function(fun = function(x) predict(lfit2, newdata = data.frame(x = x)), aes(color = "Polynomial Fit"))

# Customize the color scale and other plot aspects
p2 <- p2 + scale_color_manual(values = c("Data Points" = "grey45", "Linear Fit" = "red", "Conditional Means" = "blue", "Polynomial Fit" = "green"))

# Display the plot
print(p2)