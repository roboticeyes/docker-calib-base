# Copyright (C) 2021 Robotic Eyes
#
# THIS CODE AND INFORMATION ARE PROVIDED "AS IS" WITHOUT WARRANTY OF ANY
# KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A
# PARTICULAR PURPOSE.

ARG BASE_IMAGE_NAME="debian"
ARG BASE_IMAGE_VERSION="10.8-slim"
ARG BASE_IMAGE="${BASE_IMAGE_NAME}:${BASE_IMAGE_VERSION}"

FROM ${BASE_IMAGE}

RUN mkdir -p /usr/share/man/man1 /usr/share/man/man2
ENV DEBIAN_FRONTEND=noninteractive

RUN \
  apt-get update && \
  apt-get -y install --no-install-recommends \
    openjdk-11-jdk \
    octave && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*

RUN \
  apt-get update && \
  apt-get -y install \
    build-essential \
    cmake \
    wget \
    git \
    vim && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*

WORKDIR "/tmp/build"

# Build OpenCV
ENV OPENCV_VERSION="2.4.13.6"
ENV OPENCV_BASE_URL="https://github.com/opencv"
ENV OPENCV_PACKAGE="${OPENCV_BASE_URL}/opencv/archive/${OPENCV_VERSION}.tar.gz"

RUN \
  wget -O package.tar.gz -r ${OPENCV_PACKAGE} && tar xvfz package.tar.gz && rm -r package.tar.gz && \
  mkdir -p build && cd build && \
  cmake -DCMAKE_BUILD_TYPE=Release \
      -DINSTALL_C_EXAMPLES=OFF \
      -DOPENCV_GENERATE_PKGCONFIG=ON \
      -DBUILD_EXAMPLES=OFF \
      -DCMAKE_INSTALL_PREFIX=/usr \
      ../opencv-${OPENCV_VERSION} && \
  make -j$(nproc) && \
  make install && \
  cd .. && \
  rm -rf build && rm -rf opencv*
