#conda init 
#conda activate stacks

#download:
#curl -X POST https://content.dropboxapi.com/2/files/download --header "Authorization: Bearer YlFphcnWu0cAAAAAAAAAAT_p9Jm4rMkzDJv4LljbdSaVWSr3aOBQbvV-zpqr6yHb" --header "Dropbox-API-Arg: {\"path\": \"/test\"}" -o "./filez.gz"
#curl -X POST https://content.dropboxapi.com/2/files/search/continue_v2 --header "Authorization: Bearer YlFphcnWu0cAAAAAAAAAAT_p9Jm4rMkzDJv4LljbdSaVWSr3aOBQbvV-zpqr6yHb" --header "Dropbox-API-Arg: {\"path\": \"/test\"}" -o "./filez.gz"

projectname="bogongmoth"

projectdir="/Users/bioinformatics/nenbar/CE_0702CR18_BogongMoth"
scriptsdir=$projectdir"/scripts"
annotationdir=$projectdir"/annotation"

#process barcodes
cat $annotationdir/*.csv | awk -F, '{ print $16 , $1 }' | sed "s/ /\\t/" | grep -v "barcode" >$annotationdir"/barcodes.txt"

indir=$projectdir"/raw/combined"
outdir=$projectdir"/results/"$projectname".step1radtagsFast"
mkdir -p $outdir

process_radtags -p $indir -o $outdir -b $annotationdir"/barcodes.txt" -e PstI -r -c -q
#qsub -b y -cwd -j y -N radtags -R y -pe smp 32 -V $radtag_line

