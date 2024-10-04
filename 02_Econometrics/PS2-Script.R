rm(list=ls())

require(pacman)
p_load(haven, mvtnorm, sandwich)

setwd("C:/Users/remon/OneDrive/_Uni/3 WS 23-24/3 Econ/TUT")

airfare <- read_dta("http://fmwww.bc.edu/ec-p/data/wooldridge2k/airfare.dta")

X <- as.matrix(airfare[c("ldist","concen")])
y <- as.matrix(airfare[c("lfare")])

#Q1.3
X <- cbind(rep(1, times = nrow(X)), X)
colnames(X)
colnames(X)[1] <- "intercept"
head(X)

#Q1.4 X'X
varcov <- t(X) %*% X
# varcov <- crossprod(X)
varcov

#Q1.5 inverse
varcov_inv <- solve(varcov)
varcov_inv

#Q1.7 X'y
cov_xy <- t(X) %*% y
cov_xy

#Q1.8
dim(varcov)
dim(varcov_inv)
dim(cov_xy)

betas <- varcov_inv %*% cov_xy
betas

#Q1.10 y - yhat! yhat = X*beta_hat 
resid <- y - X %*% betas 
head(resid)

SSR <- sum(resid^2)
SSR

#Q1.11
sigma2 <- SSR / (nrow(X) - ncol(X))
sigma2

#Q1.12 
cov_beta <- sigma2 * varcov_inv
cov_beta

#Q.13
ses <- sqrt(diag(cov_beta))
ses

# We access the first column of the betas (the only column) so both 
# the numerator and the denominator are vectors
tstats <- betas[,1] / ses
tstats

# or transpose the beta vector
# tstats = t(betas) / ses
# tstats

df <- nrow(X) - ncol(X)
# We are doing a two-sided test, so we need to multiply the p-values by two
pvalues <- pt(tstats, df, lower.tail = FALSE) * 2
pvalues

lfit <- lm(lfare ~ ldist + concen,data=airfare)
summary(lfit)$coefficients
summary(lfit)$coefficients[, 4]

# 2) OLS with Simulated Data
# Q2.15
obs <- 1000
x0 <- rep(1, times=obs)
x1 <- rnorm(n=obs,mean=2, sd=3)
x2 <- rnorm(obs,7,1)
u <- rnorm(obs,0,2)

y <- 10*x0 - 3*x1 + 5*x2 + u

beta1hat <- cov(x1,y)/var(x1)
beta1hat
beta2hat <- cov(x2,y)/var(x2)
beta2hat

beta0hat <- mean(y) - beta1hat * mean(x1) - beta2hat * mean(x2)
beta0hat

lfit <- lm(y ~ x1 + x2)
lfit$coefficients

cov(x1,x2) # covariance is almost zero


# Excursion: Generating Correlated Variables
varcov_corr <- matrix(c(1, 0.3, 0.3, 1), nrow = 2)
X <- rmvnorm(1000000, mean = c(0,0), sigma = varcov_corr)

colMeans(X)
cov(X)

#Q2.16
require(sandwich)
set.seed(1019)

samp_size <- 1000
reps <- 800

draw_sample <- function(n) {
  x <- rchisq(n, df=10)
  u <- rnorm(n, 0, sd=abs(3*x))
  y <- 1 - 2*x + u
  
  return(list(y=y, x=x))
}

lfit_extract_betas <-function(n) { 
  samp <- draw_sample(n)
  
  lfit <- lm(y ~ x, data=samp)
  
  beta0 <- coef(lfit)["(Intercept)"]
  beta1 <- coef(lfit)["x"]
  
  homvc <- vcov(lfit)
  hetvc <- vcovHC(lfit)
  
  se_b0 <- sqrt(homvc["(Intercept)","(Intercept)"])
  se_b1 <- sqrt(homvc["x","x"])
  
  ser_b0 <- sqrt(hetvc["(Intercept)","(Intercept)"])
  ser_b1 <- sqrt(hetvc["x","x"])

  output <- cbind(beta0, beta1, se_b0, se_b1, ser_b0, ser_b1)
  
  return(output)
}

sims <- replicate(reps, lfit_extract_betas(samp_size))

sd(sims[,"beta0",]) # empirical standard error
mean(sims[,"se_b0",] ) # estimated SE
mean(sims[,"ser_b0",] ) # heteroscedasticity robust SE

sd(sims[,"beta1",]) # empirical standard error
mean(sims[,"se_b1",] ) # estimated SE
mean(sims[,"ser_b1",] ) # heteroscedasticity robust SE


#Q.17
set.seed(1019)
samp_size <- 10

sims <- replicate(reps, lfit_extract_betas(samp_size))

sd(sims[,"beta0",])
mean(sims[,"se_b0",] )
mean(sims[,"ser_b0",] )

sd(sims[,"beta1",])
mean(sims[,"se_b1",] )
mean(sims[,"ser_b1",] )


#Q.18
require(haven)
airfare <- read_dta("data-airfare.dta")

lfit <- lm(lfare ~ ldist, data=airfare)
summary(lfit)
coef(lfit)

#Q.19
airfare$ldist_noise <- airfare$ldist + rnorm(nrow(airfare))

lfit_noise <- lm(lfare ~ ldist_noise, data=airfare)
summary(lfit_noise)
coef(lfit_noise)


#Q.21
lfit_pop <- lm(lfare ~ ldist + concen, data=airfare)
summary(lfit_pop)
coef(lfit_pop)


lfit_ov <- lm(lfare ~ ldist, data=airfare)
summary(lfit_ov)
coef(lfit_ov)


coef(lfit_pop)
beta_1 <- coef(lfit_pop)["ldist"]
beta_2 <- coef(lfit_pop)["concen"]

beta_1

lfit_x1x2 <- lm(concen ~ ldist, data=airfare)
gamma_1 <- coef(lfit_x1x2)["ldist"]
gamma_1

delta1hat_byhand <- beta_1 + beta_2 * gamma_1
delta1hat_byhand

bias <- beta_2 * gamma_1
bias

beta_2
gamma_1


lfit_ovb <- lm(lfare ~ ldist, data=airfare)
summary(lfit_ovb)
beta1hat_direct <- coef(lfit_ovb)["ldist"]
beta1hat_direct