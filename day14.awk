BEGIN { sandx=500; sandy=0; grid[sandx][sandy]="+"; minx=1000000; miny=0; }
{
  npoints = split($0,points,/ -> /)
  for (pno in points) {
    #printf("%s -> ",points[pno])
    nc = split(points[pno],coords,/,/)
    x = coords[1]
    y = coords[2]
    grid[x][y]="#"
    if (pno > 1) {
      if (x==prevx) {
        if (prevy > y) {
          fromy=y
          toy=prevy
        } else {
          fromy=prevy
          toy=y
        }
        while (fromy++ < toy) {
          grid[x][fromy]="#"
        }
      }
      if (y==prevy) {
        if (prevx > x) {
          fromx=x
          tox=prevx
        } else {
          fromx=prevx
          tox=x
        }
        while (fromx++ < tox) {
          grid[fromx][y]="#"
        }
      }
    }
    if (x < minx) {
      minx = x
    }
    if (y < miny) {
      miny = y
    }
    if (x > maxx) {
      maxx = x
    }
    if (y > maxy) {
      maxy = y
    }
    prevx = x
    prevy = y
  }
  #printf("\n")
}
END {
  printgrid()
# sand flowing
  iterations=0
  maxiterations=10000
  while(iterations++ < maxiterations) {
    printf("== Iteration %s ==\n",iterations)
    x=sandx
    y=sandy
    trying=1
    while(trying) {
# try down
      if (grid[x][++y]==".") {
        printf("%s,%s - ",x,y)
      } else {
        if (grid[x][y]=="") {
          break
        } else {
          --y
        }
# try left
        if (grid[--x][++y]==".") {
          printf("%s,%s - ",x,y)
        } else {
          if (grid[x][y]=="") {
            break
          } else {
            ++x
            --y
          }
# try right
          if (grid[++x][++y]==".") {
            printf("%s,%s - ",x,y)
          } else {
            if (grid[x][y]=="") {
              break
            } else {
              --x
              --y
            }
            trying=0
          }
        }
      }
    }
    printf("%s,%s\n",x,y)
    if (y <= maxy && x >= minx-1 && x <= maxx+1) {
      grid[x][y]="o"
    } else {
      printf("Sand will keep flowing! %s units of sand have come to rest.\n",iterations-1)
      break
    }
    printgrid()
  }
}
function printgrid() {
    y=miny-1
    while (y++ < maxy) {
      x=minx-2
      printf("%s ",y)
      while (x++ < maxx+1) {
        if (grid[x][y]=="") {
          grid[x][y]="."
        }
        printf(grid[x][y])
      }
      printf("\n")
    }
    printf("\n")
}
