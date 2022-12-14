BEGIN {
  if (part=="") {
    part=1
  } else {
    part=2
  }
}
/^\[/ {
  pair++
  b=0
  while (b++ < 2) {
    packet++
    p[b]=$0
    pack[packet]=$0
    getline
  }
  printf("== Pair %s ==\n",pair)
  result = compare(p[1],p[2])
  if (result==1) {
    sum+=pair
  }
}
END {
  printf("Sum of indices of pairs in the right order: %s\n",sum)
  if (part==1) {
    exit
  }
  packet++
  pack[packet]="[[2]]"
  packet++
  pack[packet]="[[6]]"
  divids_product = sort_packets(pack,packet)
  print(divids_product)
}

function sort_packets(pack,div2,        i,p,numinrightorder,di1,di2) {
  di1=div2-1
  di2=div2
  numinrightorder=0
  iteration=0
  while (numinrightorder < div2-1) {
    iteration++
    i=0
    numinrightorder=0
    while (i++ < div2-1) {
      res = compare(pack[i],pack[i+1])
      if (res == 0) {
        p = pack[i]
        pack[i] = pack[i+1]
        pack[i+1] = p
        if (di1 == i) {
          di1 = i+1
        }
        if (di1 == i+1) {
          di1 = i
        }
        if (di2 == i) {
          di2 = i+1
        }
        if (di2 == i+1) {
          di2 = i
        }
      } else {
        numinrightorder++
      }
    }
    printf("Iteration %s: numinrightorder: %s\n",iteration,numinrightorder)
  }
  return di1*di2
}

function printindents(rec,       b) {
  b=0
  while (b++ < rec) {
    printf("  ")
  }
}

function compare(left,right,rec,       b,t,x,num,min,a,res,ar) {
  printindents(rec)
  printf("- Compare %s vs %s\n",left,right)
  rec++
  b=0
  while (b++ < 2) {
    if (b==1) {
      t[b] = type(left)
      if (t[b]=="list") {
        x[b] = get_list_values(left)
      } else {
        x[b] = left
      }
    } else {
      t[b] = type(right)
      if (t[b]=="list") {
        x[b] = get_list_values(right)
      } else {
        x[b] = right
      }
    }
    #print(b,t[b],x[b])
    if (t[b]=="list") {
      ar[b][1]=""
      delete ar[b][1]
      num[b] = split(x[b],ar[b],/ /)
    } else {
      num[b]=1
      ar[b][1]=x[b]
    }
  }
  if (t[1]=="int" && t[2]=="int") {
    if (x[1]==x[2]) {
      return -1
    }
    if(x[1]>x[2]) {
      printindents(rec)
      printf("- Right side is smaller, so inputs are not in the right order\n")
      return 0
    } else {
      printindents(rec)
      printf("- Left side is smaller, so inputs are in the right order\n")
      return 1
    }
  }
  #print(num[1],num[2])
  if (num[1] > num[2]) {
    min = num[2]
  } else {
    min = num[1]
  }
  a=0
  res=-1
  while (a++ < min) {
    #print(ar[1][a],ar[2][a])
    res = compare(ar[1][a],ar[2][a],rec)
    if (res > -1) {
      break
    }
  }
  if (res == -1) {
    if (num[1] < num[2]) {
      printindents(rec)
      printf("- Left side ran out of items, so inputs are in the right order\n")
      return 1
    }
    if (num[1] > num[2]) {
      printindents(rec)
      printf("- Right side ran out of items, so inputs are not in the right order\n")
      return 0
    }
  }
  return res
}

function get_list_values(list) {
  n = patsplit(list,la,/\[|[0-9]+|,|\]/)
  #print(n)
  ll=0
  res=""
  j=0
  delete el
  for (i in la) {
    #print(ll,j,la[i])
    if (la[i] == "[") {
      ll++
      if (ll == 2) {
        j++
      }
    }
    if (la[i] == "]") {
      if (ll == 2) {
        el[j] = el[j] la[i]
      }
      ll--
    }
    if (ll > 1) {
      el[j] = el[j] la[i]
      continue
    }
    if (ll == 1) {
      if (la[i] ~ /[0-9]+/) {
        j++
        el[j] = la[i]
      }
      if (la[i] == ",") {
        continue
      }
    }
  }
  k=0
  while (k++ < j) {
    if (res == "") {
      res = res el[k]
    } else {
      res = res " " el[k]
    }
  }
  return res
}

function type(v) {
  c1 = substr(v,1,1)
  if (c1 == "[") {
    t="list"
  } else {
    t="int"
  }
  return t
}
