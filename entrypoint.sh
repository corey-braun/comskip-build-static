#!/usr/bin/env bash

[ -z "$FFMPEG_VERSION" ] && echo "Required environment variable FFMPEG_VERSION is not set" >&2 && exit 1
[ -z "$COMSKIP_TAR_DL" ] && echo "Required environment variable COMSKIP_TAR_DL is not set" >&2 && exit 1

## Download/extract tar file as needed
dl_extract_tar() { ## Args: <download url> [output file]
    local tar
    if [ -n "$2" ]; then
        tar="$2"
    else
        tar="${1##*/}"
    fi
    if [ -d "${tar%\.tar*}" ] ; then
        return 0
    fi
    if [ ! -f "$tar" ]; then
        curl -sL "$1" -o "$tar"
        [ $? -ne 0 ] && echo "Error downloading $tar from $1" >&2 && exit 1
    fi
    tar xf "$tar" --one-top-level --strip-components 1
    [ $? -ne 0 ] && echo "Error extracting $tar" >&2 && exit 1
}

## Build ffmpeg
ffmpeg="ffmpeg-$FFMPEG_VERSION"
echo "Building ffmpeg version $FFMPEG_VERSION"
dl_extract_tar "https://ffmpeg.org/releases/$ffmpeg.tar.gz"
cd "$ffmpeg"
trap 'echo "Error building ffmpeg" >&2; exit 1' ERR
./configure --prefix=/build/ffmpeg-build --disable-programs
make
make install
trap - ERR
cd ..

## Build comskip
comskip_tar="comskip-${COMSKIP_TAR_DL##*/}"
comskip_dir="${comskip_tar%\.tar*}"
echo "Building comskip from branch '${comskip_dir#comskip-}'"
dl_extract_tar "$COMSKIP_TAR_DL" "$comskip_tar"
cd "$comskip_dir"
trap 'echo "Error building comskip" >&2; exit 1' ERR
./autogen.sh
PKG_CONFIG_PATH=/build/ffmpeg-build/lib/pkgconfig ./configure --bindir=/build/bin --enable-static
make
make install
trap - ERR
