#!/bin/bash
#SBATCH --job-name="seqwish-20231205"
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=32
#SBATCH --mem=2000gb
#SBATCH --time=07-00:00:00
#SBATCH --qos=highmem
#SBATCH --partition=cbcb
#SBATCH --account=cbcb
#SBATCH --exclusive
#SBATCH --hint=multithread
#SBATCH --constraint=EPYC-7313

SWDIR="/fs/cbcb-lab/ekmolloy/ekmolloy/lifetree/primates/ekm/software/"
SEQWISH="$SWDIR/seqwish/bin/seqwish"

DATE="20231205"
DATDIR="/fs/cbcb-lab/ekmolloy/primate_t2t_pangenome/data-$DATE"

SEQS="$DATDIR/primates16.$DATE.fa"
PAFS=$(ls -m $DATDIR/primates16.${DATE}_wfmash-v0.12.4/*.aln.paf | tr -d "\n" )
OUTG="$DATDIR/primates16.$DATE.gfa"

# Save node name
uname -n

# Do some clean up
rm -rf /dev/shm/seqwish*

# Run seqwish
/usr/bin/time -vv $SEQWISH \
    -s $SEQS \
    -p $PAFS \
    -b /dev/shm \
    -g $OUTG \
    -B1 \
    -t32 \
    -P \
    > seqwish-$DATE.out \
    2> seqwish-$DATE.err

