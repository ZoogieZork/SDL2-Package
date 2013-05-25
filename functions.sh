#!/bin/bash

# functions.sh
#   Common bits used in SDL2 package build scripts.
#   Copyright (C) 2013 Michael Imamura.
#
# Licensed under the terms of the MIT License.  See LICENSE.txt.

function list_releases {
	echo 'raring'
}

function fetch_hg {
	URL="$1"
	PROJECT="$2"

	if [[ -d "$PROJECT.orig" ]]; then
		echo "==> Updating pristine snapshot: $PROJECT.orig"
		( cd "$PROJECT.orig" ; hg pull -u ) || exit 1
	else
		echo "==> Cloning pristine snapshot: $PROJECT.orig"
		hg clone "$URL" "$PROJECT.orig" || exit 1
	fi

	echo "==> Creating project copy: $PROJECT"
	rm -rf "$PROJECT"
	cp -r "$PROJECT.orig" "$PROJECT" || exit 1
}

function verify_project {
	PROJECT="$1"

	if [[ "$PROJECT" == "" ]]; then
		echo "Usage: $0 projectdir" >&2
		exit 1
	fi
	if [[ ! -d "$PROJECT" ]]; then
		echo "Project is not a directory: $PROJECT" >&2
		exit 1
	fi
}

function _gen_changelog {
	CLPRE="$1"
	RELEASE="$2"

	sed -e "s/@RELEASE@/$RELEASE/g" "$CLPRE"
}

function prepend_changelog {
	PROJECT="$1"
	DATADIR="$2"
	RELEASE="$3"
	
	echo "==> Prepending changelog."
	CLTARGET="$PROJECT/debian/changelog"
	CLDIST="$CLTARGET.dist"
	CLPRE="$DATADIR/changelog-pre.txt"
	needscl=1
	if [[ -f "$CLDIST" ]]; then
		# Check if the changelog has already been modified.
		lines=$(wc -l "$CLPRE" | cut -d ' ' -f 1)
		targetmd5=$(head -n "$lines" "$CLTARGET" | md5sum | cut -d ' ' -f 1)
		premd5=$(_gen_changelog "$CLPRE" "$RELEASE" | md5sum | cut -d ' ' -f 1)
		if [[ "$targetmd5" = "$premd5" ]]; then
			needscl=0
		fi
	fi
	if [[ $needscl == 1 ]]; then
		echo "--> Updating changelog from $CLPRE"
		cp "$CLTARGET" "$CLDIST"
		_gen_changelog "$CLPRE" "$RELEASE" > "$CLTARGET"
		cat "$CLDIST" >> "$CLTARGET"
	else
		echo "--> Changelog up-to-date."
	fi
}

function _apply_patch {
	PROJECT="$1"
	PATCHFILE="$2"

	echo "--> $PATCHFILE"
	( cd "$PROJECT" ; patch -tN -p1 ) < "$PATCHFILE"
}

function apply_patches {
	PROJECT="$1"
	shift

	echo "==> Applying patches."
	for patchfile in "$@"; do
		_apply_patch "$PROJECT" "$patchfile"
	done
}

function build_source_pkg {
	PROJECT="$1"

	echo "==> Building source package."
	( cd "$PROJECT" ; debuild -i -S )
}

function clean_pkgs {
	PROJECT="$1"
	PKGBASE="$PROJECT/../libsdl2"

	echo "==> Removing previously-built packages."
	rm -f \
		"$PKGBASE"*.build \
		"$PKGBASE"*.changes \
		"$PKGBASE"*.deb \
		"$PKGBASE"*.dsc \
		"$PKGBASE"*.tar.gz \
		"$PKGBASE"*.upload
}

function clean_project {
	PROJECT="$1"

	rm -rf "$PROJECT"
	cp -r "$PROJECT.orig" "$PROJECT"
}

