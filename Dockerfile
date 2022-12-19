# Set docker image
FROM ubuntu:18.04

# Skip the configuration part
ENV DEBIAN_FRONTEND noninteractive

# Update and install depedencies
RUN apt update && apt install -y wget unzip bc vim libleptonica-dev git make g++

# Packages to complie Tesseract
RUN cd /tmp && wget http://ftp.gnu.org/gnu/make/make-4.4.tar.gz && tar xvf make-4.4.tar.gz && \
    cd make-4.4/ && ./configure && make && make install && \
    cd .. && rm -rf make-4.4.tar.gz make-4.4
ENV PATH=/usr/local/bin:$PATH
RUN apt install -y autoconf automake libtool pkg-config libpng-dev libjpeg8-dev libtiff5-dev libicu-dev \
        libpango1.0-dev autoconf-archive

# Set working directory
WORKDIR /app

# Copy requirements into the container at /app
COPY requirements.txt ./

# Getting tesstrain: beware the source might change or not being available
# Complie Tesseract with training options (also feel free to update Tesseract versions and such!)
# Getting data: beware the source might change or not being available
ARG TESS_VERSION=5.2.0
RUN mkdir src && cd /app/src && \
    wget https://github.com/tesseract-ocr/tesseract/archive/refs/tags/$TESS_VERSION.zip -O $TESS_VERSION.zip && \
	unzip $TESS_VERSION.zip && \
    cd /app/src/tesseract-$TESS_VERSION && ./autogen.sh && ./configure && make && make install && ldconfig && \
    make training && make training-install && \
    cd /usr/local/share/tessdata && wget https://github.com/tesseract-ocr/tessdata_best/raw/main/eng.traineddata -O eng_best.traineddata

# Setting the data prefix
ENV TESSDATA_PREFIX=/usr/local/share/tessdata

# Install libraries using pip installer
RUN pip3 install -r requirements.txt

# Set the locale
RUN apt install -y locales && locale-gen en_US.UTF-8
ENV LC_ALL=en_US.UTF-8
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US.UTF-8
