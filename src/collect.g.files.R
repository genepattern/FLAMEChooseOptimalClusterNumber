collectGFiles <- function(gfile,choose.g.method,libdir,output.prefix) {

#retfiles <- c()
#txtfiles <- c()
#locationsfiles <- c()
#paramfiles <- c()
#heatmapfiles <- c()
#pairplotfiles <- c()

for (i in 1:nrow(gfile)) {
#ret
	ret.pattern = paste(gfile[i,1],gfile[i,2],"ret",sep = ".")
	retfile <- dir("./", pattern = ret.pattern)
	zip.file(libdir = libdir,files = retfile,outfile = paste(output.prefix,"OptimalG.zip",sep='.'))
#	retfiles <- c(retfiles, retfile)
#membership
	txt.pattern = paste(gfile[i,1],gfile[i,2],"membership.txt",sep = ".")
	txtfile <- dir("./", pattern = txt.pattern)
	zip.file(libdir = libdir,files = txtfile,outfile = paste(output.prefix,"OptimalG.zip",sep='.'))
#	txtfiles <- c(txtfiles,	txtfile)
#locations
	locations.pattern = paste(gfile[i,1],gfile[i,2],"locations.txt",sep = ".")
	locationsfile <- dir("./", pattern = locations.pattern)
	zip.file(libdir = libdir,files = locationsfile,outfile = paste(output.prefix,"OptimalG.zip",sep='.'))
#	locationsfiles <- c(locationsfiles, locationsfile)
#parameters
	param.pattern = paste(gfile[i,1],gfile[i,2],"parameters.txt",sep = ".")
	paramfile <- dir("./", pattern = param.pattern)
	zip.file(libdir = libdir,files = paramfile,outfile = paste(output.prefix,"OptimalG.zip",sep='.'))
#	paramfiles <- c(paramfiles, paramfile)
#heatmaps
	heatmap.pattern = paste(gfile[i,1],gfile[i,2],"heatmap.png",sep = ".")
	heatmapfile <- dir("./", pattern = heatmap.pattern)
	zip.file(libdir = libdir,files = heatmapfile,outfile = paste(output.prefix,"OptimalG.zip",sep='.'))
#	heatmapfiles <- c(heatmapfiles, heatmapfile)
#pairplots
	pair.pattern = paste(gfile[i,1],gfile[i,2],"pairplots.png",sep = ".")
	pairplotfile <- dir("./", pattern = pair.pattern)
	zip.file(libdir = libdir,files = pairplotfile,outfile = paste(output.prefix,"OptimalG.zip",sep='.'))
#	pairplotfiles <- c(pairplotfiles, pairplotfile)
}

#move opt. g files to new directory
#g.path <- outdir
#file.copy(retfiles, to = g.path)
#zip.file(libdir = libdir,files = retfiles,outfile = paste(output.prefix,"OptimalG.zip",sep='.'))
#file.copy(txtfiles, to = g.path)
#zip.file(libdir = libdir,files = txtfiles,outfile = paste(output.prefix,"OptimalG.zip",sep='.'))
#file.copy(locationsfiles, to = g.path)
#zip.file(libdir = libdir,files = locationsfiles,outfile = paste(output.prefix,"OptimalG.zip",sep='.'))
#file.copy(paramfiles, to = g.path)
#zip.file(libdir = libdir,files = paramfiles,outfile = paste(output.prefix,"OptimalG.zip",sep='.'))
#file.copy(heatmapfiles, to = g.path)
#zip.file(libdir = libdir,files = heatmapfiles,outfile = paste(output.prefix,"OptimalG.zip",sep='.'))
#file.copy(pairplotfiles, to = g.path)
#zip.file(libdir = libdir,files = pairplotfiles,outfile = paste(output.prefix,"OptimalG.zip",sep='.'))

if (choose.g.method == "distance.ratio") {
	wbratiofile <- dir("./",pattern="distance.ratio.txt")
#	file.copy(wbratiofile, to = g.path)
	zip.file(libdir = libdir,files = wbratiofile,outfile = paste(output.prefix,"OptimalG.zip",sep='.'))
#	file.remove(wbratiofile)
}
if (choose.g.method == "intercluster.distance") {
	betweenfile <- dir("./",pattern="intercluster.distance.txt")
#	file.copy(betweenfile, to = g.path)
	zip.file(libdir = libdir,files = betweenfile,outfile = paste(output.prefix,"OptimalG.zip",sep='.'))
#	file.remove(betweenfile)
}
if (choose.g.method == "BIC") {
	BICfile <- dir("./",pattern = "BIC.txt")
#	file.copy(BICfile,to=g.path)
	zip.file(libdir = libdir,files = BICfile,outfile = paste(output.prefix,"OptimalG.zip",sep='.'))
#	file.remove(BICfile)
}
if (choose.g.method == "AIC") {
	BICfile <- dir("./",pattern = "AIC.txt")
#	file.copy(AICfile,to=g.path)
	zip.file(libdir = libdir,files = AICfile,outfile = paste(output.prefix,"OptimalG.zip",sep='.'))
#	file.remove(AICfile)
}
if (choose.g.method == "SWR") {
	SWRfile <- dir("./",pattern = "SWR.txt")
#	file.copy(SWRfile,to=g.path)
	zip.file(libdir = libdir,files = SWRfile,outfile = paste(output.prefix,"OptimalG.zip",sep='.'))
#	file.remove(SWRfile)
}


}