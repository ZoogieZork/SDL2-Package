#!/bin/bash

# fetch.sh
#   Download and extract the source archive.
#   Copyright (C) 2013 Michael Imamura.
#
# Licensed under the terms of the MIT license.  See LICENSE.txt.

TARGETFILE='SDL-2.0.tar.gz'
INDEX_URL='http://www.libsdl.org/hg.php'
DL_PREFIX='http://www.libsdl.org/tmp/'

echo '==> Looking up latest snapshot'
srcfile="$( curl "$INDEX_URL" | \
	grep 'SDL 2[.]0 TGZ' | \
	grep -o 'SDL-2[.]0[.]1-[0-9]*[.]tar[.]gz' | \
	head -n 1 )"
if [[ "$srcfile" = '' ]]; then
	echo 'Unable to determine latest snapshot URL.' >&2
	exit 1
fi
url="$DL_PREFIX$srcfile"

echo "==> Downloading"
wget -O "$TARGETFILE" "$url" || exit 1

PROJECTDIR="$(tar tzf "$TARGETFILE" | head -1 | cut -d '/' -f 1)"
if [[ "$PROJECTDIR" = '' ]]; then
	echo "Could not determine extract directory." >&2
	exit 1
fi

echo "==> Extracting pristine copy: $PROJECTDIR.orig"
rm -rf "$PROJECTDIR" "$PROJECTDIR.orig"
tar xzf "$TARGETFILE" || exit 1
mv "$PROJECTDIR" "$PROJECTDIR.orig" || exit 1

echo "==> Extracting project copy: $PROJECTDIR"
tar xzf "$TARGETFILE" || exit 1

