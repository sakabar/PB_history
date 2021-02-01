#!/bin/bash
set -ue

# エクセルのためにShift-JISにしていたのをUTF-8 (LF) に戻す
nkf --overwrite -Lu -w results/*.csv

# エクセルで2021/01/01のような日付が2021/1/1に置換されているので、2桁に戻す
sed -i.bak 's|/\([1-9][,/]\)|/0\1|g' results/*.csv

nkf --guess results/*.csv
