test

```sh
docker run --rm -i -t \
-v ~/tmp:/var/data \ # here inputs are located
-v ~/ref:/var/refs \ # here reference is located
-e REFERENCE=TAIR10_chr_all.fas \
-e INPUT01=ERR171441_1.fastq \
-e INPUT02=ERR171441_2.fastq \
otiai10/basic-wf
```
