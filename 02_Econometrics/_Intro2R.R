# Introduction to R for Econometrics

#####################
## 2. Fundamentals ##
#####################


## 2.3 Variable Assignment ##

x <- 5
y <- 7*3
z <- x+y


## 2.4 Data Types ##

class(z)
class("Ciao")

rm(z) # remove variable


## 2.6 VECTORS ##

is.vector(z)
is.vector("ciao")

length(z)

v1 <- c(5,10,15) # to create a vector
length(v)

v2 <- c(v1,1,2,3) # vectors are one dimensional
v3 <- c(1,2,3,"ciao") # vectors can only store one data type

v4 <- c(1:10)
v4 <- c(seq(from=5,to=20,by=5))

v4+1
v4/5

# When using base operator on more vectors, they must be same length!
# Also works if the length of one vector is a multiple of the length of the other!

v4 <- v4[-c(1)] # REMOVE 1^ element b index
v2[!v2==1] # REMOVE specific value from vector

c(v1,v2) # APPEND to vector
append(v1,v2)
append(v1,v2,1) # APPEND to vector with index

sort(v1) # from smallest to largest
sum(v1) # sum of elements in vector
prod(v1) # product of elements in vector

v1 == 1 # logical operations to EACH element of a vector

v1[1] # return 1^ elem
v1[1:3] 
v1[c(1,5)] # return 1^ and 5^ elem

v1[3] <- 10

v1<-c(-10:10)
which(v1 > 0) # get INDEXES of true elements
v1[which(v1>0)]

## 2.7 FACTORS ##

genders <- factor(c("M,F"))

like <- factor(c("Agree","Disagree","Neutral"),
               levels = c("Disagree","Neutral","Agree"),
               ordered = TRUE)
min(like)


## 2.8 RANDOM NUMBERS ##

rnorm(10) # 10 draws, mean 0 sd 1
rnorm(10, mean = 5, sd = 2)

set.seed(484)
rnorm(3)


## 2.9 SPECIAL VALUES ##

z <- 5
z[4] <- 1
is.na(z[2])


## 2.10 MATRICES ##

a <- 1:5
b <- 6:10
c <- 11:15

xx <- rbind(a,b,c) # bind over row
yy <- cbind(a,b,c) # bind over col

matrix(1:50, nrow=10)

nrow(xx)
ncol(xx)
dim(xx)

t(xx) # TRANSPOSE of the matrix


## 2.14 LOOPS ##

for(i in 1:10) {
  print(paste(i, "ciao"))
}

lapply(mtcars[,2:6],mean) # repeat MEAN function on COLs 2:6 returning a LIST


## 2.16 WRITING FUNCTIONS ##

isSquare <- function(x) {
  sqrt(x) %% 1 == 0
}

isSquare(4)


###########################
## 3. BASIC STAT METHODS ##
###########################

## 3.1 MONTE CARLO ##

mean_rnorm_sample <- function(n, mean=0, sd=1) {
  sample <- rnorm(n, mean, sd)
  mu <- mean(sample)
  return(mu)
}

mean_rnorm_sample(100, 5, 1)

set.seed(666)
sample_size <- 100
mean <- 5
sd <- 2
mu_hat <- replicate(1000, mean_rnorm_sample(sample_size, mean, sd))

mu_hat_mean <- mean(mu_hat)
mu_hat_mean

mu_hat_sd <- sd(mu_hat)
mu_hat_sd

hist(mu_hat, breaks=30, freq=FALSE)
curve(dnorm(x, mean=mean, sd = sd/sqrt(sample_size)), add=TRUE)


## 3.2 SUMMARY STATS ##

summary(mtcars)


## 3.3 LINEAR REGRESSION ##

lfit <- lm(mpg ~ hp, data = mtcars) # linear regression

attributes(lfit) # object with results

lfit$coefficients
summary(lfit)


##############
## 4. PLOTS ##
##############

hist(mtcars$mpg, breaks=25)

plot(mtcars$hp, mtcars$mpg)
