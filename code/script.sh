#!/bin/sh

code="./solution.cpp"
store="./backup"
cases="./cases"
notes="./notes"
name=""

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
  echo "Exiting... "
  kill $nodemon_id
  read null
  printf "document the question? [$name]> "
  read ansa
  
  if [ "$ansa" = "y" ]
  then
    fileName="$notes/$name.md"
    echo "# $name" > "$fileName"
    nvim "$fileName"
  fi
  
  printf "solved the question? [$name]> "
  read ansb
  if [ "$ansb" = "y" ]
  then
    echo "$(date '+%d/%m/%g %H:%M') $name" >> "./list.txt"
  fi

  cp $code $store
  rm $code
  [ -d "$store/$cases" ] && rm -r "$store/$cases"
  mv $cases "$store/$cases"
  echo "bye bye!"
}

get_sample_data() {
  [ -d $cases ] || mkdir $cases
  [ -d "$cases/input" ] || mkdir "$cases/input"
  [ -d "$cases/output" ] || mkdir "$cases/output"

  echo "sample input:"
  read_std_input "$cases/input/inputXX.txt"
  echo "sample output:"
  read_std_input "$cases/output/outputXX.txt"
}

get_cases() {
  name=$(echo $1 | grep -o -e "challenges/.*/problem" | sed -e "s/challenges\///" -e "s/\/problem//")
  link="https://www.hackerrank.com/rest/contests/master/challenges/$name/download_testcases"
  mkdir -p $cases && cd $cases
  curl $link -O -J -L 
  unzip *.zip
  cd ../
}


while getopts "a" flag
do
    case "${flag}" in
        a) get_sample_data && exit;;
    esac
done

[ -d "$store" ] || mkdir "$store"
printf "url> "
read url
[ -z $url ] && get_sample_data || get_cases $url
echo "started"

nodemon -w "./" -w $cases --ignore "$store" -e "cpp,js,txt" -x "sh ./code/check.sh || exit 1" &
nodemon_id=$(ps aux | grep -e "nodemon" -m 1 | awk '{ print $2 }')

trap cleanup EXIT

st "nvim" $code
