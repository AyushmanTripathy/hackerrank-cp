#!/bin/sh

code="./solution.js"
store="./backup"
cases="./cases"

read_std_input() {
  [ -f $1 ] && rm $1
  while read line; do
    if [ -z "$line" ]
    then
      break
    else
      echo $line >> $1
    fi
  done < /dev/stdin
}

cleanup() {
  kill $nodemon_id
  cp $code $store
  rm $code
  [ -d "$store/$cases" ] && rm -r "$store/$cases"
  mv $cases "$store/$cases"
  echo "bye bye!"
}

get_sample_data() {
  [ -d $cases ] || mkdir $cases
  echo "sample input:"
  read_std_input "$cases/input00.txt"
  echo "sample output:"
  read_std_input "$cases/output00.txt"
}

get_cases() {
  name=$(echo $1 | grep -o -e "challenges/.*/problem" | sed -e "s/challenges\///" -e "s/\/problem//")
  link="https://www.hackerrank.com/rest/contests/master/challenges/$name/download_testcases"
  mkdir -p $cases && cd $cases
  curl $link -O -J -L 
  unzip *.zip
  cd ../
}

[ -d "$store" ] || mkdir "$store"
printf "url> "
read url
[ -z $url ] && get_sample_data || get_cases $url
echo "started"

nodemon -w "./" -w $cases --ignore "$store" -e "js,txt" -x "sh ./code/check.sh || exit 1" &
nodemon_id=$(ps aux | grep -e "nodemon" -m 1 | awk '{ print $2 }')

trap cleanup EXIT

st "nvim" $code
echo "finished"
