{
  valves[$2]=NR
  patsplit($0,a,/[0-9]+/)
  flow[$2]=int(a[1])
  if (flow[$2]>0) {
    topick[flow[$2]]=$2
  }
  split($0,a,/valves? /)
  split(a[2],b,/, /)
  for (i in b) {
    conn[$2][b[i]]=NR
  }

  printf("%2d - %s - %2d - ",NR,$2,flow[NR])
  for (i in conn[$2]) {
    printf("(%s)",i)
  }
  printf("\n")
}
END {
  for (i in valves) {
    for (j in valves) {
      if (i==j) {
        dist[i][j]=0
      } else {
        dist[i][j]=99
      }
    }
  }
  for (i in conn) {
    printf("%s",i)
    for (j in conn[i]) {
      dist[i][j]=1
      printf("(%s:%2d)",j,dist[i][j])
    }
    printf("\n")
  }
  for (i in dist) {
    printf("%s",i)
    for (j in dist[i]) {
      printf("(%s:%2d)",j,dist[i][j])
    }
    printf("\n")
  }
  for (k in valves) {
    for (i in valves) {
      for (j in valves) {
        if (i==j) {
          dist[i][j]=0
        }
        d=dist[i][k]+dist[k][j]
        if (d < dist[i][j]) {
          dist[i][j]=d
        }
      }
    }
  }
  for (i in dist) {
    printf("%s:%2d",i,flow[i])
    for (j in dist[i]) {
      printf("(%s:%2d)",j,dist[i][j])
    }
    printf("\n")
  }
  n = asorti(topick, sorted, "@ind_num_desc")
  i=0
  while (i++ < n) {
    printf("(%s:%s)",topick[sorted[i]],flow[topick[sorted[i]]])
    closed[topick[sorted[i]]]=flow[topick[sorted[i]]]
  }
  printf("\n")
  for (i in closed) {
    printf("(%s:%s)",i,flow[i])
  }
  printf("\n")
  if (part==2) {
    if (!numhelpers) {
      numhelpers=1
    }
    if (!remaining) {
      remaining=26
    }
  } else {
    part=1
    numhelpers=0
    remaining=30
  }
  start="AA"
  num=numhelpers+1
  n=0
  while (n++ < num) {
    dests[n]=""
    pos[n]=start
    rem[n]=remaining
    curflows[n]=0
    totalflows[n]=0
  }
  curflow=0
  totalflow=0
  div=10000
  pickn(pos,destsets)
  i=0
  while (i++ < length(destsets)) {
    printf("Set %s:",i)
    j=0
    while (j++ < length(destsets[i])) {
      printf("P%s",j)
      for (k in destsets[i][j]) {
        printf("(%s)",k)
      }
    }
    printf("\n")
  }
  exit
  while (remaining > 0) {
    printf("Remaining minutes: %s, current flow: %s, total pressure release so far: %s\n",remaining,curflow,totalflow)
    n=0
    while (n++ < num) {
      dests[n]=""
    }
    getnext(rem,pos,dests)
    maxrem=0
    totalflow=0
    for (di in dests) {
      dest=dests[di]
      if (dest!="") {
        steps=dist[pos[di]][dest]
        printf("Persona %s goes to valve %s in %s steps.\n",di,dest,steps)
        rem[di]-=steps
        totalflows[di]+=curflows[di]*steps
        pos[di]=dest
        rem[di]-=1
        totalflows[di]+=curflows[di]
        curflows[di]+=flow[pos[di]]
        delete closed[pos[di]]
      } else {
        if (rem[di] > 0) {
          rem[di]-=1
          totalflows[di]+=curflows[di]
        }
        printf("No valve left to go to for persona %s. Remaining minutes: %s, current flow: %s, total pressure release so far: %s\n",di,rem[di],curflows[di],totalflows[di])
      }
      if (maxrem < rem[di]) {
        maxrem = rem[di]
      }
      totalflow+=totalflows[di]
    }
    remaining=maxrem
    printf("Remaining minutes: %s, total pressure release so far: %s\n",remaining,totalflow)
  }
}
function pickn(od,sets,                tc,d,picked,di,i,ii,tclosed,numc,numd,dii,diii,j,k,cno,cnoo,set,numsets,setbase,prevcno,cnot) {
  delete sets
  #numc=length(closed)
  numc=asorti(closed, tc, "@ind_str_asc")
  numd=length(od)
  printf("Num closed: %s\n",numc)
  if (numc == 0) {
    return
  }
  for (i in tc) {
    printf("%s(%s)",i,tc[i])
  }
  printf("\n")
  di=0
  while (di++ < numd) {
    cnoo=0
    printf("%s:",di)
    while (cnoo++ < numc) {
      if (cnoo >= di && cnoo <= (numc-numd+di) ) {
        i=tc[cnoo]
        tclosed[di][i]=1
        printf("(%s)",i)
      }
    }
    printf("\n")
  }
  di=0
  printf("Numd:%s Numc:%s\n",numd,numc)
  ii=0
  set=1
  while (ii++ < (numc-numd+1)) {
    printf("ii:%s\n",ii)
    di=0
    while (di++ < numd) {
      cno[di]=ii+di-1
    }
    di=numd
    i=cno[di]-1
    while (i++ < numc-numd+di) {
      sets[set][di][i]=1
      dii=numd
      while (dii-- > 1) {
        sets[set][dii][cno[dii]]=1
      }
      set++
    }
    if (numd==1) {
      break
    }
  }
  set=0
  numsets=length(sets)
  while (set++ < numsets) {
    printf("%s->",set)
    for (di in sets[set]) {
      for (i in sets[set][di]) {
        sets[set][di][tc[i]]=1
        delete sets[set][di][i]
        printf("%s:(%s)",di,tc[i])
      }
    }
    printf("\n")
  }
  set=0
  while (set++ < numsets) {
    printf("%s->",set)
    for (di in sets[set]) {
      for (i in sets[set][di]) {
        printf("%s:(%s)",di,i)
      }
    }
    printf("\n")
  }
  return
}
function getnext(r,p,d,           numc,i,ranki,maxrank,di,td,tdi,tclosed,numd,n,set,setbase,pdsets) {
  maxrank=0
  if (length(closed)==0) {
    return
  }
  pickn(d,pdsets)
  for (i in pdsets) {
    for (di in pdsets[i]) {
      for (j in pdsets[i][di]) {
        td[di]=j
        printf("For persona %s considering valve %s with flow %s ... \n",di,j,flow[j])
      }
    }
    ranki=calcrankingn(r,p,td)
    printf("... (combined) ranking: %s\n",ranki)
    if (maxrank < ranki) {
      maxrank=ranki
      for (di in td) {
        d[di]=td[di]
      }
    }
  }
}
function calcranking(r,p,d,        i,ranki,rd,rankd,maxrank) {
  rd=r-dist[p][d]-1
  if (rd < 1) {
    return 0
  }
  rankd=flow[d]*rd
  delete closed[d]
  maxrank=0
  for (i in closed) {
    ranki=calcranking(rd,d,i)
    if (maxrank < ranki) {
      maxrank=ranki
    }
  }
  closed[d]=1
  rankd+=maxrank
  return rankd
}
function calcrankingn(orgr,orgp,orgd,          r,p,d,di,i,j,ranki,rd,rankd,maxrank,rankdtotal,picked,numc,nump,pdsets,td) {
  # make a copy of the arrays
  for (di in orgd) {
    r[di]=orgr[di]
    p[di]=orgp[di]
    d[di]=orgd[di]
    printf("Calcrankingn for Persona %s rem:%s pos:%s dest:%s\n",di,r[di],p[di],d[di])
  }
  rankdtotal=0
  for (di in d) { 
    rd[di]=r[di]-dist[p[di]][d[di]]-1
    if (rd[di] < 1) {
      delete d[di]
      delete rd[di]
    } else {
      rankd[di]=flow[d[di]]*rd[di]
      delete closed[d[di]]
      rankdtotal+=rankd[di]
    }
  }
  maxrank=0
  pdsets[0][0][0]=1
  delete pdsets[0][0][0]
  pickn(d,pdsets)
  for (i in pdsets) {
    printf("Trying ")
    for (di in pdsets[i]) {
      for (j in pdsets[i][di]) {
        td[di]=j
        printf("(%s)",j)
      }
    }
    printf("\n")
    if (length(td)) {
      ranki=calcrankingn(rd,d,td)
      if (maxrank < ranki) {
        maxrank=ranki
      }
    }
  }
  for (di in d) {
    closed[d[di]]=1
  }
  rankdtotal+=maxrank
  printf("Total ranking: %s\n",rankdtotal)
  return rankdtotal
}
