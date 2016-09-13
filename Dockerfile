FROM debian:jessie
MAINTAINER tgagor, https://github.com/tgagor

ENV TERM xterm
ENV DEBIAN_FRONTEND noninteractive
ENV EMAIL=youremail \
    PASSWORD=yourpassword \
    DOWNLOAD_FOLDER=/books \
    DOWNLOAD_FORMATS="pdf, epub, mobi, code"

# Install prerequisites
RUN mkdir /opt/ppfl
RUN apt-get update \
  && apt-get install -y python3 python3-pip python3-requests git \
  && pip3 install beautifulsoup4 \
  && git clone https://github.com/igbt6/Packt-Publishing-Free-Learning.git /opt/ppfl \
  && apt-get remove -y python3-pip git \
  && apt-get autoremove -y \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

COPY genconf.sh /opt/ppfl/genconf.sh
RUN chmod +x /opt/ppfl/genconf.sh

WORKDIR /opt/ppfl/
ENTRYPOINT ["/opt/ppfl/genconf.sh"]
CMD ["python3", "/opt/ppfl/packtPublishingFreeEbook.py", "-gd"]
