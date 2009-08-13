findOptG <- function(concatfiles, retfiles, g.method, dist, g, dim, seed,fileset.name){
	library(fpc)
	num.g <- length(g)
	####
	wbratio <- matrix(nrow=0, ncol = 2+num.g)
	between <- matrix(nrow=0, ncol = 2+num.g)
	BIC <- matrix(nrow=0, ncol = 2+num.g)
	AIC <- matrix(nrow=0, ncol = 2+num.g)
	SWR <- matrix(nrow=0, ncol = 2+num.g)
	#wbratio <- matrix(nrow = length(concatfiles)/num.g, ncol = 2+num.g, dimnames = list(c(1:(length(concatfiles)/num.g)),c("file",paste(dist,g,sep=''),"choose")))
	#between<- matrix(nrow = length(concatfiles)/num.g, ncol = 2+num.g, dimnames = list(c(1:(length(concatfiles)/num.g)),c("file",paste(dist,g,sep=''),"choose")))
	#BIC<- matrix(nrow = length(concatfiles)/num.g, ncol = 2+num.g, dimnames = list(c(1:(length(concatfiles)/num.g)),c("file",paste(dist,g,sep=''),"choose")))
	#AIC<- matrix(nrow = length(concatfiles)/num.g, ncol = 2+num.g, dimnames = list(c(1:(length(concatfiles)/num.g)),c("file",paste(dist,g,sep=''),"choose")))
	#SWR<- matrix(nrow = length(concatfiles)/num.g, ncol = 2+num.g, dimnames = list(c(1:(length(concatfiles)/num.g)),c("file",paste(dist,g,sep=''),"choose")))

    colnames(wbratio) <- c("file",paste(dist,g,sep=''),"choose")
    colnames(between) <- c("file",paste(dist,g,sep=''),"choose") 
    colnames(BIC) <- c("file",paste(dist,g,sep=''),"choose")
    colnames(AIC) <- c("file",paste(dist,g,sep=''),"choose")
    colnames(SWR) <- c("file",paste(dist,g,sep=''),"choose")

	for (n in g) {	
		print(n)
		assign("files", concatfiles[grep(paste(dist,n,"membership.txt",sep ='.'),concatfiles)])
		assign("files2",retfiles[grep(paste(dist,n,"ret",sep ='.'),retfiles)])
		for (i in 1:length(files)) {
			filename <- strsplit(files[i], paste('\\',n,"membership.txt",sep='.'))[[1]][1]
            filename <- as.character(filename)

            indices <- which(wbratio==filename, arr.ind=T)

			if(length(indices) == 0)
			{
			    wbratio <- rbind(wbratio, NA)
			    # add row name to new row
			    rownames(wbratio)[nrow(wbratio)] <- nrow(wbratio)

			    between <- rbind(between, NA)
			    # add row name to new row
			    rownames(between)[nrow(between)] <- nrow(between)

			    BIC <- rbind(BIC, NA)
			    # add row name to new row
			    rownames(BIC)[nrow(BIC)] <- nrow(BIC)

			    AIC <- rbind(AIC, NA)
			    # add row name to new row
			    rownames(AIC)[nrow(AIC)] <- nrow(AIC)

			    SWR <- rbind(SWR, NA)
			    # add row name to new row
			    rownames(SWR)[nrow(SWR)] <- nrow(SWR)


			    # assign to newly created row which is the last row
			    row <- nrow(wbratio)
			}
			else
			{
			    # assign to row index
			    row <- indices[1]
			}

			wbratio[row,1] <- filename
			between[row,1] <- filename
			#cluster.stats
			concatfile <- read.table(files[i], header= T, sep = "\t")
		
			if (g.method == "intercluster.distance" | g.method == "distance.ratio") {
				if(dim(concatfile)[1]>3000) {
					set.seed(seed)
					y<-sample(1:dim(concatfile)[1],size=3000)
					concatfile <- concatfile[y,]
				}
			points <- subset(concatfile, select = c(1:dim))
			clustering <- subset(concatfile, select = c(dim+1))
			cs <- cluster.stats(d = dist(points), clustering = clustering, silhouette = F)
			wbratio[row,(2+n-g[1])] <- cs$wb.ratio
			between[row,(2+n-g[1])] <- cs$average.between			#BIC
			}
			
			if (g.method == "BIC") {
			#BIC                                               
			BIC[row,1] <- filename
			ret <- dget(files2[i])
			BIC[row,(2+n-g[1])] <- ret$bic
			}

			if (g.method == "AIC") {
			#AIC
			AIC[row,1] <- filename
			ret <- dget(files2[i])
			AIC[row,(2+n-g[1])] <- ret$aic
			}
	
			if (g.method == "SWR") {
			#SWR
			SWR[row,1] <- filename
			ret <- dget(files2[i])
			SWR[row,(2+n-g[1])] <- ret$SWR$SWR
			}
		}
	}
	
	if (g.method == "intercluster.distance" | g.method == "distance.ratio") {
	    for (r in 1:nrow(wbratio)) {
		    ratios <- matrix(wbratio[r,(2:(num.g+1))])
		    min.ratio <- min(ratios, na.rm=TRUE)
		    for (n in g) {
			    column = which(g==n)

			    if (!is.na(ratios[column]) && ratios[column] == min.ratio) {wbratio[r,num.g+2] = n}
		    }
	    }
	    for (r in 1:nrow(between)) {
		    ratios <- matrix(between[r,(2:(num.g+1))])
		    max.ratio <- max(ratios, na.rm=TRUE)
		    for (n in g) {
			    column = which(g==n)
			    if (!is.na(ratios[column]) && ratios[column] == max.ratio) {between[r,num.g+2] = n}
		    }
	    }
	}

	if (g.method == "BIC") {
	for (r in 1:nrow(BIC)) {
		ratios <- matrix(BIC[r,(2:(num.g+1))])			
		max.ratio <- max(ratios, na.rm=TRUE)
		for (n in g) {
			column = which(g==n)
			if ( !is.na(ratios[column]) && ratios[column] == max.ratio) {BIC[r,num.g+2] = n}
		}
	}
	}

	if (g.method == "AIC") {
	for (r in 1:nrow(AIC)) {
		ratios <- matrix(AIC[r,(2:(num.g+1))])			
		max.ratio <- max(ratios, na.rm=TRUE)
		for (n in g) {
			column = which(g==n)
			if (!is.na(ratios[column]) && ratios[column] == max.ratio) {AIC[r,num.g+2] = n}
		}
	}
	}

	if (g.method == "SWR") {
	for (r in 1:nrow(SWR)) {
		ratios <- matrix(SWR[r,(2:(num.g+1))])			
		min.ratio <- min(ratios, na.rm=TRUE)
		for (n in g) {
			column = which(g==n)
			if (!is.na(ratios[column]) && ratios[column] == min.ratio) {SWR[r,num.g+2] = n}
		}
	}
	}

	if (g.method == "distance.ratio") {
		gfile <- subset(wbratio, select = c(1,num.g+2))
		write.table(wbratio, file = paste(fileset.name,dist,"distance.ratio.txt",sep ='.'), row.names = F, quote =F, sep = '\t')	
	}
	if (g.method == "intercluster.distance") {
		gfile <- subset(between, select = c(1,num.g+2))
		write.table(between, file = paste(fileset.name,dist,"intercluster.distance.txt",sep ='.'), row.names = F, quote =F, sep = '\t')	
	}
	if (g.method == "BIC") {
		gfile <- subset(BIC, select = c(1,num.g+2))
		write.table(BIC, file = paste(fileset.name, dist,"BIC.txt",sep='.'),row.names=F,quote=F,sep='\t')
	}
	if (g.method == "AIC") {
		gfile <- subset(AIC, select = c(1,num.g+2))
		write.table(AIC, file = paste(fileset.name, dist,"AIC.txt",sep='.'),row.names=F,quote=F,sep='\t')
	}
	if (g.method == "SWR") {
		gfile <- subset(SWR, select = c(1,num.g+2))
		write.table(SWR, file = paste(fileset.name,dist,"SWR.txt",sep ='.'), row.names = F, quote =F, sep = '\t')	
	}
	
	return(gfile)
}
