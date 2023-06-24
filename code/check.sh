code="./solution.js"
store="./backup"
cases="./cases"

NRM="\x1B[0m"
RED="\x1B[31m"
GRN="\x1B[32m"
YEL="\x1B[33m"

stdout="/tmp/stdout"
consoleout="/tmp/consoleout"

clear
for i in $(ls "$cases/input")
do
  cat "$cases/input/$i" | OUTPUT_PATH="$stdout" node $code > $consoleout
  printf "$YEL[case $(echo $i | sed -e 's/input//' -e 's/\.txt//')] $NRM\n"

  cat $consoleout
  output="$cases/output/$(echo $i | sed -e 's/input/output/')"
  if [ -z "$(diff "$stdout" "$output" -Z )" ]; then
    printf "$GRN[case passing] $NRM"
    [ -z "$(cat $consoleout)" ] || printf "$YEL[console]$NRM"
    printf "\n"
  else
    printf "$RED[case failing] $NRM\n"
    echo "Expected output: "
    cat $output
    printf "\nYour output: \n"
  fi
  cat $stdout

  [ -f "$stdout" ] && rm $stdout
  [ -f "$consoleout" ] && rm $consoleout
done
