#!/bin/bash

DATADIR="$(dirname "$0")"
PROJECT="$1"

if [[ "$PROJECT" == "" ]]; then
	echo "Usage: $0 projectdir"
	exit 1
fi

echo "==> Prepending changelog."
CLTARGET="$PROJECT/debian/changelog"
CLDIST="$CLTARGET.dist"
CLPRE="$DATADIR/changelog-pre.txt"
needscl=1
if [[ -f "$CLDIST" ]]; then
	# Check if the changelog has already been modified.
	lines=$(wc -l "$CLPRE" | cut -d ' ' -f 1)
	targetmd5=$(head -n "$lines" "$CLTARGET" | md5sum | cut -d ' ' -f 1)
	premd5=$(md5sum "$CLPRE" | cut -d ' ' -f 1)
	if [[ "$targetmd5" = "$premd5" ]]; then
		needscl=0
	fi
fi
if [[ $needscl == 1 ]]; then
	echo "--> Updating changelog from $CLPRE"
	cp "$CLTARGET" "$CLDIST"
	cat "$CLPRE" "$CLDIST" > "$CLTARGET"
else
	echo "--> Changelog up-to-date."
fi

exit 1

echo "==> Building package."
( cd "$PROJECT" ; debuild -i -us -uc -b )

