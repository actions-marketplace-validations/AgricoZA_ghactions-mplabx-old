FROM ubuntu:latest

RUN dpkg --add-architecture i386 && apt-get update && \
  apt-get install -y libc6:i386 libx11-6:i386 libxext6:i386 libstdc++6:i386 libexpat1:i386 wget sudo make && \
  rm -rf /var/lib/apt/lists/*

#install MplabX v5.40 
RUN wget -nv -O /tmp/mplabx http://ww1.microchip.com/downloads/en/DeviceDoc/MPLABX-v5.40-linux-installer.tar &&\
  cd /tmp && tar -xf /tmp/mplabx && rm /tmp/mplabx && \
  mv MPLAB*-linux-installer.sh mplabx && \
  sudo ./mplabx --nox11 -- --unattendedmodeui none --mode unattended --ipe 0 --collectInfo 0 --installdir /opt/mplabx && \
  rm mplabx
  
# install xc32 v1.34
RUN wget -nv -O /tmp/xc32 http://ww1.microchip.com/downloads/en/DeviceDoc/xc32-v1.34-full-install-linux-installer.run && \
  chmod +x /tmp/xc32 && \
  /tmp/xc32 --mode unattended --unattendedmodeui minimal --netservername localhost --prefix /opt/microchip/xc32/v1.34 && \
  rm /tmp/xc32

#install Plib
RUN wget -nv -O  wget -nv -O /tmp/pic32 https://ww1.microchip.com/downloads/en//softwarelibrary/pic32%20peripheral%20library/pic32%20legacy%20peripheral%20libraries%20linux%20(2).tar && \
  cd /tmp && \
  tar -xf pic32%20legacy%20peripheral%20libraries%20linux%20(2).tar && \
  ./'PIC32 Legacy Peripheral Libraries.run' --unattendeduimode none --mode unattended --prefix /opt/microchip/xc32/v1.34

COPY build.sh /build.sh

ENTRYPOINT [ "/build.sh" ]
