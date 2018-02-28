#!/bin/bash

PKGS="wget"
BUILD=build
VERSION=2.1
DOCROOT="${BUILD}/manual/${VERSION}"

for PKG in ${PKGS}; do
    which ${PKG} 1>/dev/null 2>/dev/null || brew install ${PKG} || exit 1
done

DASHING="$(which dashing 2>/dev/null)"
if [ -z "${DASHING}" ]; then
    DASHING="${HOME}/gopath/bin/dashing"
    if [ ! -s "${DASHING}" ]; then
        go get -u github.com/technosophos/dashing || exit 1
    fi
fi

mkdir -p "${BUILD}"

if [ ! -s "${BUILD}/manual/${VERSION}/index.html" ]; then
    ( cd "${BUILD}" ; wget --recursive --continue --timestamping --no-host-directories --no-parent  --reject-regex ".*\?.*" "http://www.gebish.org/manual/${VERSION}/" )
fi

ROOT="$(pwd)"
cp dashing.json "${DOCROOT}"
( cd "${DOCROOT}" ; "${DASHING}" build geb | tee "${ROOT}/dashing.log" )
