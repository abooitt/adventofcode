 { 
   l=length()
   c1=substr($0,1,l/2)
   c2=substr($0,1+l/2)
   i=1
   dups=""
   while (i <= l/2) {
     c=substr(c1,i,1)
     p=index(c2,c)
     #print(c,p)
     if (p>0 && index(dups,c)==0) dups = dups c
     i++
   }

   #print(NR,$0,l,c1,c2,dups)
   print(dups)
 }
