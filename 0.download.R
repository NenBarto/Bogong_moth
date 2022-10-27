library(rdrop2)

#token <- drop_auth(rdstoken="droptoken.rds")
#saveRDS(token, "droptoken.rds")

token <- readRDS("droptoken.rds")
# Then pass the token to each drop_ function
drop_acc(dtoken = token)
inDir="/cesar team folder/_customer project files/0702 delwp (previously dse)/completed projects/0702CR18_MPP Icon Species intrasite translocation program/Milestones/DArT raw data Oct 2020"
files<-drop_dir(inDir,dtoken = token)

#download all files
for(i in 1:dim(files)[1]){
	cat(i)
	drop_download(as.character(files[i,3]),dtoken = token,overwrite=T)
}

inDir="cesar Team Folder/_Customer Project Files/0702 DELWP (previously DSE)/0702CR27 Dingo scat project/7.) Data/Output-DCan21-6106"