#!/bin/zsh

set -ue

# 変更が1行だけか確認する
ll=$(git diff --numstat HEAD | wc -l | awk '{print $1}' | tr -d '\n')
insertion=$(git diff --numstat HEAD | awk '{ s += $1 } END{print s}' | tr -d '\n')
deletion=$(git diff --numstat HEAD | awk '{ s += $2 } END{print s}' | tr -d '\n')

if [[ $ll -ne 1 ]] || [[ $insertion -ne 1 ]] || [[ $deletion -ne 1 ]]; then
   echo "Error: ${ll} file changed, ${insertion} insertion, ${deletion} deletion" >&2
   exit 1
fi

# diffから、4BLD (FU/UFR) 5:09.37=[2:24]+2:45のような文字列を生成する
# 変更した行の情報によっては変なメッセージになるが、
# その場合はコミット後に手で直してgit commit --amendする想定
diff_line=$(git diff --unified=0 HEAD | grep -v '^+++' | grep '^+' | sed -e 's/^+//')
event_col=$(echo $diff_line | cut -d ',' -f1)
diff_file_path=$(git diff --unified=0 HEAD | grep '^+++' | cut -d ' ' -f2)
diff_file_name=${diff_file_path:t:r}

msg=""
if [[ $(echo $event_col | grep -c 'のみソルブ') -eq 1 ]]; then
    event_en=$(echo $event_col | awk -F 'のみソルブ' '
        $1 == "E" {printf("edge")}
        $1 == "C" {printf("corner")}
        $1 == "T" {printf("t-center")}
        $1 == "X" {printf("x-center")}
        $1 == "W" {printf("w-edge")}
        $1 == "MC" {printf("MC")}')

    result=$(echo $diff_line | awk -F, '{print $3"=["$4"]+"$5}')
    msg="${diff_file_name} ${event_en} only ${result}"
else
    msg=$(git diff --unified=0 HEAD | grep -v '+++' | grep '^+' | sed -e 's/^+//' | awk -F, '{print $1" "$3"=["$4"]+"$5}' | sed -e 's/=\[\]+//')
fi


# git commit時にメッセージが出るので、ここでは出さない
# echo $msg

git add -u
git commit -m "${msg}"
