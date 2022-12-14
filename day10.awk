BEGIN {
  if (part == "") {
    part=1
  }
  x=1
  p=0
}
{
#  print
  cmd = $1
  if (cmd=="noop") {
    l=1
    newx=x
  }
  if (cmd=="addx") {
    l=2
    newx=x+$2
  }
  i=0
  while (i++ < l) {
    c++
    j=0
    while (j < 7) {
      if (c == 20+j*40) {
        ss = c*x
        sum+=ss
      }
      j++
    }
# part 1:
    if (part==1) {
      print(c,x,newx,ss,sum)
    } else {
# part 2
      s=-1
      draw=0
      while (s < 2) {
        if (p%40 == x+s) {
          draw=1
          break
        }
        s++
      }
      if (draw==1) {
        printf("#")
      } else {
        printf(".")
      }
      p++
      if (p%40 == 0) {
        printf("\n")
      }
    }
  }
  x=newx
}
