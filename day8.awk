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
# part 2
  i=0
  hs=0
  while (i++ < NR) {
    j=0
    while (j++ < nc) {
      printf(m[i][j])
      if (i == 1 || i == NR || j == 1 || j == nc) {
        continue
      }
# from left to right
      id=1
      x=j
      s[id]=0
      max=0
      while (x++ < nc) {
        if (m[i][x] > max ) max=m[i][x];
        if (m[i][x] < m[i][j]) {
          if (m[i][x] >= max && m[i][j] > max) s[id]++;
          continue
        } else {
          s[id]++
          break
        }
      }
# from right to left
      id++
      s[id]=0
      x=nc+1
      max=0
      while (x-- > j+1) {
        if (m[i][x] > max) max=m[i][x];
        if (m[i][x] < m[i][j]) {
          if (m[i][x] >= max && m[i][j] > max) s[id]++;
          continue
        } else {
          s[id]++
          break
        }
      }
# from top to bottom
      id++
      s[id]=0
      x=0
      max=0
      while (x++ < i-1) {
        if (m[x][j] > max) max=m[x][j];
        if (m[x][j] < m[i][j]) {
          if (m[x][j] >= max && m[i][j] > max) s[id]++;
          continue
        } else {
          s[id]++
          break
        }
      }
# from bottom to top
      id++
      s[id]=0
      x=NR+1
      max=0
      while (x-- > i+1) {
        if (m[x][j] > max) max=m[x][j];
        if (m[x][j] < m[i][j]) {
          if (m[x][j] >= max && m[i][j] > max) s[id]++;
          continue
        } else {
          s[id]++
          break
        }
      }
      printf(" scores and product of scores and highscore so far: ")
      k=0
      ps=1
      while (k++ < id) {
        ps=ps*s[id]
        printf(s[id] " ")
      }
      if (ps > hs) hs=ps;
      printf("%s %s\n",ps,hs)
    }
  }
}
