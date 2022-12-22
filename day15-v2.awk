BEGIN {
  if (part != 1 && part != 2) {
    part=1
  }
  if (part==1) {
    if (row=="") {
      row=10
    }
  }
  centerrow=row
  if (part==1) {
    rowrange=0
    rowlowerlimit=centerrow
    rowupperlimit=centerrow
  } else {
    if (test) {
      centerrow=10
      rowrange=10
    } else {
      centerrow=2000000
      rowrange=2000000
    }
    rowlowerlimit=centerrow-rowrange
    rowupperlimit=centerrow+rowrange
    maxrangesize=rowupperlimit-rowlowerlimit+1
  }
}
{
  sno=NR
  na = split($0,a,/: /)
  for (i in a) {
    nb = patsplit(a[i],b,/[xy]=-?[0-9]+/)
    for (j in b) {
      nc = split(b[j],c,/=/)
      if (i == 1) {
        if (j==1) {
          printf("Sensor %d: ", sno)
        }
        sensor[sno][c[1]]=c[2]
      }
      if (i == 2) {
        if (j==1) {
          printf("beacon: ")
        }
        beacon[sno][c[1]]=c[2]
      }
      printf("%s ",b[j])
    }
    printf(" - ")
  }
  sensorgrid[sensor[sno]["x"]][sensor[sno]["y"]]=1
  beacongrid[beacon[sno]["x"]][beacon[sno]["y"]]=1
  d = distance(sensor[sno]["x"],sensor[sno]["y"],beacon[sno]["x"],beacon[sno]["y"])
  printf("distance: %s -",d)

  if (part==1) {
    row=rowlowerlimit
    upperlimit=rowupperlimit
  } else {
    row=sensor[sno]["y"]-d
    upperlimit=sensor[sno]["y"]+d
    if (row < rowlowerlimit) {
      row=rowlowerlimit
    }
    if (upperlimit > rowupperlimit) {
      upperlimit=rowupperlimit
    }
  }
  while (row <= upperlimit) {
    min = getminxatrow(row,sensor[sno]["x"],sensor[sno]["y"],d)
    max = getmaxxatrow(row,sensor[sno]["x"],sensor[sno]["y"],d)
    if (min != ".") {
      if (part==2) {
        if (min < rowlowerlimit) {
          min=rowlowerlimit
        }
        if (max > rowupperlimit) {
          max=rowupperlimit
        }
        if (!rowfull[row]) {
          rowswithgaps[row]=1
          add_to_ranges(min,max)
          if (rcnt[row]==1 && ranges[row][1]["from"]==rowlowerlimit && ranges[row][1]["to"]==rowupperlimit) {
            rowfull[row]=1
            delete rowswithgaps[row]
          }
        }
      } else {
        rowswithgaps[row]=1
        add_to_ranges(min,max)
      }
    }
    row++
  }
  if (part==1) {
    row=centerrow
    printf("distance: %d - reach range at row %d: (%s,%s) - ranges gathered so far: ",d,row,min,max)
    if (rcnt[row] > 0) {
      for (i in ranges[row]) {
        printf("[%s](%s,%s)",i,ranges[row][i]["from"],ranges[row][i]["to"])
      }
    }
  }
  printf("\n")
}
END {
  for (row in rowswithgaps) {
    numsorbinrange=0
    totalrsizes=0
    for (i in ranges[row]) {
      from=ranges[row][i]["from"]
      to=ranges[row][i]["to"]
      totalrsizes+=abs(to-from)+1
      for (sx in sensorgrid) {
        for (sy in sensorgrid[sx]) {
          if (sy == row) {
            if (sx >= from && sx <= to) {
              print("Sensor",from,to,sx,sy,row)
              numsorbinrange++
            }
          }
        }
      }
      for (bx in beacongrid) {
        for (by in beacongrid[bx]) {
          if (by == row) {
            if (bx >= from && bx <= to) {
              print("Beacon",from,to,bx,by,row)
              numsorbinrange++
            }
          }
        }
      }
    }
    printf("Num of sensors and beacons in range in row %s: %s Total size of all ranges: %s\n",row,numsorbinrange,totalrsizes)
    if (part==2) {
      if (totalrsizes<maxrangesize) {
        printf("Row with totalrsizes of %s which is less than maxrangesize of %s\n",totalrsizes,maxrangesize)
        rowswithlowerrsize[++rwlrsi]=row
      }
    }
  }

  if (part==1) {
    count = totalrsizes - numsorbinrange
    printf("At row with y=%s there are %s positions where a beacon cannot be present.\n",row,count)
  } else {
    printf("Rows with lower rsize: ")
    for (i in rowswithlowerrsize) {
      bx=findbeaconxatrow(rowswithlowerrsize[i])
      printf("(%s)Bx(%s)",rowswithlowerrsize[i],bx)
      printf("Tuning frequency: %s",bx*4000000+rowswithlowerrsize[i])
    }
    printf("\n")
  }
}
function findbeaconxatrow(y,        i,from,to,bxs,bxsi,ret) {
  bxsi=1
  for (i in ranges[y]) {
    from=ranges[y][i]["from"]
    to=ranges[y][i]["to"]
    if (to < rowupperlimit) {
      if (bxs[bxsi]["from"]=="") {
        bxs[bxsi]["from"]=to+1
      } else {
        bxs[++bxsi]["from"]=to+1
      }
    }
    if (from > rowlowerlimit) {
      if (bxs[bxsi]["to"]=="") {
        bxs[bxsi]["to"]=from-1
      } else {
        bxs[++bxsi]["to"]=from-1
      }
    }
  }
  ret=""
  if (bxsi==1) {
    if (bxs[1]["from"]==bxs[1]["to"]) {
      ret=bxs[1]["from"]
    } else {
      ret="ERR"
    }
  } else {
    ret="ERR"
  }
  return ret
}
function add_to_ranges(from,to,                rf,rt,rcf,rct,merge,i,j,k) {
  ranges[row][++rcnt[row]]["from"]=from
  ranges[row][rcnt[row]]["to"]=to
  if (rcnt[row] > 1) {
    while(1) {
      prevrcnt=rcnt[row]
      i=0
      while (i++ < rcnt[row]) {
        rf=ranges[row][i]["from"]
        rt=ranges[row][i]["to"]
        j=i
        while (j++ < rcnt[row]) {
          merge=0
          if (!isarray(ranges[row][j])) {
            continue
          } else {
            rcf=ranges[row][j]["from"]
            rct=ranges[row][j]["to"]
            if (rct >= rf-1 && rct <= rt) {
              merge=1
              if (rcf <= rf-1) {
                rf=rcf
                ranges[row][i]["from"]=rf
              }
            } else {
              if (rcf <= rt+1 && rcf >= rf) {
                merge=1
                if (rct >= rt+1) {
                  rt=rct
                  ranges[row][i]["to"]=rt
                }
              } else {
                if (rt >= rcf-1 && rt <= rct) {
                  merge=1
                  rt=rct
                  ranges[row][i]["to"]=rct
                  if (rcf <= rf-1) {
                    rf=rcf
                    ranges[row][i]["from"]=rf
                  }
                } else {
                  if (rf <= rct+1 && rf >= rcf) {
                    merge=1
                    rf=rcf
                    ranges[row][i]["from"]=rf
                    if (rt <= rct) {
                      rt=rct
                      ranges[row][i]["to"]=rct
                    }
                  }
                }
              }
            }
            if (merge) {
              k=j
              while (k++ < rcnt[row]) {
                ranges[row][k-1]["from"]=ranges[row][k]["from"]
                ranges[row][k-1]["to"]=ranges[row][k]["to"]
              }
              delete ranges[row][rcnt[row]--]

            }
          }
        }
      }
      if (prevrcnt==rcnt[row]) {
        break
      }
    }
  }
}
function getminxatrow(r,x,y,d) {
  if (abs(r-y) <= d) {
    return (x-(d-abs(r-y)))
  } else {
    return "."
  }
}
function getmaxxatrow(r,x,y,d) {
  if (abs(r-y) <= d) {
    return (x+(d-abs(r-y)))
  } else {
    return "."
  }
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
