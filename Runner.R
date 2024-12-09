###### Settings ###### 
# setwd("./scEpiAge/")
##Tissue, options are: liver, lung, blood.
tissue="liver"

##Folder with COV files.
folderInput = "./cov/"

## output file with aging information.
outputFileName="./age_predition.txt"

##If there are known age calculate confidence on the difference observed.
nSimulations = 5

##Age information
ageInfo = NULL
#ageInfo = read.delim("./GravinaBulkInfo.txt")
# ageInfo = read.delim("./GravinaScInfo.txt")

## ouput file name with extended information.
outputFileNameExtended = NA
# outputFileNameExtended="./preditionGravinaBulk.extended.txt"
# outputFileNameExtended="./preditionGravinaSc.extended.txt"

plot=F

###################### 


## Actual code form here:

calcExtendedStats = F
if(!is.na(outputFileNameExtended) & !is.null(ageInfo)){
  calcExtendedStats=T
} else {
  print("Not given age information or output filename for the extended analysis")
}

###### Source ########
##source prediction functions.
source("./scEpiAge/PredictionFunctions/functions.R")
###################### 

##### Load data ######
if(tissue=="liver"){
  expectedMethMatrix <- read.delim("./scEpiAge/ExpectedMethylationMatrices/ExpectedMethMat_Liver.tsv",as.is=T,row.names=1,check.names = F)
  backupInformation <- read.delim("./scEpiAge/SiteInformation/clockSites_Liver_BackUp.txt",as.is=T)
} else if(tissue=="lung"){
  expectedMethMatrix <- read.delim("./scEpiAge/ExpectedMethylationMatrices/ExpectedMethMat_Lung.tsv",as.is=T,row.names=1,check.names = F)
  backupInformation <- read.delim("./scEpiAge/SiteInformation/clockSites_Lung_BackUp.txt",as.is=T)
} else if(tissue=="blood"){
  expectedMethMatrix <- read.delim("./scEpiAge/ExpectedMethylationMatrices/ExpectedMethMat_Blood.tsv",as.is=T,row.names=1,check.names = F)
  backupInformation <- read.delim(".scEpiAge/SiteInformation/clockSites_Blood_BackUp.txt",as.is=T)
} else{
  print("No valid tissue selected")
  stop();
}

##Predict.
inputMethMatrix = readCovFiles(folderInput,backupInformation);

if(calcExtendedStats){
  predictionOutVersusExpected = predictAgesAndCalculateExpectedGivenAge(inputMethMatrix, backupInformation, expectedMethMatrix, ageInfo, nSimulations,plot);
  write.table(predictionOutVersusExpected,outputFileNameExtended,sep="\t",quote=F)
} else {
  predictionOut = predictAges(inputMethMatrix, backupInformation, expectedMethMatrix);
  write.table(predictionOut,outputFileName,sep="\t",quote=F)  
}

