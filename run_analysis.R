## This script does the following:
## Merges the training and the test sets
## Extracts only the measurements on the mean and standard deviation for each measurement
## Name the Activities in the Data Set
## Lastly, takes the average of each variable for each ACTIVITY and SUBJECT



#Set working directory
setwd("C:/Users/rowell/Desktop/Project/")

#Add reshape2 library
library(reshape2)

#Read all the needed files 

labels <- read.table("activity_labels.txt")
features <- read.table("features.txt")

trainS <- read.table("train/subject_train.txt")
testS <- read.table("test/subject_test.txt")


trainX <- read.table("train/X_train.txt")
testX <- read.table("test/X_test.txt")


trainY <- read.table("train/y_train.txt")
testY <- read.table("test/y_test.txt")


#Row bind each data types: Subject, X, and Y
S <- rbind(trainS, testS)
X <- rbind(trainX, testX)
Y <- rbind(trainY, testY)


#Names for the data frame S 
names(S) <- c("SUBJECT")

#Descriptive Activity Names
#Names for the data frame Y 
Y[,1] <- labels[Y[,1], 2]
names(Y) <- c("ACTIVITY")

#Names for the data frame X
# Select row number with mean() and std() from features.txt and map this to the columns of X
X <- X[, grep("-mean\\(\\)|-std\\(\\)",features[,2])]
names(X) <- features[grep("-mean\\(\\)|-std\\(\\)",features[,2]),2]

#Merge S, X, and Y to form one data set
merged <- cbind(S, X, Y)

#Write the merged table
write.table(merged, "tidy.txt")

#Read the merged table
merged <- read.table("tidy.txt", header=T, sep=" ")

#Choose all variables except "SUBJECT" and "ACTIVITY"
selected <- merged[ , !names(merged) %in% c("SUBJECT","ACTIVITY")]



#Melt merged data
mergedMelt <- melt(merged, id=c("SUBJECT","ACTIVITY"), measure.vars=names(selected))

#Casting data frame
subjMelt <- dcast(mergedMelt, SUBJECT ~ variable, mean)
moo <- dcast(mergedMelt, ACTIVITY ~ variable, mean)


#Write the tidy set with each variable mean is computed
write.table(subjMelt, "tidyMeanSubject.txt")
write.table(moo, "tidyMeanActivity.txt")
