#!/bin/bash

set -e

pushd tuber-traits

./run-qtl.sh
./plot-effect.sh

popd
