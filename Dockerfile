# Arm Corstone-300 & Ethos-U55 Edge AI Workshop Container
# Slide 5: "Pre-Configured Containers: Docker image containing Zephyr SDK, Python dependencies, and Vela compiler"

FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV ZEPHYR_SDK_VERSION=0.16.8
ENV PATH="/root/.local/bin:${PATH}"

# Install core build toolchains and dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    cmake \
    ninja-build \
    gcc-arm-none-eabi \
    libnewlib-arm-none-eabi \
    qemu-system-arm \
    python3 \
    python3-pip \
    python3-dev \
    git \
    wget \
    curl \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Install Arm Vela Compiler and Edge AI tools
RUN pip3 install --no-cache-dir \
    ethos-u-vela==5.2.0 \
    flatbuffers \
    numpy \
    tflite \
    west

WORKDIR /workspace/lab
COPY . /workspace/lab

# Run sanity check during build
RUN python3 scripts/sanity_check.py

CMD ["python3", "tests/test_harness.py"]
