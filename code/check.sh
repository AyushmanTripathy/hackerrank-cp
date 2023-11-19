code="./solution.cpp"
store="./backup"
cases="./cases"
tmp_exec="/tmp/cp.out"

NRM="\x1B[0m"
RED="\x1B[31m"
GRN="\x1B[32m"
YEL="\x1B[33m"

stdout="/tmp/stdout"

error() {
  echo "$RED$1 $NRM"
  [ -f "$stdout" ] && rm $stdout
  exit
}

g++ $code -w -o $tmp_exec || error "Compilation Error"

clear
for i in $(ls "$cases/input")
do
  printf "$YEL[case $(echo $i | sed -e 's/input//' -e 's/\.txt//')] $NRM\n"
  cat "$cases/input/$i" | OUTPUT_PATH="$stdout" $tmp_exec

  output="$cases/output/$(echo $i | sed -e 's/input/output/')"
  if [ -z "$(diff "$stdout" "$output" -Z )" ]; then
    printf "$GRN[case passing] $NRM\n"
  else
    printf "$RED[case failing] $NRM\n"
    echo "Expected output: "
    cat $output
    printf "\nYour output: \n"
  fi
  cat $stdout

  [ -f "$stdout" ] && rm $stdout
done
