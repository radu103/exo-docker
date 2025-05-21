# Dockerfile for Ollama with authentication via Caddy
FROM ubuntu:22.04

# Set the timezone and prevent interactive prompts
ENV TZ=Europe/Bucharest
ENV DEBIAN_FRONTEND=noninteractive

# Update and install all dependencies in a single layer to reduce image size
RUN apt-get update  && apt-get upgrade -y
RUN apt-get install -y --no-install-recommends \
    wget \
    curl \
    bash \
    git \
    libsqlite3-dev \
    software-properties-common \
    tzdata \
    ca-certificates \
    libssl-dev \
    gcc \
    g++ \
    make \
    build-essential \
    libffi-dev \
    zlib1g-dev \
    libncurses5-dev \
    libgdbm-dev \
    libnss3-dev \
    libreadline-dev \
    libgl1-mesa-glx \
    clang \
    llvm \
    llvm-dev \
    libclang-dev

# Set the timezone
RUN ln -fs /usr/share/zoneinfo/"$TZ" /etc/localtime
RUN dpkg-reconfigure --frontend noninteractive tzdata

# Install Python 3.12
RUN curl -sSL https://www.python.org/ftp/python/3.12.0/Python-3.12.0.tgz | tar xz && \
    cd Python-3.12.0 && \
    ./configure --enable-optimizations && \
    make -j $(nproc) && \
    make altinstall && \
    cd .. && \
    rm -rf Python-3.12.0

RUN curl -sS https://bootstrap.pypa.io/get-pip.py | python3.12
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Expose the port that caddy will listen on
EXPOSE 52415

# Set the working directory
WORKDIR /app

# Install exo
WORKDIR /app
RUN git clone https://github.com/exo-explore/exo.git && \
    cd exo && \
    pip install -e . && \
    pip cache purge

# Make sure we have consistent protobuf version to avoid warnings
# Install version 5.27.2 to match generated code and avoid warnings
RUN python3.12 -m pip install protobuf==5.27.2 torch hf_xet llvmlite clang --force-reinstall

# Clean up unnecessary files
RUN apt-get autoremove --purge

# Set the entrypoint to the script
CMD ["exo"]
