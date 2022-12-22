BEGIN {
  if (part != 1 && part != 2) {
    part=1
  }
  if (part==1) {
    if (row=="") {
      row=10
    }
  }
}
{
  sno=NR
  na = split($0,a,/: /)
  for (i in a) {
    #printf("%s: ", i)
    nb = patsplit(a[i],b,/[xy]=-?[0-9]+/)
    for (j in b) {
      #printf("%s ",b[j])
      nc = split(b[j],c,/=/)
      if (i == 1) {
        sensor[sno][c[1]]=c[2]
      }
      if (i == 2) {
        beacon[sno][c[1]]=c[2]
      }
    }
    #printf(" - ")
  }
  #printf("\n")
}
END {
  #covgrid[1][1]=""
  #delete covgrid[1][1]
  for (sno in sensor) {
    sx = sensor[sno]["x"]
    sy = sensor[sno]["y"]
    bx = beacon[sno]["x"]
    by = beacon[sno]["y"]
    sensorgrid[sx][sy]=1
    beacongrid[bx][by]=1
    printf("%s: %s, %s : ",sno,sx,sy)
    d = distance(sx,sy,bx,by)
    sensor[sno]["reach"] = d
    coverage[sno] = get_coverage(sx,sy,d,row)
    printf("%s, %s : %s : %s : %s\n",bx,by,d,row,coverage[sno])
    #fill_coverage_grid(sensor[sno]["x"],sensor[sno]["y"],d,covgrid,sno)
    #printgrid(covgrid)
    #break
  }
  cntr=0
  for (covno in coverage) {
    cov=coverage[covno]
    printf("Checking coverage no %s with range %s ...\n",covno,cov)
    if (cov != ".,.") {
      print(cov)
      if (cntr > 0) {
        split(cov,cr,/,/)
        crmin=int(cr[1])
        crmax=int(cr[2])
        newrmin=crmin
        newrmax=crmax
        for (j in ranges) {
          printf("%s:(%s)->",j,ranges[j])
          split(ranges[j],tr,/,/)
          trmin=int(tr[1])
          trmax=int(tr[2])
          newrange=1
          if (crmin>=trmin && crmin<=trmax) {
            newrmin=trmin
            newrange=0
          }
          if (crmax>=trmin && crmax<=trmax) {
            newrmax=trmax
            newrange=0
          }
          if (trmin>=crmin && trmin<=crmax) {
            newrmin=crmin
            newrange=0
          }
          if (trmax>=crmin && trmax<=crmax) {
            newrmax=crmax
            newrange=0
          }
          newr=sprintf("%s,%s",newrmin,newrmax)
          if(newrange) {
            printf("N(%s)",newr)
            ranges[++cntr]=newr
          } else {
            printf("(%s)",newr)
            ranges[j]=newr
          }
          printf("\n")
        }
      } else {
        cntr=1
        ranges[cntr]=cov
      }
    }
    oldnumr=cntr
    newnumr=0
    if (cntr > 1) {
      print("Merging overlapping ranges ...")
      while (newnumr < oldnumr) {
        oldnumr=cntr
        for (j in ranges) {
          split(ranges[j],tr,/,/)
          trmin=int(tr[1])
          trmax=int(tr[2])
          for (i in ranges) {
            if (i==j) continue;
            split(ranges[i],cr,/,/)
            crmin=int(cr[1])
            crmax=int(cr[2])
            newrmin=crmin
            newrmax=crmax
            mrange=0
            if (crmin>=trmin && crmin<=trmax) {
              newrmin=trmin
              mrange=1
            }
            if (crmax>=trmin && crmax<=trmax) {
              newrmax=trmax
              mrange=1
            }
            if (trmin>=crmin && trmin<=crmax) {
              newrmin=crmin
              mrange=1
            }
            if (trmax>=crmin && trmax<=crmax) {
              newrmax=crmax
              mrange=1
            }
            newr=sprintf("%s,%s",newrmin,newrmax)
            if (mrange) {
              ranges[j]=newr
              delete ranges[i]
              cntr--
            }
          }
        }
        newnumr=cntr
      }
    }
    printf("Intermediate list of ranges ")
    for (j in ranges) {
      printf("%s(%s)",j,ranges[j])
    }
    printf("\n")
  }
  printf("Final list of ranges ")
  for (j in ranges) {
    printf("%s(%s)",j,ranges[j])
  }
  printf("\n")

  numsorbinrange=0
  totalrsizes=0
  for (j in ranges) {
    split(ranges[j],tr,/,/)
    trmin=int(tr[1])
    trmax=int(tr[2])
    totalrsizes+=abs(trmax-trmin)+1
    for (sx in sensorgrid) {
      for (sy in sensorgrid[sx]) {
        if (sy == row) {
          if (sx >= trmin && sx <= trmax) {
            print("Sensor",trmin,trmax,sx,sy,row)
            numsorbinrange++
          }
        }
      }
    }
    for (bx in beacongrid) {
      for (by in beacongrid[bx]) {
        if (by == row) {
          if (bx >= trmin && bx <= trmax) {
            print("Beacon",trmin,trmax,bx,by,row)
            numsorbinrange++
          }
        }
      }
    }
  }
  printf("Num of sensors and beacons in range in row %s: %s Total size of all ranges: %s\n",row,numsorbinrange,totalrsizes)

  if (part==1) {
    #count = count_cov_positions(covgrid,row)
    count = totalrsizes - numsorbinrange
    printf("At row with y=%s there are %s positions where a beacon cannot be present.\n",row,count)
  }
}
function get_coverage(x,y,d,r,            rxmin,rxmax,reachx) {
  reachx = abs(y-r)
  if (reachx > d) {
    rxmin="."
    rxmax="."
  } else {
    rxmin = x-d+reachx
    rxmax=x+d-reachx
  }
  return sprintf("%s,%s",rxmin,rxmax)
}
function distance(x1,y1,x2,y2) {
  return abs(x1 - x2) + abs(y1 - y2)
}
function abs(x) {
  if (x < 0) {
    x=0-x
  }
  return x
}
function count_reach_positions(sens,r) {
  for (s in sens) {
  }
}
function fill_coverage_grid(sx,sy,bd,grid,sn,                x,y,minx,maxx,miny,maxy) {
  if (sn > 1) {
    minx=getmin(grid)
    maxx=getmax(grid)
    for (x in grid) {
      miny=getmin(grid[x])
      maxy=getmax(grid[x])
    }
    if (minx > sx-bd-3) {
      minx = sx-bd-3
    }
    if (maxx < sx+bd+2) {
      maxx = sx+bd+2
    }
    if (miny > sy-bd-3) {
      miny = sy-bd-3
    }
    if (maxy < sy+bd+2) {
      maxy = sy+bd+2
    }
  } else { 
    minx = sx-bd-3
    maxx = sx+bd+2
    miny = sy-bd-3
    maxy = sy+bd+2
  }
  y=miny
  while (y++ < maxy) {
    x=minx
    while (x++ < maxx) {
      if (distance(sx,sy,x,y)<=bd) {
        if (sensor[sn]["x"] == x && sensor[sn]["y"] == y) {
          grid[x][y]="S"
        } else if (beacon[sn]["x"] == x && beacon[sn]["y"] == y) {
          grid[x][y]="B"
        } else {
          grid[x][y]="#"
        }
      } else {
        if (grid[x][y]=="") {
          grid[x][y]="."
        }
      }
    }
  }
}
function getmin(ar,             min,v) {
  min=1000000000000000000000
  for (v in ar) {
    if (int(v) < min) {
      min = int(v)
    }
  }
  return min
}
function getmax(ar,             max,v) {
  max=-1000000000000000000000
  for (v in ar) {
    if (int(v) > max) {
      max = int(v)
    }
  }
  return max
}
function printgrid(grid,          minx,maxx,miny,maxy,x,y,s,b) {
  minx = getmin(grid)
  maxx = getmax(grid)
  for (x in grid) {
    miny = getmin(grid[x])
    maxy = getmax(grid[x])
  }
  printf("minx:%s maxx:%s miny:%s maxy:%s\n",minx,maxx,miny,maxy)
  y=miny-1
  while (y++ < maxy) {
    printf("%10d ",y)
    x=minx-1
    while (x++ < maxx) {
      printf(grid[x][y])
    }
    printf("\n")
  }
}
function count_cov_positions(grid,yc,        x,y,cnt) {
  cnt=0
  for (x in grid) {
    if (grid[x][yc] == "#") {
      cnt++
    }
  }
  return cnt
}
