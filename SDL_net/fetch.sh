#!/bin/bash

# fetch.sh
#   Download and extract the sources.
#   Copyright (C) 2013 Michael Imamura.
#
# Licensed under the terms of the MIT license.  See LICENSE.txt.

source "$(dirname "$0")/../functions.sh"

fetch_hg 'http://hg.libsdl.org/SDL_net/' SDL_net

