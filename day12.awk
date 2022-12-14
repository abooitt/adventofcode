BEGIN {
  if (part=="") {
    part=1
  } else {
    part=2
  }
  heights="abcdefghijklmnopqrstuvwxyz"
  nh = patsplit(heights,hlevel,/./)
  for (h in hlevel) {
    level[hlevel[h]] = h
    #print(h,hlevel[h],level[hlevel[h]])
  }
}
{
  y=NR
  gw = patsplit($0,a,/./)
  x=0
  while (x++ < gw) {
    if (a[x] == "S") {
      startx = x
      starty = y
      a[x] = "a"
    }
    if (a[x] == "E") {
      ex = x
      ey = y
      a[x] = "z"
    }
    grid[x][y] = a[x]
    gh[x][y] = level[a[x]]
  }
}
END {
  if (part==1) {
    numstartpositions=1
    startpositions[startx][starty]=1
  } else {
    numstartpositions=0
    y = 0
    while (y++ < NR) {
      x = 0
      while (x++ < gw) {
        #printf(" %s:%s",grid[x][y],gh[x][y])
        if (grid[x][y] == "a") {
          startpositions[x][y] = 1
        }
      }
#      printf("\n")
    }
  }
  for (startx in startpositions) {
    for (starty in startpositions[startx]) {
      printf("Starting position: %s, %s, with height %s:%s\n",startx,starty,grid[startx][starty],gh[startx][starty])
      printf("Goal position: %s, %s\n",ex,ey)
      found = 0
      numtrails=1
      trails[1]["x"]=startx
      trails[1]["y"]=starty
      trails[1]["path"]=""
      trails[1]["heights"]=grid[startx][starty]
      trails[1]["steps"]=0
      trails[1]["loop"]=0
      visited[startx][starty]=1
      newnumtrails = numtrails
      while ( found == 0 ) {
        #printf("Numtrails: %s\n",numtrails)
        tid=0
        while (tid++ < numtrails) {
          if (trails[tid]["loop"] == 1) {
            continue
          }
          #printf(tid)
          curstep = trails[tid]["steps"]
          curpath = trails[tid]["path"]
          heights = trails[tid]["heights"]
          x = trails[tid]["x"]
          y = trails[tid]["y"]
          curheight = gh[x][y]
          curgrid = grid[x][y]
          tries = 4
          t=0
          while (t++ < tries) {
            #if(trails[tid]["steps"] > curstep) {
            #  continue
            #}
# up
            if (t==1) {
              newx = x
              newy = y-1
              dir = "^"
            }
# down
            if (t==2) {
              newx = x
              newy = y+1
              dir = "v"
            }
# left
            if (t==3) {
              newx = x-1
              newy = y
              dir = "<"
            }
# right
            if (t==4) {
              newx = x+1
              newy = y
              dir = ">"
            }
            if (newx < 1 || newy < 1 || newx > gw || newy > NR) {
              continue
            }
            if (visited[newx][newy] == 1) {
              continue
            }
            #printf("-%s<=%s?",gh[newx][newy],gh[x][y]+1)
            if (int(gh[newx][newy]) <= int(gh[x][y]+1) ) {
              #printf("%s%s%s",grid[x][y],dir,grid[newx][newy])
              if (curstep == trails[tid]["steps"]) {
                trails[tid]["path"]=trails[tid]["path"] dir
                trails[tid]["steps"]++
                trails[tid]["x"]=newx
                trails[tid]["y"]=newy
                trails[tid]["heights"] = heights grid[newx][newy]
              } else {
                newnumtrails++
                trails[newnumtrails]["x"]=newx
                trails[newnumtrails]["y"]=newy
                trails[newnumtrails]["path"] = curpath dir
                trails[newnumtrails]["steps"] = curstep+1
                trails[newnumtrails]["loop"]=0
                trails[newnumtrails]["heights"] = heights grid[newx][newy]
              }
              visited[newx][newy]=1
              if (newx == ex && newy == ey) {
                found = 1
              }
            }
          }
          if (trails[tid]["x"] == x && trails[tid]["y"] == y) {
            trails[tid]["loop"] = 1
          }
        }
        #printf("\n")
        numtrails=newnumtrails
        tid=0
        numtrailsstillon=0
        while (tid++ < numtrails) {
          if (trails[tid]["loop"] == 0) {
            #printf("Trail %s path %s heights %s position %s,%s loop %s steps %s\n",tid,trails[tid]["path"],trails[tid]["heights"],trails[tid]["x"],trails[tid]["y"],trails[tid]["loop"],trails[tid]["steps"])
            numtrailsstillon++
          }
        }
        printf("%s.",numtrailsstillon)
        if (numtrailsstillon == 0) {
          break
        }
      }
      printf("\n")
      for (i in trails) {
        if (trails[i]["loop"] == 0 && trails[i]["x"] == ex && trails[i]["y"] == ey) {
          printf("%s steps led trail %s from position %s,%s to the goal position.\n",trails[i]["steps"],i,startx,starty)
        }
      }
      delete trails
      delete visited
    }
  }
}
