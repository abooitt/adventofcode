/^\[/ {
  left=$0
  getline
  right=$0
  print(left,right)
  nl = patsplit(left,la,/\[|[0-9]+|,|\]/)
  lid=0
  numlists=0
  valno[lid]=0
  for (i in la) {
    printf(" %s",la[i])
    if (la[i]=="[") {
      numlists++
      parent[numlists]=lid
      valno[lid]++
      type[lid][valno[lid]] = "list"
      value[lid][valno[lid]] = "["
      pid=parent[lid]
      while (pid >= 0) {
        value[pid][valno[pid]] = value[pid][valno[pid]] la[i]
        if (pid > 0) {
          pid = parent[pid]
        } else {
          break
        }
      }
      lid = numlists
      continue
    }
    if (la[i] ~ /[0-9]+/) {
      valno[lid]++
      type[lid][valno[lid]] = "int"
      value[lid][valno[lid]] = la[i]
      pid=parent[lid]
      while (pid >= 0) {
        value[pid][valno[pid]] = value[pid][valno[pid]] la[i]
        if (pid > 0) {
          pid = parent[pid]
        } else {
          break
        }
      }
      continue
    }
    if (la[i] == ",") {
      pid=parent[lid]
      while (pid >= 0) {
        value[pid][valno[pid]] = value[pid][valno[pid]] la[i]
        if (pid > 0) {
          pid = parent[pid]
        } else {
          break
        }
      }
      continue
    }
    if (la[i] == "]") {
      if (lid > 0) {
        update_parents(value,
        lid = parent[lid]
      }
    }
  }
  printf("\n")
  for (lid in value) {
    printf("%s: ",lid)
    for (vid in value[lid]) {
      printf("%s ",value[lid][vid])
    }
    printf("\n")
  }
  delete value
  delete valno
  delete type
  delete parent
}

function update_parents(values, valnos, parlist, listid) {
  pid=parlist[listid]
  while (pid >= 0) {
    values[pid][valnos[pid]] = values[pid][valnos[pid]] la[i]
    if (pid > 0) {
      pid = parlist[pid]
    } else {
      break
    }
  }
}
