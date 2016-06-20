# Feature Selection
# Loading the dataset and dropping age, gender, population in thousands, the datetime and the time lag variables,\
#as well a user id and the duplicative index.

train_starting <- read.csv("~/unicorn-capstone/train_starting.csv", stringsAsFactors=TRUE)
View(train_starting)
t <- train_starting
t <- t[-c(1:7, 17:20, 22)]
View(t)

#Using a Gradient Boosting Model first
library(gbm)
# splitting 80/20 into train/test
set.seed(0)
train = sample(1:nrow(t), 8*nrow(t)/10)
t.test = t[-train, ]
bookings.test = t$bookings[-train]

#Using bookings as the response variable with 10,000 trees and interaction depth of 2
set.seed(0)
boost.t = gbm(bookings ~ ., data = t[train, ],
                   distribution = "gaussian",
                   n.trees = 10000,
                   interaction.depth = 2)

