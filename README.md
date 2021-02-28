# PB_history
My personal best results

# 目的
* モチベ向上
* 得意種目と苦手種目の把握

# 記録のルール
* DNFによるPB Failのタイムの更新は、ミスにより分析記憶実行を不当にスキップしていない場合に限る
* 開眼練習のタイムを計測する際は、レターペアを想起するようにする
  * 分析→レターペア想起→実行という動作の流れを練習するため
* 累計ソルブ時間は、1日の終わりに計算する
  * 日中の好きなタイミングでイイトコ取りするのを許すと、頻繁にタイムを確認したくなり集中できなくなる可能性があるため

# 便利コマンド
* 特定の種目の更新履歴を得る
  * `git log -p -G '5BLD \(DNF\),'`
    * 正規表現なので、カッコはエスケープする必要がある
  * `git log -p -G 'Wのみソルブ,' results/4BLD.csv`
    * Wのみソルブは複数のファイルに存在するが、特定のファイルだけを指定して検索可能
