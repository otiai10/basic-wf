FROM centos

RUN yum update && \
    yum install -y \
    gcc \
    git \
    wget \
    make \
    zlib-devel \
    bzip2 \
    bzip2-devel \
    xz-devel \
    ncurses-devel

# bwa
RUN git clone https://github.com/lh3/bwa.git && \
    cd bwa && \
    make && chmod 755 ./bwa && \
    cp ./bwa /bin/bwa

RUN cd /

# samtools
RUN wget https://github.com/samtools/samtools/releases/download/1.4.1/samtools-1.4.1.tar.bz2 && \
    tar -xvf samtools-1.4.1.tar.bz2 && \
    cd samtools-1.4.1 && \
    make && make install && \
    mv samtools /bin/

# pip
RUN curl "https://bootstrap.pypa.io/get-pip.py" -o "get-pip.py"
RUN python get-pip.py

# filtertool
RUN pip install scipy git+https://github.com/otiai10/filtertool.git

ADD ./main.sh /bin/

ENTRYPOINT /bin/main.sh
