# Use the official Ubuntu image as a base
FROM ubuntu:20.04

# Set non-interactive mode for APT
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt-get update && apt-get install -y \
    git \
    cmake \
    g++ \
    lcov \
    libgtest-dev \
    wget \
    curl \
    python3 \
    python3-pip \
    && apt-get clean

# Install CMake if needed
RUN wget https://github.com/Kitware/CMake/releases/download/v3.22.2/cmake-3.22.2-linux-x86_64.sh -O /tmp/cmake.sh \
    && chmod +x /tmp/cmake.sh \
    && /tmp/cmake.sh --skip-license --prefix=/usr/local \
    && rm /tmp/cmake.sh

# Install conan
RUN pip3 install conan

# Install yaml-cpp
RUN git clone https://github.com/jbeder/yaml-cpp && cd yaml-cpp && mkdir build && cd build && cmake -DYAML_BUILD_SHARED_LIBS=ON .. && make -j8 all install

# Install tinyxml2
RUN git clone https://github.com/leethomason/tinyxml2 && cd tinyxml2 && mkdir build && cd build && cmake .. && make -j8 all install

# Install Google Benchmark
RUN git clone https://github.com/google/benchmark && cd benchmark && mkdir build && cd build && cmake -DBENCHMARK_DOWNLOAD_DEPENDENCIES=ON .. && make -j8 all install

# Install Google Test
RUN git clone https://github.com/google/googletest && cd googletest && mkdir build && cd build && cmake .. && make -j8 all install

# Copy the project files
COPY . /app

# Set working directory
WORKDIR /app

# Build the project
RUN mkdir build && cd build && cmake -DENABLE_TESTING=ON -DENABLE_COVERAGE=ON -DCMAKE_BUILD_TYPE=Debug .. && cmake --build . --target coverage

# Set the entrypoint to run tests
CMD ["ctest", "-V"]
