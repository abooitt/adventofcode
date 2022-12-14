BEGIN {
  yh=0
  xh=0
  minx=0
  maxx=0
  miny=0
  maxy=0
  rl=9
  i=0
  while (i++ < rl) {
    xt[i]=0
    yt[i]=0
  }
  print(NR,xh,yh,minx,maxx,miny,maxy,xt[rl],yt[rl])
}
/^U/ { 
  i=0
  while (i++ < $2) {
    yh++
    j=0
    while (j++ < rl) {
      if (j==1) {
        if (yt[j] < yh-1) {
          yt[j]++
          if (xt[j] < xh) xt[j]++;
          if (xt[j] > xh) xt[j]--;
        }
      } else {
        if (yt[j] < yt[j-1]-1) {
          yt[j]++
          if (xt[j] < xt[j-1]) xt[j]++;
          if (xt[j] > xt[j-1]) xt[j]--;
        }
        if (xt[j] > xt[j-1]+1) {
          xt[j]--
          if (yt[j] < yt[j-1]) yt[j]++;
          if (yt[j] > yt[j-1]) yt[j]--;
        }
        if (xt[j] < xt[j-1]-1) {
          xt[j]++
          if (yt[j] < yt[j-1]) yt[j]++;
          if (yt[j] > yt[j-1]) yt[j]--;
        }
      }
    }
    post[xt[rl]][yt[rl]]=1
  }
}
/^L/ { 
  i=0
  while (i++ < $2) {
    xh--
    j=0
    while (j++ < rl) {
      if (j==1) {
        if (xt[j] > xh+1) {
          xt[j]--
          if (yt[j] < yh) yt[j]++;
          if (yt[j] > yh) yt[j]--;
        }
      } else {
        if (xt[j] > xt[j-1]+1) {
          xt[j]--
          if (yt[j] < yt[j-1]) yt[j]++;
          if (yt[j] > yt[j-1]) yt[j]--;
        }
        if (yt[j] < yt[j-1]-1) {
          yt[j]++
          if (xt[j] < xt[j-1]) xt[j]++;
          if (xt[j] > xt[j-1]) xt[j]--;
        }
        if (yt[j] > yt[j-1]+1) {
          yt[j]--
          if (xt[j] < xt[j-1]) xt[j]++;
          if (xt[j] > xt[j-1]) xt[j]--;
        }
      }
    }
    post[xt[rl]][yt[rl]]=1
  }
}
/^D/ { 
  i=0
  while (i++ < $2) {
    yh--
    j=0
    while (j++ < rl) {
      if (j==1) {
        if (yt[j] > yh+1) {
          yt[j]--
          if (xt[j] < xh) xt[j]++;
          if (xt[j] > xh) xt[j]--;
        }
      } else {
        if (yt[j] > yt[j-1]+1) {
          yt[j]--
          if (xt[j] < xt[j-1]) xt[j]++;
          if (xt[j] > xt[j-1]) xt[j]--;
        }
        if (xt[j] > xt[j-1]+1) {
          xt[j]--
          if (yt[j] < yt[j-1]) yt[j]++;
          if (yt[j] > yt[j-1]) yt[j]--;
        }
        if (xt[j] < xt[j-1]-1) {
          xt[j]++
          if (yt[j] < yt[j-1]) yt[j]++;
          if (yt[j] > yt[j-1]) yt[j]--;
        }
      }
    }
    post[xt[rl]][yt[rl]]=1
  }
}
/^R/ { 
  i=0
  while (i++ < $2) {
    xh++
    j=0
    while (j++ < rl) {
      if (j==1) {
        if (xt[j] < xh-1) {
          xt[j]++
          if (yt[j] < yh) yt[j]++;
          if (yt[j] > yh) yt[j]--;
        }
      } else {
        if (xt[j] < xt[j-1]-1) {
          xt[j]++
          if (yt[j] < yt[j-1]) yt[j]++;
          if (yt[j] > yt[j-1]) yt[j]--;
        }
        if (yt[j] < yt[j-1]-1) {
          yt[j]++
          if (xt[j] < xt[j-1]) xt[j]++;
          if (xt[j] > xt[j-1]) xt[j]--;
        }
        if (yt[j] > yt[j-1]+1) {
          yt[j]--
          if (xt[j] < xt[j-1]) xt[j]++;
          if (xt[j] > xt[j-1]) xt[j]--;
        }
      }
    }
    post[xt[rl]][yt[rl]]=1
  }
}
{
  print
  if (xh < minx) minx=xh;
  if (xh > maxx) maxx=xh;
  if (yh < miny) miny=yh;
  if (yh > maxy) maxy=yh;
  c=0
  for (x in post) {
    for (y in post[x]) {
      c++
    }
  }
  print(NR,xh,yh,minx,maxx,miny,maxy,xt[rl],yt[rl],c)
}
END {
  exit
  y=miny
  while (y <= maxy) {
    x=minx
    while (x <= maxx) {
      printf(".")
      x++
    }
    printf("\n")
    y++
  }
}
