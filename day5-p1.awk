BEGIN { 
  schema=1 
  h=8
}

schema==1 {
  #print
  line[NR] = $0
  n = patsplit($0,a,/(\[[A-Z]\]|    )/)
  if (n > 0) {
    for (i in a) {
      #print(i,a[i])
      if (a[i] != "    ") {
        stacks[i][h] = a[i]
        if (h > top[i]) top[i] = h;
      }
    }
    h--
  } else {
    schema=0
    for (i in line) {
      print(line[i])
    }
    for (i in stacks) {
      printf("%s:%s: ",i,top[i])
      for (h in stacks[i]) {
        printf("%s ",stacks[i][h])
      }
      printf("\n")
    }
  }
}

/^ move/ {
  num = $2
  from = $4
  to = $6
  printf("%s -> moving %s crates from %s to %s ... \n",NR,num,from,to)
  done = 0
  while (done < num) {
    done++
    top[to]++
    stacks[to][top[to]] = stacks[from][top[from]]
    delete stacks[from][top[from]]
    top[from]--
  }
  for (i in stacks) {
    printf("%s:%s: ",i,top[i])
    for (h in stacks[i]) {
      printf("%s ",stacks[i][h])
    }
    printf("\n")
  }
}
END {
  seq=""
  for (i in stacks) {
    seq = sprintf("%s%s",seq,stacks[i][top[i]])
  }
  printf("%s\n",seq)
  n = patsplit(seq,a,/[A-Z]/)
  for (i in a) printf("%s",a[i]);
  printf("\n")
}
