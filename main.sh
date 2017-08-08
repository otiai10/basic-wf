#!/bin/sh

###
# This is a basic workflow as an example for "Genomoose Project".
###

echo "[basic-wf][0] Checking input parameters (mostly provided as env variables)"
if [ ! -f "/var/refs/${REFERENCE}" ]; then
    echo "[basic-wf][ERROR] REFERENCE file not found: specified with '${REFERENCE}', searched at /var/refs"
    exit 1
fi
if [ ! -f "/var/data/${INPUT01}" ]; then
    echo "[basic-wf][ERROR] INPUT01 file not found: specified with '${INPUT01}', searched at /var/data"
    exit 1
fi
if [ ! -f "/var/data/${INPUT02}" ]; then
    echo "[basic-wf][ERROR] INPUT02 file not found: specified with '${INPUT02}', searched at /var/data"
    exit 1
fi

RESULT_PREFIX=result.${INPUT01}_x_${INPUT02}

echo "[basic-wf][0] >>> Decompress files if having \".tar.bz2\" extension: '${INPUT01}', '${INPUT02}'"
if [[ ${INPUT01} == *.tar.bz2 ]]; then
  tar xvjf /var/data/${INPUT01} --directory /var/data
  INPUT01=`echo ${INPUT01} | sed "s/\.tar.bz2$//"`
fi
if [[ ${INPUT02} == *.tar.bz2 ]]; then
  tar xvjf /var/data/${INPUT02} --directory /var/data
  INPUT02=`echo ${INPUT02} | sed "s/\.tar.bz2$//"`
fi

echo "[basic-wf][1] >>> align provided read samples: '${INPUT01}', '${INPUT02}'"
/bin/bwa mem /var/refs/${REFERENCE} /var/data/${INPUT01} /var/data/${INPUT02} > /var/data/${RESULT_PREFIX}.sam

echo "[basic-wf][2] >>> bamify result sam file: '${RESULT_PREFIX}.sam'"
/bin/samtools view -S -b -h /var/data/${RESULT_PREFIX}.sam > /var/data/${RESULT_PREFIX}.bam

echo "[basic-wf][3] >>> sort bam: '${RESULT_PREFIX}.bam'"
/bin/samtools sort /var/data/${RESULT_PREFIX}.bam > /var/data/${RESULT_PREFIX}.sorted.bam

echo "[basic-wf][4] >>> make pileup file: '${RESULT_PREFIX}.sorted.bam'"
/bin/samtools mpileup /var/data/${RESULT_PREFIX}.sorted.bam > /var/data/${RESULT_PREFIX}.pileup

echo "[basic-wf][5] >>> filter pileup: '${RESULT_PREFIX}.pileup'"
filtertool -i /var/data/${RESULT_PREFIX}.pileup -o /var/data/${RESULT_PREFIX}.filtered.vcf \
  --depth 20 \
  --count 6 \
  --freq 0.5 \
  --verbose \
#  --alg fishers,p=0.1

echo "[basic-wf][x] Your workflow is done. Bye."
