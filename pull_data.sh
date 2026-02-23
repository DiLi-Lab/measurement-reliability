#!/bin/bash

curl -L --fail -C - -o data_results.zip \
  --retry 20 --retry-delay 5 --retry-all-errors \
  "https://drive.switch.ch/index.php/s/faxvHpFurfjKSfo/download"

unzip data_results
rm data_results.zip
