#!/bin/bash

# fetch.sh
#   Download and extract the source archive.
#   Copyright (C) 2013 Michael Imamura.
#
# Licensed under the terms of the MIT license.  See LICENSE.txt.

TARGETFILE='SDL-2.0.tar.gz'
URL='http://www.libsdl.org/tmp/SDL-2.0.tar.gz'

echo "==> Downloading"
wget -O "$TARGETFILE" "$URL" || exit 1

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

