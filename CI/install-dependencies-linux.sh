#!/bin/sh
set -ex

# OBS Studio deps
sudo add-apt-repository ppa:kirillshkrogalev/ffmpeg-next -y
sudo apt-get -qq update
sudo apt-get install -y \
        build-essential \
        checkinstall \
        cmake \
        libasound2-dev \
        libavcodec-ffmpeg-dev \
        libavdevice-ffmpeg-dev \
        libavfilter-ffmpeg-dev \
        libavformat-ffmpeg-dev \
        libavutil-ffmpeg-dev \
        libcurl4-openssl-dev \
        libfontconfig-dev \
        libfreetype6-dev \
        libgl1-mesa-dev \
        libjack-jackd2-dev \
        libjansson-dev \
        libpulse-dev \
        libqt5x11extras5-dev \
        libspeexdsp-dev \
        libswresample-ffmpeg-dev \
        libswscale-ffmpeg-dev \
        libudev-dev \
        libv4l-dev \
        libvlc-dev \
        libx11-dev \
        libx264-dev \
        libxcb-shm0-dev \
        libxcb-xinerama0-dev \
        libxcomposite-dev \
        libxinerama-dev \
        pkg-config \
        qtbase5-dev

# qtwebsockets deps
sudo apt-get install -y qt5-qmake qtbase5-private-dev qtcreator

# obs-websocket deps
cd ..
git clone https://github.com/qt/qtwebsockets/ ./qtwebsockets
cd qtwebsockets
git checkout v5.3.0
qmake
make -j4 
sudo make install

# travis doesn't support xenial yet, so we need this hack to deal with ancient qt 5.2.1 from trusty
sudo sed -i -e 's/5.3.0 ${_Qt5WebSockets_FIND_VERSION_EXACT}/5.2.1 ${_Qt5WebSockets_FIND_VERSION_EXACT}/' /usr/lib/x86_64-linux-gnu/cmake/Qt5WebSockets/Qt5WebSocketsConfig.cmake

# Build obs-studio
cd ..
git clone https://github.com/jp9000/obs-studio ./obs-studio
cd obs-studio
mkdir build && cd build
cmake -DUNIX_STRUCTURE=1 -DCMAKE_INSTALL_PREFIX=/usr ..
make -j4
sudo make install

sudo ldconfig
