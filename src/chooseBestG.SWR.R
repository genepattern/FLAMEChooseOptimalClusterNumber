#LoadPackages <- function(package.names) {
#source("http://bioconductor.org/biocLite.R")
#for (i in 1:length(package.names)) {
#	package.name = package.names[i]
#	installed <- installed.packages()[,1]
#	if (!any(installed == package.name)) {
#		#install.packages(package.name, repos = "http://cran.r-project.org")
#		biocLite(package.name)
#	}
#}
#}

cleanup <- function()
{
    files <- list.files(all.files=TRUE)
    for (i in 1:length(files))
    {
        if(regexpr(paste(".zip","$",sep=""), tolower(files[[i]]))[[1]] == -1
            && tolower(files[[i]]) != "stderr.txt" 
            && tolower(files[[i]]) != "cmd.out"
            && tolower(files[[i]]) != "stdout.txt"
            && tolower(files[[i]]) != ".epilogue.pbs"
            && tolower(files[[i]]) != "command.pbs"
            && tolower(files[[i]]) != ".command.pbs"
            && tolower(files[[i]]) != ".epilogue.sh"
)
        {
            file.remove(files[[i]])
        }
    }
}

parseCmdLine <- function(...)
{
    suppressMessages(chooseBestG(...))
}

chooseBestG <- function(
libdir, #full pathname to where FLAME program files are kept
MixtureModel, #full pathname to mixture model results
choose.g.method = "SWR", #{AIC,BIC,SWR,distance.ratio,intercluster.distance}
seed = 123456, #random seed
output.prefix #prefix of filename <studyname_dataname>
){

zip.ext <- regexpr(paste(".zip","$",sep=""), tolower(MixtureModel))
if(zip.ext[[1]] == -1)
{
    stop("Input file must be of type zip ")
}

source(paste(libdir,"common.R",sep='/'))
source(paste(libdir,"choose.optimal.g.SWR.R",sep='/'))
source(paste(libdir,"collect.g.files.R",sep='/'))
source(paste(libdir,"unzip.R",sep='/'))
source(paste(libdir,"zip.R",sep='/'))

if(libdir!='')
{
    setLibPath(libdir)
	install.required.packages(libdir)
}

on.exit(cleanup())
#chooseG.packages <- function() {
#	packages <- c("fpc")
#	LoadPackages(packages)
#}

#unzip preprocessed data
unzip.file(MixtureModel, getwd())

retfiles <- dir("./",pattern = ".ret")
concatfiles <- dir("./",pattern=".membership.txt")
pairplots <- dir("./",pattern=".pairplots.png")
paramfiles <- dir("./",pattern=".parameters.txt")
locationfiles <- dir("./",pattern=".locations.txt")
heatmaps <- dir("./",pattern=".heatmap.png")
model.specs <- dget("mixtureModelSpecs.ret")

g.range <- model.specs$g.range
dist <- model.specs$dist
dim <- model.specs$dim

seed <- as.integer(seed)

#collect optimal.g files for each sample
gfile <- findOptG(
concatfiles = concatfiles,
retfiles = retfiles,
g.method = choose.g.method,
dist = dist,
g = g.range,
dim = dim,
seed = seed,
fileset.name = output.prefix)

collectGFiles(gfile,choose.g.method,libdir,output.prefix)

bestG.range <- c(min(gfile[,2]),max(gfile[,2]))
bestGSpecs <- c()
bestGSpecs$bestG.range <- bestG.range
bestGSpecs$dist <- dist
bestGSpecs$dim <- dim
dput(bestGSpecs, paste(output.prefix,"OptimalGSpecs.ret",sep='.'))
zip.file(libdir = libdir,files = " *OptimalGSpecs.ret",outfile = paste(output.prefix,"OptimalG.zip",sep='.'))

file.remove(retfiles)
file.remove(concatfiles)
file.remove(pairplots)
file.remove(paramfiles)
file.remove(locationfiles)
file.remove(heatmaps)
}

install.required.packages <- function(libdir)
{
    if(!is.package.installed(libdir, "mclust02"))
	{
		install.package(libdir, "mclust02_2.1-17.zip", "mclust02_2.1-17.tgz", "mclust02_2.1-17.tar.gz")
	}
    if(!is.package.installed(libdir, "fpc"))
	{
		install.package(libdir, "fpc_1.2-3.zip", "fpc_1.2-3.tgz", "fpc_1.2-3.tar.gz")
	}
}
