{
  n = patsplit($0,a,/./)
  print(n)
  i=0
  b=13
  while (i < n) {
    i++
    if (i > b) {
      printf("%s:",i)
      dup=0
      j=i-b-1
      while (j < i) {
        j++
        printf(" %s",a[j])
        if (dup==0) {
          k=j+1
          while (k <= i) {
            if (a[j]==a[k]) {
              dup=1
              break
            }
            k++
          }
        }
      }
      printf("\n")

      if (dup==0) {
        print("marker found at ",i)
        next
      }
    }
  }
}
