{
  print
  nc = patsplit($0,r,/./)
  for (i in r) m[NR][i]=r[i];
}
END {
# part 2
  printf("\n")
  i=0
  hs=0
  ps=0
  while (i++ < NR) {
    j=0
    while (j++ < nc) {
      printf(m[i][j])
      if (i == 1 || i == NR || j == 1 || j == nc) {
        continue
      }
# to the right
      id=1
      x=j
      s[id]=0
      max=0
      stop=0
      while (x++ < nc) {
        if (m[i][x] > max ) max=m[i][x];
        if (m[i][x] < m[i][j]) {
          #if (m[i][x] >= max) s[id]++;
          s[id]++;
        } else {
          s[id]++
          stop=1
        }
        printf("R%sS%s-",m[i][x],s[id])
        if (stop==1) break;
      }
# to the left
      id++
      s[id]=0
      x=j
      max=0
      stop=0
      while (x-- > 1) {
        if (m[i][x] > max ) max=m[i][x];
        if (m[i][x] < m[i][j]) {
          #if (m[i][x] >= max)
          s[id]++;
        } else {
          s[id]++
          stop=1
        }
        printf("L%sS%s-",m[i][x],s[id])
        if (stop==1) break;
      }
# down
      id++
      s[id]=0
      x=i
      max=0
      stop=0
      while (x++ < NR) {
        if (m[x][j] > max) max=m[x][j];
        if (m[x][j] < m[i][j]) {
          #if (m[x][j] >= max)
          s[id]++;
        } else {
          s[id]++
          stop=1
        }
        printf("D%sS%s-",m[x][j],s[id])
        if (stop==1) break;
      }
# up
      id++
      s[id]=0
      x=i
      max=0
      stop=0
      while (x-- > 1) {
        if (m[x][j] > max) max=m[x][j];
        if (m[x][j] < m[i][j]) {
          #if (m[x][j] >= max) 
          s[id]++;
        } else {
          s[id]++
          stop=1
        }
        printf("U%sS%s-",m[x][j],s[id])
        if (stop==1) break;
      }
# determine the score
      printf(" scores and product of scores and highscore so far: ")
      k=0
      ps=1
      while (k++ < id) {
        ps=ps*s[k]
        printf(s[k] " ")
      }
      if (ps > hs) {
        hs=ps;
      }
      printf("H%s-",m[i][j])
      printf("%s %s\n",ps,hs)
    }
    printf("\n")
  }
}
