BEGIN {
  if (part=="") {
    part=1
  }
  if (lim=="") {
    lim=2000
  }
  m=0
}
{
  nx=patsplit($0,g,/./)
  y=NR
  x=0
  while (x++ < nx) {
    grid[m][y][x][g[x]]=1
    if (g[x] ~ /[Ev<>^]/) {
      grid[m][y][x]["."]=1
    }
  }
}
END {
  goalreached=0
  gy=NR
  gx=nx-1
  pathcnt=1
  path[1][m]["y"]=1
  path[1][m]["x"]=2
  grid[m][1][2]["E"]=1
  printgrid(m)
  while (m++ < lim) {
    calcnext(m)
    checkpaths(m)
    printgrid(m)
    if (goalreached) {
      break
    }
  }
  if (goalreached) {
    if (part==1) {
        exit
    }
  } else {
    printf("Limit of %s minutes reached without reaching the other side of the valley.",lim)
    exit
  }
# part 2
  printf("\n========== Continuing with part 2 ============\n")
  goalreached=0
  cleangrid(m)
  gy=1
  gx=2
  pathcnt=1
  delete path
  path[1][m]["y"]=NR
  path[1][m]["x"]=nx-1
  grid[m][NR][nx-1]["E"]=1
  printgrid(m)
  while (m++ < lim) {
    calcnext(m)
    checkpaths(m)
    printgrid(m)
    if (goalreached) {
      break
    }
  }
  if (!goalreached) {
    printf("Limit of %s minutes reached without reaching the other side of the valley.",lim)
    exit
  }
  goalreached=0
  gy=NR
  gx=nx-1
  pathcnt=1
  delete path
  cleangrid(m)
  path[1][m]["y"]=1
  path[1][m]["x"]=2
  grid[m][1][2]["E"]=1
  printgrid(m)
  while (m++ < lim) {
    calcnext(m)
    checkpaths(m)
    printgrid(m)
    if (goalreached) {
      break
    }
  }
  if (!goalreached) {
    printf("Limit of %s minutes reached without reaching the other side of the valley.",lim)
    exit
  }
}
function cleangrid(m,          y,x,c) {
  y=0
  while (y++ < NR) {
    x=0
    while (x++ < nx) {
      for (c in grid[m][y][x]) {
        if (c=="E") {
          delete grid[m][y][x][c]
        }
      }
    }
  }
}
function checkpaths(m,        i,j) {
  for (i in path) {
    if (path[i]["dead"]) {
      delete grid[m][path[i][m]["y"]][path[i][m]["x"]]["E"]
      continue
    }
    for (j in path) {
      if (path[j]["dead"]) {
        delete grid[m][path[j][m]["y"]][path[j][m]["x"]]["E"]
        continue
      }
      if (i==j) continue;
      if (path[i][m]["x"]==path[j][m]["x"] && path[i][m]["y"]==path[j][m]["y"]) {
        if (int(i) > int(j)) {
          grid[m][path[j][m]["y"]][path[j][m]["x"]]["E"]=j
          path[i]["dead"]=1
        } else {
          grid[m][path[i][m]["y"]][path[i][m]["x"]]["E"]=i
          path[j]["dead"]=1
        }
      }
    }
  }
  for (i in path) {
    if (path[i]["dead"]) {
      delete path[i]
      continue
    }
  }
}
function calcnext(m,       ex,ey,t,x,y,c,nb,p,i,j,pno,cpcnt) {
  cpcnt=0
  for (pno in path) {
    cpcnt++
    t[0][0]=0
    delete t
    ex=path[pno][m-1]["x"]
    ey=path[pno][m-1]["y"]
    printf("Testing path %s(%s,%s) at minute %s (nx=%s,NR=%s) ...\n",pno,ey,ex,m,nx,NR)
    t[ey][ex]=0
    if (ex < nx) t[ey][ex+1]=0;
    if (ex > 1)  t[ey][ex-1]=0;
    if (ey < NR) t[ey+1][ex]=0;
    if (ey > 1)  t[ey-1][ex]=0;
    p=0
    for (y in t) {
      for (x in t[y]) {
        nb=0
        printf("Testing position (y=%s,x=%s) ...\n",y,x)
        for (c in grid[m][y][x]) {
          if (c ~ /[v<>^]/) {
            nb++
          }
        }
        if (nb == 0) {
          if (c == ".") {
            t[y][x]=1
            p++
          }
        }
      }
    }
    if (p==0) {
      printf("Dead on path %s\n",pno)
      path[pno]["dead"]=1
      cpcnt--
    } else if (p == 1) {
      for (y in t) {
        for (x in t[y]) {
          if (t[y][x]==1) {
            path[pno][m]["y"]=int(y)
            path[pno][m]["x"]=int(x)
            grid[m][y][x]["E"]=pno
          }
        }
      }
    } else {
      printf("Multiple directions possible at minute %s for path %s ...\n",m,pno)
      i=0
      for (y in t) {
        for (x in t[y]) {
          if (t[y][x]) {
            if (i==0) {
              j=pno
            } else {
              pathcnt++
              j=pathcnt
              cpcnt++
            }
            i++
            printf("%s(%s,%s)",j,y,x) 
            path[j][m]["x"]=int(x)
            path[j][m]["y"]=int(y)
            grid[m][y][x]["E"]=j
          }
        }
      }
      printf("\n")
    }
  }
  printf("\nCurrent number of active paths: %s\n",cpcnt)
}
function printgrid(m,       y,x,b,c,p,nb) {
  printf("\nGrid at minute %s:\n",m)
  y=0
  curpositions=""
  while (y++ < NR) {
    x=0
    while (x++ < nx) {
      nb=0
      p=""
      for (c in grid[m][y][x]) {
        if (c ~ /[v<>^]/) {
          nb++
          b=c
          if (c=="v") {
            if (y==(NR-1)) {
              newy=2
            } else {
              newy=y+1
            }
            grid[m+1][newy][x][c]=1
          }
          if (c=="^") {
            if (y==2) {
              newy=NR-1
            } else {
              newy=y-1
            }
            grid[m+1][newy][x][c]=1
          }
          if (c==">") {
            if (x==(nx-1)) {
              newx=2
            } else {
              newx=x+1
            }
            grid[m+1][y][newx][c]=1
          }
          if (c=="<") {
            if (x==2) {
              newx=nx-1
            } else {
              newx=x-1
            }
            grid[m+1][y][newx][c]=1
          }
        } else {
          if (c=="E") {
            p="E"
            grid[m+1][y][x]["."]=1
            curpositions=sprintf("%s%s(y=%s,x=%s)",curpositions,grid[m][y][x]["E"],y,x)
            if (y==gy && x==gx) {
              goalreached=grid[m][y][x]["E"]
            }
          } else {
            grid[m+1][y][x][c]=1
          }
        }
      }
      if (nb > 1) {
        p=nb
      } else if (nb==1) {
        p=b
      } else {
        if (p=="") {
          p=c
        }
      }
      printf("%s",p)
    }
    printf("\n")
  }
  printf("Current positions of expedition: %s\n",curpositions)
  if (goalreached) {
    printf("Other side of the valley reached after %s minutes following path %s\n",m,goalreached)
  }
}
