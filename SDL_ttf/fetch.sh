#!/bin/bash

# fetch.sh
#   Download and extract the sources.
#   Copyright (C) 2013 Michael Imamura.
#
# Licensed under the terms of the MIT license.  See LICENSE.txt.

PROJECTDIR='SDL_ttf'
URL='http://hg.libsdl.org/SDL_ttf'

if [[ -d "$PROJECTDIR.orig" ]]; then
	echo "==> Updating pristine snapshot: $PROJECTDIR.orig"
	( cd "$PROJECTDIR.orig" ; hg pull ) || exit 1
else
	echo "==> Cloning pristine snapshot: $PROJECTDIR.orig"
	hg clone "$URL" "$PROJECTDIR.orig" || exit 1
fi

echo "==> Creating project copy: $PROJECTDIR"
rm -rf "$PROJECTDIR"
cp -r "$PROJECTDIR.orig" "$PROJECTDIR" || exit 1

