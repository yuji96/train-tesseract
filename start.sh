#!/bin/bash

# tail -f /dev/null

# TODO: とりあえず今は直で指定
MODEL_NAME=sample

cd /app/src
if [ ! -d tesstrain ]; then
  # TODO: change to zip
  git clone --depth=1 https://github.com/tesseract-ocr/tesstrain.git
fi
cd tesstrain

# TODO: use symlink, remove previous ground-truth
rm -rf /app/src/tesstrain/data/$MODEL_NAME-ground-truth/
mkdir -p /app/src/tesstrain/data/$MODEL_NAME-ground-truth
cp -s /app/data/ground-truth/* \
      /app/src/tesstrain/data/$MODEL_NAME-ground-truth/

echo $(cat /app/args.txt | sed "s/#.*//" | xargs)

# FIXME
ln -s /usr/local/share/tessdata/eng_best.traineddata /usr/local/share/tessdata/eng.traineddata

# TODO: use DATA_DIR
if [ ! -d data/langdata ]; then
  make tesseract-langdata
fi

cat /app/args.txt | sed "s/#.*//" | xargs make training
