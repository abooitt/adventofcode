BEGIN { MAX=0; MAX1=0; MAX2=0; prevMax = 0; prevMax1=0; }
/^[0-9]+$/ { SUM = SUM + $1;} 
/^$/ { 
  print(SUM);
  if (SUM > MAX) { 
    MAX2=MAX1
    MAX1=MAX
    MAX=SUM; 
  } else {
    if (NR>1 && SUM > MAX1) {
      MAX2=MAX1
      MAX1=SUM;
    } else {
      if (NR>2 && SUM > MAX2) {
        MAX2=SUM;
      };
    }
  }
#    if (prevMax >= MAX1) { 
#      prevMax1=MAX1; 
#      MAX1=prevMax; 
#      if (prevMax1 >= MAX2) { 
#        MAX2 = prevMax1; 
#      }; 
#    }; 
  SUM = 0; } 
END { 
  print("Max " MAX); 
  print("Max1 " MAX1); 
  print("Max2 " MAX2);
  print("Total " MAX+MAX1+MAX2);
}
