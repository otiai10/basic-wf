
Run

```sh
docker run --rm -i -t \
-v ~/tmp:/var/data \
-e REFERENCE=TAIR10_chr_all.fas \
-e INPUT01=ERR171441_1.fastq \
-e INPUT02=ERR171441_2.fastq \
otiai10/basic-wf
```
