rm(list=ls())

require(pacman)
p_load(readr, AER, huxtable, stargazer, cowplot, ggplot2, ggfortify)

## Q 8 ------------------------------------------------------------------------
set.seed(091123)

n <- 200
x1 <- rnorm(n = n, 2, 3)
x2 <- rnorm(n = n, 7, 1)
u <- rnorm(n = n, 0, 2)
y <- 10 - 3*x1 + 5*x2 + u


## Q 10 ------------------------------------------------------------------------
e <- rnorm(n = n, 0, 2)
x1_tilde <- x1 + e

v <- rnorm(n = n)
z <- x1 + v


## Q 12 ------------------------------------------------------------------------
first_stage <- lm(x1_tilde ~ z + x2)
x1_tilde_predict <- predict(first_stage)

second_stage <- lm(y ~ x1_tilde_predict + x2)
summary(second_stage)$coef

stargazer(second_stage)

## Q 13 ------------------------------------------------------------------------
iv_direct <- ivreg(y ~ x1_tilde + x2 | z + x2)
summary(iv_direct)$coef

# Show the results in a table using the "huxreg" package.
huxreg(
  "2SLS" = second_stage, "IV direct" = iv_direct,
  omit_coefs = "(Intercept)", statistics = c("nobs", "r.squared")
)

# Alternatively, if you want to generate a LaTeX table,
# you can use the "stargazer" package.
stargazer(second_stage, iv_direct)


## Q 14 ------------------------------------------------------------------------
kids <- read.csv("kids.csv")
head(kids)

# create a dummy for whether mother has more than 2 children
kids$morethan2 <- as.integer(kids$kidcount > 2)

lfit <- lm(
  weeksm1 ~ morethan2 + black + hispan + othrace + agem1 + agefstm + boy1st
  + boy2nd,
  data = kids)

huxreg(lfit, statistics = "nobs")


## Q 15 ------------------------------------------------------------------------
first_stage <- lm(
  morethan2 ~ samesex + black + hispan + othrace + agem1 + agefstm + boy1st
  + boy2nd,
  data = kids)

huxreg(first_stage, statistics = "nobs")

# Let's check whether the value F statistic is > 10
summary(first_stage)$fstatistic


## Q 16 ------------------------------------------------------------------------
iv_fit <- ivreg(
  weeksm1 ~ morethan2 + black + hispan + othrace + agem1 + agefstm + boy1st
  + boy2nd | . - morethan2 + samesex,
  # samesex +  black + hispan + othrace + agem1 + agefstm + boy1st + boy2nd 
  data = kids
)
huxreg(lfit, iv_fit, statistics = "nobs")


## Q 17 ------------------------------------------------------------------------
iv_2instr <- ivreg(
  weeksm1 ~ morethan2 + black + hispan + othrace + agem1 + agefstm + boy1st
  + boy2nd | . - morethan2 + samesex + multi2nd,
  data = kids
)

huxreg(lfit, iv_fit, iv_2instr, statistics = "nobs")



iv_1instr <- ivreg(
  weeksm1 ~ morethan2 + black + hispan + othrace + agem1 + agefstm + boy1st
  + boy2nd | . - morethan2 + multi2nd,
  data = kids
)

huxreg(
  "OLS" = lfit, "IV morethan2" = iv_fit, "IV multi2nd" = iv_1instr, "IV 2 instr." = iv_2instr,
  omit_coefs = "(Intercept)", statistics = c("nobs", "r.squared")
)

## Q 18 ------------------------------------------------------------------------

sample_and_estimate <- function(samp_size) {
  
  samp_index <- sample(nrow(kids), size = samp_size)
  kids_sample <- kids[samp_index,]
  
  ols_fit <- lm(
    weeksm1 ~ morethan2 + black + hispan + othrace + agem1 + agefstm
    + boy1st + boy2nd,
    data = kids_sample
  )
  iv_fit <- ivreg(
    weeksm1 ~ morethan2 + black + hispan + othrace + agem1 + agefstm
    + boy1st + boy2nd | . - morethan2 + samesex,
    data = kids_sample
  )
  firststage_fit <- lm(
    morethan2 ~ samesex + black + hispan + othrace + agem1 + agefstm
    + boy1st + boy2nd,
    data = kids_sample
  )
  
  beta_ols <- ols_fit$coefficients["morethan2"]
  beta_iv <- iv_fit$coefficients["morethan2"]
  beta_first <- firststage_fit$coefficients["samesex"]
  
  return(cbind(beta_ols, beta_iv, beta_first)[1,])
}

reps <- t(replicate(100, sample_and_estimate(500)))

xlabel <- expression(beta)

par(mfrow=c(2,2))
hist(reps[,"beta_ols"], breaks = 30, xlab = xlabel, main = "OLS")
hist(reps[,"beta_iv"], breaks = 30, xlab = xlabel, main = "IV")
hist(reps[,"beta_first"], breaks = 30, xlab = xlabel, main = "First")




## Frisch Waugh Lovell ---------------------------------------------------------

# see extra R script: fwl.R


# Question 19
exo_vars <- c(
  "black", "hispan", "othrace", "agem1", "agefstm", "boy1st", "boy2nd"
)

lfit_samesex <- lm(samesex ~ ., data = kids[c("samesex", exo_vars)])
lfit_morethan2 <- lm(morethan2 ~ ., data = kids[c("morethan2", exo_vars)])
lfit_weeksm1 <- lm(weeksm1 ~ ., data = kids[c("weeksm1", exo_vars)])

samesex_res <- resid(lfit_samesex)
morethan2_res <- resid(lfit_morethan2)
weeksm1_res <- resid(lfit_weeksm1)

# a) Use the cov/var expression
beta_iv_fwl <- cov(weeksm1_res, samesex_res) / cov(morethan2_res, samesex_res)
beta_iv_fwl


# b) Perform 2SLS manually using the residualized x*, z* and y* 
first_stage <- lm(morethan2_res ~ samesex_res)
x1_tilde_predict <- predict(first_stage)

second_stage <- lm(weeksm1_res ~ x1_tilde_predict)
summary(second_stage)$coef


summary(iv_fit)
coef(iv_fit)["morethan2"]