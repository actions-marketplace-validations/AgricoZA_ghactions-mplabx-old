FROM ubuntu:bionic 
#Latest ubuntu with i386 supported

ENV XC32VER v2.41
ENV MPLABXVER v5.40

RUN apt-get update && apt-get install -y --no-install-recommends apt-utils

# RUN dpkg --add-architecture i386 && apt-get update && \
#   apt-get install -y libc6:i386 libx11-6:i386 libxext6:i386 libstdc++6:i386 libexpat1:i386 wget sudo make && \
#   rm -rf /var/lib/apt/lists/*

RUN dpkg --add-architecture i386 \
  && apt-get update -yq \
  && apt-get install -yq --no-install-recommends ca-certificates wget unzip libc6:i386 git \
  libx11-6:i386 libxext6:i386 libstdc++6:i386 libexpat1:i386 \
  libxext6 libxrender1 libxtst6 libgtk2.0-0 make \
  && rm -rf /var/lib/apt/lists/*

# Install MPLAB ${MPLABXVER}
RUN wget https://ww1.microchip.com/downloads/en/DeviceDoc/MPLABX-${MPLABXVER}-linux-installer.tar -q --show-progress --progress=bar:force:noscroll -O MPLABX-${MPLABXVER}-linux-installer.tar \
  && tar xf MPLABX-${MPLABXVER}-linux-installer.tar && rm -f MPLABX-${MPLABXVER}-linux-installer.tar \
  && USER=root ./*-installer.sh --nox11 \
  -- --unattendedmodeui none --mode unattended \
  && rm -f MPLABX-${MPLABXVER}-linux-installer.sh


# Install XC32 ${XC32VER}
RUN wget https://ww1.microchip.com/downloads/en/DeviceDoc/xc32-${XC32VER}-full-install-linux-installer.run -q --show-progress --progress=bar:force:noscroll -O xc32-${XC32VER}-full-install-linux-installer.run\
  && chmod a+x xc32-${XC32VER}-full-install-linux-installer.run \
  && ./xc32-${XC32VER}-full-install-linux-installer.run \
  --mode unattended --unattendedmodeui none \
  --netservername localhost \
  && rm -f xc32-${XC32VER}-full-install-linux-installer.run


#install Plib
RUN wget -nv -O  wget -nv -O /tmp/pic32Plib "https://ww1.microchip.com/downloads/en//softwarelibrary/pic32%20peripheral%20library/pic32%20legacy%20peripheral%20libraries%20linux%20(2).tar" && \
  cd /tmp && \
  tar -xf pic32Plib && \
  ./'PIC32 Legacy Peripheral Libraries.run' --unattendedmodeui none --mode unattended --prefix /opt/microchip/xc32/${XC32VER} && \
  rm pic32Plib


# # install MplabX v5.40 
# RUN wget -nv -O /tmp/mplabx http://ww1.microchip.com/downloads/en/DeviceDoc/MPLABX-v5.40-linux-installer.tar &&\
#   cd /tmp && tar -xf /tmp/mplabx && rm /tmp/mplabx && \
#   mv MPLAB*-linux-installer.sh mplabx && \
#   sudo ./mplabx --nox11 -- --unattendedmodeui none --mode unattended --ipe 0 --collectInfo 0 --installdir /opt/mplabx && \
#   rm mplabx

ENV PATH $PATH:/opt/microchip/xc32/${XC32VER}/bin
ENV PATH $PATH:/opt/microchip/mplabx/${MPLABXVER}/mplab_platform/bin  

# RUN apt-get update

COPY build.sh /build.sh

ENTRYPOINT [ "/build.sh" ]
