FROM debian:9 as builder

RUN apt-get update && apt-get install -y python build-essential curl git

# Shaka Packager

# Install depot_tools.
RUN git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git
ENV PATH $PATH:/depot_tools

WORKDIR shaka_packager
RUN gclient config https://www.github.com/google/shaka-packager.git --name=src --unmanaged
RUN gclient sync
RUN cd src && ninja -C out/Release

# Generate lightweight image
from debian:9 as final

ENV PATH "$PATH:/opt/bento/bin/:/opt/shaka_packager/bin/"
RUN mkdir -p /opt/shaka_packager/bin

RUN apt-get update && apt-get install -y unzip ffmpeg vim python mediainfo

# Copy compiled binaries
COPY --from=builder /shaka_packager/src/out/Release/packager \
              	    /shaka_packager/src/out/Release/mpd_generator \
                    /shaka_packager/src/out/Release/pssh-box.py \
                    /opt/shaka_packager/bin/
COPY --from=builder /shaka_packager/src/out/Release/pyproto /usr/bin/pyproto

# Bento4
ARG BENTO4_VERSION=1-5-1-628
ADD http://zebulon.bok.net/Bento4/binaries/Bento4-SDK-$BENTO4_VERSION.x86_64-unknown-linux.zip /tmp/bento.zip
RUN unzip /tmp/bento.zip -d /opt && mv /opt/Bento4-SDK-$BENTO4_VERSION.x86_64-unknown-linux /opt/bento

