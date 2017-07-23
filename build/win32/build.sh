#!/usr/bin/env sh

# Download love-0.10.2-win32.zip if doesn't exist
if [ ! -e "love-0.10.2-win32.zip" ]
then
  wget https://bitbucket.org/rude/love/downloads/love-0.10.2-win32.zip
fi

if [ ! -e "keyboardwars" ]
then
  unzip love-0.10.2-win32.zip
  mv love-0.10.2-win32 keyboardwars
fi

cd ../../ && zip -9 -r KeyboardWars.love . -x "build/*" ".git/*" "*/.git" "*/.git/*"
cd - && mv ../../KeyboardWars.love .
cat keyboardwars/love.exe KeyboardWars.love > keyboardwars/KeyboardWars.exe
