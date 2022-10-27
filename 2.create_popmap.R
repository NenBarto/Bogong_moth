
projectdir="../"
scriptsdir=paste0(projectdir,"/scripts")
annotationdir=paste0(projectdir,"/annotation")

files<-list.files(annotationdir,pattern="targets",full.names=T)
results<-list()
for(file in files){
	results[[file]]<-read.csv(file)
}
targets<-do.call("rbind",results)

#data<-read.csv(paste0(annotationdir,"/subsample_annotated.csv"))


#clean targets
targets$id<-targets$targetid
targets$cleanIDs<-targets$genotype
#targets<-targets[!grepl("rep",targets$cleanIDs),]
#merged<-merge(targets,data,by.x="cleanIDs",by.y="Genotype")
targets$pop<-gsub(" Nov| rep.*| sample.*| mixed.*| dark*| Techni.*| techni.*| mid.*| Oct.*| light.*| \\d.*","",targets$genotype)
targets$pop<-gsub("^Buller","Mt Buller",targets$pop)
targets$pop<-gsub("Guthega.*","Guthega",targets$pop)
targets$pop<-gsub("Buller.*","Buller",targets$pop)
targets$pop<-gsub("Charlotte Pass.*","Charlotte Pass",targets$pop)

write.table(targets,"../annotation/combined_annotation.txt",quote=F,sep="\t")

popmap<-targets[,c("targetid","pop")]
write.table(popmap,file=paste0(paste0(projectdir,"/annotation/popmap")),quote=F,row.names=F,col.names = F,sep="\t")
