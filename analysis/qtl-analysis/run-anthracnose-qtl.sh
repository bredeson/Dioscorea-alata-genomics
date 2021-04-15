#!/bin/bash

set -e

pushd anthracnose

./run-qtl.sh
./plot-effect.sh

popd


