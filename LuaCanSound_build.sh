#!/bin/sh

OUTFILE=LuaCanSound.lua

cd LuaCanSound
MODULES="$(ls -1 | grep "\.lua" | sed -e 's/\..*$//')"
#echo $MODULES
AMALGED="$(amalg.lua $MODULES)"
cd ..

echo "$AMALGED" | sed -e 's/\"init\"/\"LuaCanSound_init\"/g' > $OUTFILE
echo "return require 'LuaCanSound_init'" >> $OUTFILE
