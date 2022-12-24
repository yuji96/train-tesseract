#!/bin/bash
set -v

# TODO: とりあえず今は直で指定
MODEL_NAME=sample

cd /app/src
if [ ! -d tesstrain ]; then
  # TODO: change to zip
  git clone --depth=1 https://github.com/tesseract-ocr/tesstrain.git
fi
cd tesstrain

# 経由しない
# rm -rf /app/src/tesstrain/data/$MODEL_NAME-ground-truth/
# mv /app/data/$MODEL_NAME/ground-truth/ \
#     /app/src/tesstrain/data/$MODEL_NAME-ground-truth

echo $(cat /app/args.txt | sed "s/#.*//" | xargs)

# FIXME
ln -s /usr/local/share/tessdata/eng_best.traineddata /usr/local/share/tessdata/eng.traineddata

# TODO: use DATA_DIR
if [ ! -d data/langdata ]; then
  make tesseract-langdata
fi

# いまだけ
rm /app/src/tesstrain/data/$MODEL_NAME/all-lstmf 

# TODO: don't overwrite
cat /app/args.txt | sed "s/#.*//" | xargs make training 2>&1 | tee /app/$MODEL_NAME.txt
