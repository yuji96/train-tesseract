1. `MODEL_NAME` を適当に決める。
2. データセットを `data/MODEL_NAME/ground-truth` に置く。
3. args.txt を設定する。
4. (今だけ) `start.sh` 内の `MODEL_NAME` を変更する。

訓練
```
docker compose up
```

> ログの読み方: 
https://tesseract-ocr.github.io/tessdoc/tess4/TrainingTesseract-4.00.html#iterations-and-checkpoints

評価
```
docker compose run --rm app bash -c \
  "
    cd src/tesstrain && \
    lstmeval --model data/sample/checkpoints/sample_17.095000_61_70.checkpoint \
      --traineddata /usr/local/share/tessdata/eng_best.traineddata \
      --eval_listfile data/sample/list.eval
  "
```

モデル作成
```
docker compose run --rm app bash -c \
  "
    cd src/tesstrain && \
    make traineddata CHECKPOINT_FILES=data/sample/checkpoints/sample_17.095000_61_70.checkpoint MODEL_NAME=sample
  "
```
