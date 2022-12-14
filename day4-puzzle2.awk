BEGIN {
  FS=","
}
 {
   l = $1
   r = $2
   n = split(l,a,/-/)
   lb = a[1]
   le = a[2]
   n = split(r,a,/-/)
   rb = a[1]
   re = a[2]
   #print(l,lb,le,r,rb,re)
   if ( (le >= rb && lb <= rb) || (re >= lb && rb <= lb) ) {
     sum+=1
   }
   print(NR,l,r,sum)
 }
END {
  print(NR,sum)
}
