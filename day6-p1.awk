{
  n = patsplit($0,a,/./)
  print(n)
  i=0
  while( i < n) {
    i++
    if (i > 3) {
      print(i,a[i-3],a[i-2],a[i-1],a[i])
      if ( a[i-3] == a[i-2] || a[i-3] == a[i-1] || a[i-3] == a[i] || a[i-2] == a[i-1] || a[i-2]==a[i] || a[i-1]==a[i]) {
        continue
      } else {
        print("first marker found at ",i)
        next
      }
    }
  }
}
