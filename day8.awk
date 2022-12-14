{
  nc = patsplit($0,r,/./)
  for (i in r) m[NR][i]=r[i];
}
END {
# part 1
  i=0
  v=0
  while (i++ < NR) {
    j=0
    while (j++ < nc) {
      printf(m[i][j])
      if (i == 1 || i == NR || j == 1 || j == nc) {
        v++ 
        continue
      }
# from left to right
      x=0
      max=0
      while (x++ < j-1) {
        if (m[i][x] > max) max=m[i][x];
      }
      printf("lr(" max ")")
      if (m[i][j] > max) { v++; continue; };
# from right to left
      x=nc+1
      max=0
      while (x-- > j+1) {
        if (m[i][x] > max) max=m[i][x];
      }
      printf("rl(" max ")")
      if (m[i][j] > max) { v++; continue; };
# from top to bottom
      x=0
      max=0
      while (x++ < i-1) {
        if (m[x][j] > max) max=m[x][j];
      }
      printf("tb(" max ")")
      if (m[i][j] > max) { v++; continue; };
# from bottom to top
      x=NR+1
      max=0
      while (x-- > i+1) {
        if (m[x][j] > max) max=m[x][j];
      }
      printf("bt(" max ")")
      if (m[i][j] > max) { v++; continue; };
    }
    printf(" visible so far: %s\n",v)
  }
  printf("\n")
}
