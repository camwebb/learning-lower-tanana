BEGIN{
  inputs = "lt1a|lt1b|lt2a|lt2b"
  split(inputs,input,"|")
  for (i in input)
    while ((getline < ("../media/" input[i] ".lab.txt")) > 0) {
      if (++w[$3]>1)
        print "Error: label " $3 " in file ../media/" input[i] ".lab.txt" \
          " is a duplicate" > "/dev/stderr"
      t["\\{" $3 "\\}"] =                                  \
        "<a href=\"javascript:playSeg('" input[i] "'," sprintf("%.2f", $1) \
        "," sprintf("%.2f", $2) ");\">"                                 \
        "<img src=\"img/" substr(input[i],1,3) ".png\" height=\"15\"/></a>"
    }
}

{
  for (i in t)
    gsub(i,t[i],$0)
  print $0
}
