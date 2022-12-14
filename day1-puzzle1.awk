/^[0-9]+$/ { 
  SUM = SUM + $1;
} 
/^$/ { 
  if (SUM > MAX) {
    MAX=SUM;
  }; 
  SUM = 0;
}
END { 
  print("Max " MAX);
}
