# Authors:
# Carlos García @ cm.garsua@gmail.com
# Adam Alpire @ am.rivero13@gmail.com

############################################################
######### Titanic Classifier - Decision Trees ##############
############################################################

# Packages.
library(caret)
library(rpart)
library(rpart.plot)
library(e1071)
library(randomForest)
library(vcd)

# Importing data.
titanicData <- read.csv("./titanic.csv")

# Data cleaning
finalVars <- c(2,3,5,6,7,8,10,12) # Final features
titanicData <- titanicData[finalVars]
nrow(titanicData) # 891 rows
titanicData <- na.omit(titanicData) # Final instances (NA).
nrow(titanicData) # 714 rows

# Data partition
inTraining <- createDataPartition(titanicData$Survived, p = .75, list = FALSE)
training <- titanicData[ inTraining,]
testing <- titanicData[ -inTraining,]

# Trainig Decision Tree
fitModel <- rpart(Survived ~ Pclass + Sex + Age + SibSp + Parch + Fare + Embarked, data=training, method="class")
prp(fitModel)
rsq.rpart(fitModel) # R-squared
testPred <- predict(fitModel, testing, type = "class")
confusionMatrix(testPred, testing$Survived)
help("rpart") # Check the parameters of Decision Trees

# Tuning rpat(): 
# (1) Overfitted tree.
fitModelTuned <- rpart(Survived ~ Pclass + Sex + Age + SibSp + Parch + Fare + Embarked, data=training,
                       method="class", control=rpart.control( cp=0))
prp(fitModelTuned)
rsq.rpart(fitModelTuned)
testPredTuned <- predict(fitModelTuned, testing, type = "class")
confusionMatrix(testPredTuned, testing$Survived)

# (2) Overfitted tree.
fitModelTuned <- rpart(Survived ~ Pclass + Sex + Age + SibSp + Parch + Fare + Embarked, data=training,
                       method="class", control=rpart.control( minsplit=2,cp=0))
prp(fitModelTuned)
rsq.rpart(fitModelTuned)
testPredTuned <- predict(fitModelTuned, testing, type = "class")
confusionMatrix(testPredTuned, testing$Survived)

# Parameters tuning
fitControl <- trainControl(## 10-fold CV
  method = "repeatedcv",
  number = 10)
set.seed(825)
rpartFit <- train(as.factor(Survived) ~ Pclass + Sex + Age + SibSp + Parch + Fare + Embarked,
                 data = training,
                 method = "rpart",
                 #tuneGrid = rpartParams,
                 trControl = fitControl)
rpartFit
prp(rpartFit$finalModel)
plot(rpartFit)

# Selecting parameters
rpartParams <- expand.grid(cp = c(0, 0.01, 0.02, 0.04, 0.07, 0.10),
                           Cost = c(1, 2, 3, 5, 10))
set.seed(825)
rpartFit <- train(as.factor(Survived) ~ Pclass + Sex + Age + SibSp + Parch + Fare + Embarked,
                  data = training,
                  method = "rpartCost",
                  tuneGrid = rpartParams,
                  trControl = fitControl)
rpartFit
prp(rpartFit$finalModel)
plot(rpartFit)

# Random forests (ntree=2000)
set.seed(825)
fitForest <- train(as.factor(Survived) ~ Pclass + Sex + Age + SibSp + Parch + Fare + Embarked,
                   data = training,
                   method = "rf",
                   trControl = fitControl,
                   ntree = 2000,
                   importance = TRUE
)
fitForest
fitForest$finalModel
plot(fitForest)
varImpPlot(fitForest$finalModel)

# Random forests (ntree=2000) and mtry
forestParams <- expand.grid(mtry= c(2,3,4,5,6,7,8,9))
set.seed(825)
fitForest2 <- train(as.factor(Survived) ~ Pclass + Sex + Age + SibSp + Parch + Fare + Embarked,
                    data = training,
                    method = "rf",
                    trControl = fitControl,
                    ntree = 2000,
                    tuneGrid = forestParams,
                    importance = TRUE)
fitForest2
fitForest2$finalModel
plot(fitForest2)
varImpPlot(fitForest2$finalModel)
gbmImp2 <- varImp(fitForest2)
plot(gbmImp2)

# Random forest VS Decision Tree
Prediction <- predict(fitForest2, testing)
Prediction2 <- predict(rpartFit, testing)
confusionMatrix(Prediction, testing$Survived)
confusionMatrix(Prediction2, testing$Survived)

########################## Testing New Feature Cabin #########################
preData <- read.csv("./titanic.csv")
# Data cleaning
finalVarsCabin <- c(2,3,5,6,7,8,10,11,12) # Final features
preData <- preData[finalVarsCabin]
counts <- table(preData$Cabin)
counts
barplot(counts,main="Simple Bar Plot",xlab="Cabin", ylab="Frequency")
write.table(counts, file="./cabin.txt", fileEncoding = "UTF-8")
s <- sapply(strsplit(as.character(preData$Cabin) , split="[^A-z]") , "[" , 1)
s[is.na(s)] <- as.character('NA')
s <- factor(s)
preData$Cabin <- s
preData <- na.omit(preData)
cabinCounts <- table(preData$Cabin)
cabinCounts
barplot(cabinCounts,main="Cabins",xlab="Deck", ylab="Frequency",
        col=topo.colors(12))

# Data partition
inTrainingCabin <- createDataPartition(preData$Survived, p = .75, list = FALSE)
trainingCabin <- preData[ inTrainingCabin,]
testingCabin <- preData[ -inTrainingCabin,]

set.seed(825)
rpartFitCabin <- train(as.factor(Survived) ~ Pclass + Sex + Age + SibSp + Parch + Fare + Cabin + Embarked,
                  data = trainingCabin,
                  method = "rpartCost",
                  tuneGrid = rpartParams,
                  trControl = fitControl)
rpartFitCabin
prp(rpartFitCabin$finalModel)
plot(rpartFitCabin)
predictionCabin <- predict(rpartFitCabin, testingCabin)
confusionMatrix(predictionCabin, testingCabin$Survived)
##############################################################################