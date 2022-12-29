BEGIN {
  g=5
  digits["2"]=2
  digits["1"]=1
  digits["0"]=0
  digits["-"]=-1
  digits["="]=-2
  snafu[-2]="="
  snafu[-1]="-"
  snafu[0]="0"
  snafu[1]="1"
  snafu[2]="2"
}
{
  printf("%20s ",$0)
  n = patsplit($0,a,/./)
  printf("%5d %5d ",length($0),n)
  i=0
  x=0
  while (i++ < n) {
    d = digits[a[i]]
    #printf("%s:%5d ",i,d)
    x += d*g^(n-i)
  }
  sum+=x
  printf("%6d %2d %6d ",x,length(x),sum)
  i=1
  s=""
  x=sum
  while (1) {
    m[i]=x%g
    x=(x-m[i])/g
    s=sprintf("%d%s",m[i],s)
    if (m[i]>2) {
      m[i]=m[i]-g
      x++
    }
    if (x==0) {
      break
    }
    i++
  }
  printf("%d ",s)
  while (i>0) {
    printf("%s",snafu[m[i]])
    i--
  }
  printf("\n")
  delete m
}
