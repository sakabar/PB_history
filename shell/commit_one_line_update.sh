#!/bin/bash

set -ue

# 変更が1行だけか確認する
ll=$(git diff --numstat HEAD | wc -l | awk '{print $1}' | tr -d '\n')
insertion=$(git diff --numstat HEAD | awk '{print $1}' | tr -d '\n')
deletion=$(git diff --numstat HEAD | awk '{print $2}' | tr -d '\n')

if [[ $ll -ne 1 ]] || [[ $insertion -ne 1 ]] || [[ $deletion -ne 1 ]]; then
   echo "Error: ${ll} file changed, ${insertion} insertion, ${deletion} deletion" >&2
   exit 1
fi

# diffから、4BLD (FU/UFR) 5:09.37=[2:24]+2:45のような文字列を生成する
# 変更した行の情報によっては変なメッセージになるが、
# その場合はコミット後に手で直してgit commit --amendする想定
msg=$(git diff --unified=0 HEAD | grep -v '+++' | grep '^+' | sed -e 's/^+//' | awk -F, '{print $1" "$3"=["$4"]+"$5}')

# git commit時にメッセージが出るので、ここでは出さない
# echo $msg

git add -u
git commit -m "${msg}"
