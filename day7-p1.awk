/^[$]/ { 
  cmd = $2
  if (cmd == "cd") {
    list=0
    print
    tdir = $3
    if (tdir == "/") {
      i++
      path[i]="/"
      curdir = "/"
      parent[curdir]="/"
    }
    else if (tdir == "..") {
      curdir = parent[curdir]
    } else {
      p = curdir
      if (p == "/") {
        curdir = "/" tdir
      } else {
        curdir = p "/" tdir
      }
      i++
      path[i] = curdir
      parent[curdir] = p
    }
    print(curdir)
  }
  if (cmd == "ls") {
    print(cmd " " curdir)
    list=1
  }
}
list == 1 && /^[0-9]+ / {
  print
  size[curdir]+=$1
  d=curdir
  print("c",d,size[d])
  while (d != "/") {
    d=parent[d]
    size[d]+=$1
    print("p",d,size[d])
  }
}
END {
  totalspace=70000000
  neededspace=30000000
  tofreeup=neededspace-(totalspace-size["/"])
  smallest=totalspace
  for (d in size) {
    print(d,size[d])
    if (size[d]<=100000) {
      sum+=size[d]
    }
    if (size[d]>=tofreeup) {
      if (smallest > size[d]) smallest = size[d]; 
    }
  }
  print(sum)
  print(tofreeup)
  print(smallest)
}
