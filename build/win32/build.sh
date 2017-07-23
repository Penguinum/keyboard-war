#!/usr/bin/env sh

# Download love-0.10.2-win32.zip if doesn't exist
if [ ! -e "love-0.10.2-win32.zip" ]
then
  wget https://bitbucket.org/rude/love/downloads/love-0.10.2-win32.zip
fi

rm -rf keyboardwars

unzip love-0.10.2-win32.zip
mv love-0.10.2-win32 keyboardwars

cd ../../ && zip -9 -r KeyboardWars.love . -x "build/*" ".gitmodules" ".git/*" "*/.git" "*/.git/*"
cd - && mv ../../KeyboardWars.love .
cat keyboardwars/love.exe KeyboardWars.love > keyboardwars/KeyboardWars.exe
cd keyboardwars && rm love.exe lovec.exe readme.txt changes.txt
cp ../../../README.md .
