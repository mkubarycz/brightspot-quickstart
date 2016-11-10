#!/bin/bash

set -e

mkdir -p build
docker build -t bs-build .
docker run -ti -v $(pwd)/build:/src/build bs-build
