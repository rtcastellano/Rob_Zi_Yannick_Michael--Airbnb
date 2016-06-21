# Feature Selection
# Loading the dataset and dropping age, gender, all country dataset variables, the datetime and the time lag variables,\
#as well a user id and the duplicative index.

train_starting <- read.csv("~/unicorn-capstone/train_starting.csv", stringsAsFactors=TRUE)
View(train_starting)
t <- train_starting
t <- t[-c(1:7, 17:20, 22, 25:30)]
View(t)

#parallel processing on server
library(doSNOW)
cl <- makeCluster(4, outfile="")
registerDoSNOW(cl)

#Using a Gradient Boosting Model first
library(gbm)
# splitting 80/20 into train/test
set.seed(0)
train = sample(1:nrow(t), 8*nrow(t)/10)
t.test = t[-train, ]
bookings.test = t$bookings[-train]

set.seed(0)
boost.tc = gbm(bookings ~ ., data = t[train, ],
               distribution = "multinomial",
               n.trees = 300, cv.folds = 5, shrinkage = .0001, interaction.depth = 2)

summary(boost.tc)
print(boost.tc)

predtrselect = predict(boost.tc, newdata = t[train, ], n.trees = 300)

a <- apply(predtrselect, 1, which.max)
s <- as.vector(t[train,]$bookings)
s <- as.factor(s)
table(s, a)

a
s            2
early  28868
NB     99664
waited 42228

Training accuracy: 0.5836496 

#Calculating test error on test set using 300 trees
predtestselect = predict(boost.tc, newdata = t.test, n.trees = 300)

dim(predfselect)


b <- apply(predfselect, 1, which.max)

s <- as.vector(t.test$bookings)
s <- as.factor(s)
table(s, b)

b
s            2
early   7311
NB     24879
waited 10501

Testing accuracy: 0.5827692
  
#Removing unimportant features
reduced <- data.frame(t$signup_flow, t$affiliate_channel, t$signup_app, t$counts, t$first_browser, t$sum_secs_elapsed, t$first_affiliate_tracked ,t$bookings)
set.seed(0)
trainred = sample(1:nrow(reduced), 8*nrow(reduced)/10)
tr.test = reduced[-trainred, ]
View(reduced)

boost.tred = gbm(t.bookings ~ ., data = reduced[trainred,], distribution = "multinomial", n.trees = 300, cv.folds = 5, shrinkage = .0001, interaction.depth = 2)

summary(boost.tred)
print(boost.tred)

predredtrain = predict(boost.tred, newdata = reduced[trainred,], n.trees = 300)
ff <- apply(predredtrain, 1, which.max)
cc <- as.factor(as.vector(reduced[trainred,]$t.bookings))
table(ff, cc)

cc
ff  early    NB waited
2 28868 99664  42228

predredtest = predict(boost.tred, newdata = tr.test, n.trees = 300)
gg <- apply(predredtest, 1, which.max)
dd <- as.factor(as.vector(tr.test$t.bookings))
table(gg, dd)

Training accuracy of boost.tred: 0.5836496 
Testing accuracy of boost.tred: 0.5827692
