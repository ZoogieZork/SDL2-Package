#!/bin/bash

# build.sh
#   Modify the package info and build new packages for SDL_ttf.
#   Copyright (C) 2013 Michael Imamura.
#
# Licensed under the terms of the MIT License.  See LICENSE.txt.

source "$(dirname "$0")/../functions.sh"

DATADIR="$(dirname "$0")"
PROJECT="${1:-SDL_ttf}"

verify_project "$PROJECT"
prepend_changelog "$PROJECT" "$DATADIR"
apply_patches "$PROJECT" "$DATADIR/depends.patch"
build_source_pkg "$PROJECT"

