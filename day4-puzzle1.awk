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
   if ( (lb >= rb && le <= re) || (rb >= lb && re <= le) ) {
     print(NR,l,r)
     sum+=1
   }
 }
END {
  print(NR,sum)
}
