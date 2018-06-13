#~/bin/bash

echo "deploying homepage"

source ../config.sh

# copy

rm -rf dist/
mkdir dist
mkdir dist/static
cp index.html dist/

legalFormats=".jpg .css"
for format in $legalFormats
do  
    cp -r static/*$format dist/static/
done

# compress jpgs

cache="cache.jpg"

all_jpgs=$(find dist/static/*.jpg)
for img in $all_jpgs
do {
    echo "compressing $img"
    rm -f $cache
    guetzli --quality 90 $img $cache
    mv -f $cache $img
} &
done
wait

# deploy to remote

DEST="~/home/"

echo "deploying to $DEST at $USER@$URL"

rsync -r dist/* $USER@$URL:$DEST
