NF > 1 {
   ord=$2
   if (ord > 90) { ord = ord - 96 } else { ord = ord - 64 + 26 }
   print (ord)
   sum += ord
 }
END {
  print(sum)
}
