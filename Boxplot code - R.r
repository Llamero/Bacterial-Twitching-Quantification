#subsample size - how many discrete measurements to convert the frequency table back into
subsample<-1000

#Create a vector of the bin values
binVector<-c(5:119)

#Set working directory to file directory with data
setwd("D:/ImageJ Macros/Fleiszig Lab/Bacterial motility quantification/Protocol paper subset/Output2")

#Load the frequency table
freqMatrix<-read.table("Sample histogram.csv", header = TRUE, sep = ",")
freqMatrix<-freqMatrix[,-1] #remove first column
scaledMatrix<-round(freqMatrix*subsample, digits = 0)

#Create a matrix to store sampled data
sampleMatrix<-matrix(data = 0, nrow = subsample, ncol = ncol(scaledMatrix))
colnames(sampleMatrix)<-colnames(freqMatrix)

#Convert each column in the frequecy table to a set of discrete measurements with count = subsample
for(a in 1:ncol(sampleMatrix)){
	#Initialize the sample vector and fill with 0
	sampleVector<-numeric(subsample)
	
	#Create subsample vector (i.e. bin value repeated freq # of times)
	sampleVector<-rep(binVector, scaledMatrix[,a])
	
	#If the sample vector is too long (due to rounding), remove last elements until it has length 1000
	sampleVector<-head(sampleVector, subsample)
	
	#If the sample vector is too short (due to rounding), add elements of value 0 until it has length 1000
	sampleVector[length(sampleVector):subsample]<-numeric(subsample - length(sampleVector) + 1)
	
	sampleMatrix[,a]<-sampleVector
	
}

#Create a notched box plot for each genotype
#par(mar = c(15,6,3,3))
boxplot(sampleMatrix, las = 2, names = colnames(freqMatrix), notch = TRUE, outline = FALSE, ps = 1, cex.lab=1, cex.axis=1, cex.main=1, cex.sub=1, bty="n")

mtext("Relative Bacteria Mobility (a.u.)", side=2, line = 2.5, cex = 1)
mtext("Percent tear concentration in PBS (v/v)", side=1, line = 4, cex = 1)





