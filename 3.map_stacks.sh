#conda init 
#conda activate gatk

#download:
#curl -X POST https://content.dropboxapi.com/2/files/download --header "Authorization: Bearer iTRjXf6DX4MAAAAAAAAAAdPDyWQBxoKYM-G_RS7hU-CrXQXgdq6xZ9IfuD91Jy3y" --header "Dropbox-API-Arg: {\"path\": \"/cesar Team Folder/_Customer Project Files/0702 DELWP (previously DSE)/0702CR27 Dingo scat project/7.) Data/Output-DCan21-6106"}""
#curl -X POST https://content.dropboxapi.com/2/files/download --header "Authorization: Bearer iTRjXf6DX4MAAAAAAAAAAdPDyWQBxoKYM-G_RS7hU-CrXQXgdq6xZ9IfuD91Jy3y" --header "Dropbox-API-Arg: {\"path\": \"test/2467376.FASTQ.gz\"}" -o "./annotation.tar.gz"

#https://www.dropbox.com/home/test/2467376.FASTQ.gz
#/_Customer Project Files/0702 DELWP (previously DSE)/0702CR27 Dingo scat project/7.) Data/Output-DCan21-6106

#to do 
#run one sample 2209339
#GATK
#R package

projectname="bogongmoth"
projectdir="/Users/bioinformatics/nenbar/CE_0702CR18_BogongMoth"
inDir=$projectdir"/results/"$projectname".step1radtagsFast"
inDir="/Volumes/4MIDABLE/nenbar/0702CR18_MPP/results/bogongmoth.step1radtagsFast"

resultsDir=$projectdir"/results"
mkdir -p $resultsDir

annotationDir=$projectdir"/annotation"
index=$annotationDir/"GCA_943136025.1_ilAgrPuta1.1_genomic.fna"
logDir=$projectdir"/scripts/logs"
mkdir -p $logDir

bwaDir="$resultsDir/"$projectname".bwa"
mkdir -p $bwaDir
stackDir="$resultsDir/"$projectname".stacks"
mkdir -p $stackDir

#load files
files=`ls $inDir/*fq.gz`

files=( $files )

#file="/share/ScratchGeneral/nenbar/projects/canfam/results/DCan20_21.step1radtagsFast/2473384.fq.gz"
for file in $inDir/*fq.gz; do 
  echo $file; 

  sampleName=`basename $file | sed s/.fq.gz//`
  echo $sampleName

  bamFile="$bwaDir/$sampleName.temp.bam"
  sortedBamFile="$bwaDir/$sampleName"
  samFile="$bwaDir/$sampleName.sam"

  bwa mem -t 8 $index $file > $samFile  
  samtools view -S -b $samFile -o $bamFile
  samtools sort $bamFile -o $sortedBamFile.bam
  samtools index $sortedBamFile.bam
  rm -f $bamFile & rm -f $samFile
 
 done 

  #mapping_line="bwa mem $index $file -o $samFile" 
  #sam2bam_line="samtools view -S -b $samFile -o $bamFile"
  #sort_line="samtools sort $bamFile $sortedBamFile"
  #index_line="samtools index $bwaDir/$sampleName.bam"
  #clean_line="rm -f $bamFile & rm -f $samFile"
  
  #qsub -b y -hold_jid radtags -wd $logDir -j y -N map$sampleName -R y -pe smp 1 -V $mapping_line
  #qsub -b y -hold_jid map$sampleName -wd $logDir -j y -N sam2bam$sampleName -R y -pe smp 1 -V $sam2bam_line
  #qsub -b y -hold_jid sam2bam$sampleName -wd $logDir -j y -N sort$sampleName -R y -pe smp 1 -V $sort_line
  #qsub -b y -hold_jid sort$sampleName -wd $logDir -j y -N index$sampleName -R y -pe smp 1 -V $index_line
  #qsub -b y -hold_jid index$sampleName -wd $logDir -j y -N clean$sampleName -R y -pe smp 1 -V $clean_line

done

#create popmap
#dataold<-read.csv("short.csv",header=T)
#datanew<-read.csv("annotation.csv",header=T)
#names(dataold)<-c("id","genotype","barcode")
#merged<-merge(dataold,datanew,by.x="genotype",by.y="Sample.ID")
#merged$pop<-paste(merged$State,merged$LACP.Region,sep="_")
#merged$pop<-gsub("_$","",merged$pop)
#mergedS<-merged[,c("id","pop")]
#mergedS$pop<-gsub(" ","_",mergedS$pop)
#mergedS$pop<-gsub("_$","",mergedS$pop)
#mergedS$pop<-gsub("_$","",mergedS$pop)
#mergedS$pop<-gsub("\\/","_",mergedS$pop)
#write.table(mergedS,"popmap",quote=F,sep="\t",row.names=F)


gstacksLine="gstacks -I $bwaDir -M $annotationDir/popmap -O $stackDir -t 8"
#qsub -b y -hold_jid clean$sampleName -wd $logDir -j y -N gstacks -R y -pe smp 32 -V $gstacksLine
##IGV
#populationsLine="populations -P $stackDir -M $annotationDir/popmap -r 0.65 --vcf --genepop --fstats --smooth --hwe -t 2"
#qsub -b y -hold_jid gstacks -wd $logDir -j y -N populationsLine -R y -pe smp 32 -V $populationsLine
#
#populationsLine="populations -P $stackDir -M $annotationDir/popmap -r 0.65 --vcf --genepop --hwe -t 8"
#qsub -b y -hold_jid gstacks -wd $logDir -j y -N populationsLine -R y -pe smp 32 -V $populationsLine





