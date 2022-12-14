 { 
   seq = NR % 3
   print(NR,$0,seq)
   if (seq == 1) {
     line1=$0
   }
   if (seq == 2) {
     line2=$0
   }
   if (seq == 0) {
     g++
     line3=$0
     l1=length(line1)
     i=1
     while (i <= l1) {
       t=substr(line1,i,1)
       p2=index(line2,t)
       p3=index(line3,t)
       print(g,t,i,p2,p3)
       i++
     }
   }
 }
