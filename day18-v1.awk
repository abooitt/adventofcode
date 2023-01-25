BEGIN {
  total=0
}
{
  numc=split($0,a,/,/)
  i=0
  while (i++ < numc) {
    cube[NR][i]=int(a[i])
  }
  total+=6
  type[a[1],a[2],a[3]]="lava"
  i=0
  while (i++ < numc)
  k=0
  while (k++ < NR-1) {
    i=0
    while (i++ < numc) {
      j=0
      while (j++ < numc) {
        if (j==1) {
          c[j]=(i-1)%numc+1
        } else {
          c[j]=c[j-1]%numc+1
        }
      }
      diff=cube[NR][c[numc]]-cube[k][c[numc]]
      if (diff < 0) {
        diff=-diff
      }
      if (diff==1) {
        dec=0
        j=0
        while (j++ < numc-1) {
          if (cube[NR][c[j]]==cube[k][c[j]]) {
            dec++
          }
        }
        if (dec==numc-1) {
          total-=2
        }
      }
    }
  }
}
END {
  print(total)
}
