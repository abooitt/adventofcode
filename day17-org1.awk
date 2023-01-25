BEGIN {
  printf("Rocks:\n")
  r=0
  while (r++ < 5) {
    if (r==1) {
      w=4
      h=1
    }
    if (r==2 || r==3) {
      w=3
      h=3
    }
    if (r==4) {
      w=1
      h=4
    }
    if (r==5) {
      w=2
      h=2
    }
    rock[r]["w"]=w
    rock[r]["h"]=h
    printf("Rock %s w:%s h:%s\n",r,w,h)
    y=0
    while (y < rock[r]["h"]) {
      x=0
      while (x < rock[r]["w"]) {
        if (r==1 || r==4 || r==5) {
          c="@"
        }
        if (r==2) {
          if (y==1 || x==1) {
            c="@"
          } else {
            c="."
          }
        }
        if (r==3) {
          if (y==0 || x==2) {
            c="@"
          } else {
            c="."
          }
        }
        rock[r]["shape"][y][x]=c
        x++
      }
      y++
    }
    drawrock(r)
  }
}
function roombottom(                 y,x,roomb,roomw,ra) {
  roomb="+-------+"
  roomw=patsplit(roomb,ra,/./)
  y=0
  x=0
  while (x < roomw) {
    room[y][x]=ra[x+1]
    x++
  }
}
function addroomrows(n,rh,          y,x,ra,roomm,newrh) {
  roomm="|.......|"
  roomw=patsplit(roomm,ra,/./)
  y=rh
  newrh=rh+n
  while (y < newrh) {
    x=0
    while (x < roomw) {
      room[y][x]=ra[x+1]
      x++
    }
    y++
  }
  return y
}
BEGIN {
  roomw=9
  roombottom()
  roomh=addroomrows(4,1)
  printf("Initial room:\n")
  drawroom(roomh)
  printf("\n")
}
{
  numjets = patsplit($0,jet,/./)
}
END {
  if (!lim) {
    lim=2021
  }
  x=1
  while (x < roomw-1) {
    thx[x]=0
    x++
  }
  th=get_tower_height()
  printf("Room  height: %5d\n",roomh)
  printf("Tower height: %5d\n",th)
  numlanded=0
  j=1
  r=1
  roomh=newrock(r,th,roomh)
  minthx=get_min_thx()
  while (numlanded < 2023) {
    drawroom(roomh,minthx-4)
    #roomh=addroomrows(2,roomh)
    #roomh=addroomrows(2,roomh)
    printf("Room  height: %5d\n",roomh)
    while (moverock(r)) {
      drawroom(roomh,minthx-4)
    }
    numlanded++
    minthx=get_min_thx()
    th=get_tower_height()
    r=(numlanded%5)+1
    roomh=newrock(r,th,roomh)
    drawroom(roomh,minthx-4)
    printf("Tower height: %5d, Min thx: %4d, num landed: %4d\n",th,minthx,numlanded)
    if (numlanded > lim) {
      break
    }
  }
}
function getjet(               d) {
  if (j > numjets) {
    j=1
  }
  d=jet[j]
  printf("Jet %5d: %s\n",j,d)
  j++
  return d
}
function moverock(r,                 ry,rx,rh,rw,y,x,landed,cj) {
  landed=0
  if ("pos" in rock[r]) {
    ry=rock[r]["pos"]["y"]
    rx=rock[r]["pos"]["x"]
    rh=rock[r]["h"]
    rw=rock[r]["w"]
    cj=getjet()
    if (cj!=">" && cj!="<") {
      printf("\nERROR invalid value for jet: '%s'\n",cj)
      exit 1
    }
    mp=1
    if (cj==">") {
      printf("To the right? -> ")
      x=rw
      while (x-- > 0) {
        y=0
        while (y < rh) {
          if (rock[r]["shape"][y][x]=="@" && room[ry+y][rx+x+1]!=".") {
            mp=0
            printf("no\n")
            break
          }
          y++
      }
      }
      if (mp) {
        printf("yes\n")
        rx++
      }
    }
    if (cj=="<") {
      printf("To the left? -> ")
      x=-1
      while (x++ < rw-1) {
        y=0
        while (y < rh) {
          if (rock[r]["shape"][y][x]=="@" && room[ry+y][rx+x-1]!=".") {
            mp=0
            printf("no\n")
            break
          }
          y++
        }
      }
      if (mp) {
        printf("yes\n")
        rx--
      }
    }
    printf("Down? -> ")
    y=0
    while (y < rh) {
      x=0
      while (x < rw) {
        if (rock[r]["shape"][y][x]=="@") {
          if (room[ry+y-1][rx+x]!=".") {
            landed=1
            break
          }
        }
        x++
      }
      if (landed) {
        break
      }
      y++
    }
    if (landed) {
      printf("no\n")
      delete rock[r]["pos"]
      y=0
      while (y < rh) {
        x=0
        while (x < rw) {
          if (rock[r]["shape"][y][x]=="@") {
            room[ry+y][rx+x]="#"
            thx[rx+x]=ry+y
          }
          x++
        }
        y++
      }
      return 0
    } else {
      printf("yes\n")
      ry--
      rock[r]["pos"]["y"]=ry
      rock[r]["pos"]["x"]=rx
    }
  } else {
    printf("ERROR rock %s is not placed.\n",r)
    exit 1
  }
  return 1
}
function newrock(r,th,rh,           nr) {
  rock[r]["pos"]["y"]=th+4
  rock[r]["pos"]["x"]=3
  nr=th+4+rock[r]["h"]-rh
  rh=addroomrows(nr,rh)
  return rh
}
function get_min_thx(                 y,x) {
  y=1000000
  for (x in thx) {
    if (y > thx[x]) {
      y=thx[x]
    }
  }
  return y
}
function get_tower_height(                    y,x) {
  y=0
  for (x in thx) {
    if (y < thx[x]) {
      y=thx[x]
    }
  }
  return y
}
function drawrock(r,                  y,x) {
  y=rock[r]["h"]
  while (y-- > 0) {
    x=0
    while (x < rock[r]["w"]) {
      printf("%s",rock[r]["shape"][y][x])
      x++
    }
    printf("\n")
  }
  printf("\n")
}
function drawroom(ymax,ymin,            y,x,r,c) {
  y=ymax
  if (ymin < 0) {
    ymin=0
  }
  while (y-- > ymin) {
    x=0
    printf("%5d ",y)
    while (x < roomw) {
      c=room[y][x]
      for (r in rock) {
        if ("pos" in rock[r]) {
          ry=rock[r]["pos"]["y"]
          rx=rock[r]["pos"]["x"]
          rh=rock[r]["h"]
          rw=rock[r]["w"]
          if (y >= ry && y < ry+rh && x >= rx && x < rx+rw) {
            c=rock[r]["shape"][y-ry][x-rx]
          }
        }
      }
      if (!c) {
        c="X"
      }
      printf("%s",c)
      x++
    }
    printf("\n")
  }
  printf("%5s "," ")
  x=0
  while (x < roomw) {
    printf("%s",x)
    x++
  }
  printf("\n")
}
