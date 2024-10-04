rm(list=ls())

require(pacman)
p_load(haven, AER, huxtable, lfe, ggplot2)

############# Animations of different estimators
## DID
## https://twitter.com/i/status/1067136329945763846

## IV
## https://twitter.com/i/status/1068215497626312704

## Triple DiD
## https://twitter.com/i/status/1103255875781685248

## FE
## https://twitter.com/i/status/1282786582085332992


## Difference-in-Differences ---------------------------------------------------

cig <- read_dta("data-cig_data.dta")

## 2 ---------------------------------------------------------------------------

cig$prop99 <- as.integer(cig$state == "California" & cig$year > 1988)

pols <- lm(
  cigsale ~ prop99 + retprice + lnincome + beer + age15to24 + education
  + unemploy,
  data = cig
)
coeftest(pols, vcov. = vcovHC)


## 5 ---------------------------------------------------------------------------
cig_sub <- cig[complete.cases(cig), ] # remove obs with NAs

cigsale_c_post <- mean(subset(
  cig_sub, subset = (state == "California" & year > 1988), select = cigsale,
  drop = TRUE
))
cigsale_c_pre <- mean(subset(
  cig_sub, subset = (state == "California" & year <= 1988), select = cigsale,
  drop = TRUE
))
cigsale_nc_post <- mean(subset(
  cig_sub, subset = (state != "California" & year > 1988), select = cigsale,
  drop = TRUE
))
cigsale_nc_pre <- mean(subset(
  cig_sub, subset = (state != "California" & year <= 1988), select = cigsale,
  drop = TRUE
))

did_est <-
  (cigsale_c_post - cigsale_c_pre) - (cigsale_nc_post - cigsale_nc_pre)
did_est


## 6 ---------------------------------------------------------------------------
cig$treat <- as.integer(cig$state == "California")
cig$post <- as.integer(cig$year > 1988)

cig_sub <- cig[complete.cases(cig), ] # remove obs with NAs

did <- lm(cigsale ~ prop99 + treat + post, data = cig_sub)
huxreg("Baseline" = did)


## 7 ---------------------------------------------------------------------------
# Indicator variables
did_fe <- lm(cigsale ~ prop99 + factor(state) + factor(year), data = cig_sub)
summary(did_fe)
huxreg("Baseline" = did, "FE" = did_fe, coefs = "prop99", statistics = c("N" = "nobs"))

# Projecting Out FE
did_felm <- felm(cigsale ~ prop99 | state + year, data = cig_sub)
summary(did_felm)

huxreg(
  "Baseline" = did, "FE" = did_fe, "Proj." = did_felm,
  coefs = "prop99", statistics = c("N" = "nobs")
)


## 8 ---------------------------------------------------------------------------
did_controls <- felm(
  cigsale ~ prop99 + retprice + lnincome + beer + education
    + unemploy + age15to24 | state + year, data = cig_sub
)

huxreg(
  "Baseline" = did, "FE" = did_fe, "Proj." = did_felm,
  "Cont." = did_controls,
  coefs = "prop99", statistics = c("N" = "nobs")
)


## 9 ---------------------------------------------------------------------------
# Including age15to24 throws an error when both state-specific linear time 
# trends, # factor(state):year, and state fixed effects, factor(state), 
# are included. 
# The reason is that the effect of age15to24 no longer varies within states 
# (=is no longer identified) when the time-invariant state fixed effects 
# AND the state-specific linear time trend are controlled for.
# Similar to why 'Female' is no longer identified in Problem 2/Q16 when we 
# include individual fixed effects.
did_tt <- felm(
  cigsale ~ prop99 + retprice + lnincome + beer + education + unemploy
  + age15to24 |  factor(state) + factor(year) + factor(state):year,
  data = cig_sub
)
summary(did_tt)

did_tt_lm <- lm(
  cigsale ~ prop99 + retprice + lnincome + beer + education + unemploy
  + factor(state) + factor(year) + factor(state):year,
  data = cig_sub
)
summary(did_tt_lm)

huxreg(
  "Baseline" = did, "FE" = did_fe,  "Proj." = did_felm, "Cont." = did_controls,
  "Time Trends" = did_tt,
  coefs = "prop99", statistics = c("N" = "nobs")
)


## 10 --------------------------------------------------------------------------
did_clust <- felm(
  cigsale ~ prop99 + retprice + lnincome + beer + education + unemploy
  | factor(state) + factor(year) + factor(state):year | 0 | state,
  data = cig_sub
)

huxreg(
  "Baseline" = did, "FE" = did_fe,  "Proj." = did_felm, "Cont." = did_controls,
  "Time Trends" = did_tt, "Cluster" = did_clust,
  coefs = "prop99", statistics = c("N" = "nobs")
)

## 12 -------------------------------------------------------------------------
# Look at trends in outcomes
trends <- aggregate(
  cig["cigsale"],
  by = list("year" = cig$year, "treat" = cig$treat),
  FUN = "mean"
)
trend_treat <- subset(trends, treat==1)
trend_nottreat <- subset(trends, treat==0)

plot(
  trend_treat$cigsale ~ trend_treat$year, type="b", col = "red",
  ylim = c(40, 145), ylab = "Cig. Sales", xlab = "Year"
)
lines(trend_nottreat$cigsale ~ trend_nottreat$year, type="b", col = "blue")
abline(v=1988)
legend(
  "bottomleft", legend = c("California", "Other States"),
  col = c("red", "blue"), pch = 1
)


## 12 --------------------------------------------------------------------------
## ---- out.width="85%"---------------------------------------------------------

# Lead-lag
cig$leadlag <- factor(cig$treat*cig$year)
cig$leadlag[cig$leadlag == 1988] <- 0

cig$state <- as.factor(cig$state)
cig$state <- relevel(cig$state, ref = "California")
cig$year_fac <- as.factor(cig$year)

did_leadlag <- lm(
  cigsale ~ leadlag + state + year_fac + state:year,
  data = cig
)


all_coefs <- tidy(did_leadlag, conf.int = TRUE)
leadlag_coefs <- all_coefs[grepl("leadlag", all_coefs$term),]
leadlag_coefs <- rbind(
  leadlag_coefs[1:17,],
  list("1988", 0, 0, 0, 0, 0, 0),
  leadlag_coefs[18:nrow(leadlag_coefs),]
)
leadlag_coefs$term <- 1971:2000

ggplot(
  leadlag_coefs, aes(x=term, y=estimate, ymin=conf.low, ymax=conf.high)
) +
  geom_pointrange(show.legend = FALSE) +
  geom_hline(yintercept = 0, linetype="dashed") +
  xlab(expression(gamma[t])) +
  theme_classic(base_size = 16)


## Fixed Effects & Marathons ---------------------------------------------------
marathons <- readRDS("data-GMM.rds")


## 13 --------------------------------------------------------------------------
baseline <- lm(Ave_Speed ~ Marathon, data = marathons)
coef(summary(baseline))


## 14 --------------------------------------------------------------------------
cont_bib <- lm(Ave_Speed ~ Marathon + Number, data = marathons)
coef(summary(cont_bib))


## 15 --------------------------------------------------------------------------

marathons$NAT <- as.factor(marathons$NAT)
marathons$Age_Group <- as.factor(marathons$Age_Group)

lm_controls <- felm(
  Ave_Speed ~ Marathon + Female + Age_Group + Temperature + NAT,
  data = marathons
)
coef(summary(lm_controls))


lm_controls <- felm(
  Ave_Speed ~ Marathon + Female + Age_Group + Temperature | NAT,
  data = marathons
)
coef(summary(lm_controls))


## 16 --------------------------------------------------------------------------
# Female no longer identified, since it doesn't vary within individual
# The following will throw an error
fe <- felm(
  Ave_Speed ~ Marathon + Female + Age_Group + Temperature | NAT + ID,
  data = marathons
)
coef(summary(fe))


# Removing Female 
# Also drop NAT, since a person's country doesn't vary either once we add FE
fe <- felm(
  Ave_Speed ~ Marathon + Age_Group + Temperature | ID,
  data = marathons
)
coef(summary(fe))


## 17 --------------------------------------------------------------------------

# Identify switchers and filter
ave_mars <- aggregate(
  marathons["Marathon"], by = list(ID = marathons$ID), FUN = mean
)
ave_mars$switcher <- (!ave_mars$Marathon %in% c(0,1))
ave_mars$Marathon <- NULL

marathon_switchers <- merge(marathons, ave_mars, by = "ID")
marathon_switchers <- marathon_switchers[
  marathon_switchers$switcher == TRUE,
]

fe_nocont <- felm(
  Ave_Speed ~ Marathon | ID,
  data = marathons
)

fe_switchers <- felm(
  Ave_Speed ~ Marathon | ID,
  data = marathon_switchers
)


coef(summary(fe_switchers))
coef(summary(fe_nocont))


huxreg(
  "All Data" = fe_nocont, "Only Switchers" = fe_switchers,
  statistics = c("N" = "nobs", "R2" = "r.squared")
)

