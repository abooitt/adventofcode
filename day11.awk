BEGIN {
  modulus = 1
}
/^Monkey [0-9]+:/ {
  split($2,a,":")
  m=a[1]
}
/^  Starting/ {
  numitems[m] = patsplit($0,sitems,/[0-9]+/)
  for (j in sitems) {
    items[m][j] = sitems[j]
  }
}
/^  Operation:/ {
  split($0,a,/: /)
  op=a[2]
  split(op,a,/ /)
  operator[m]=a[4]
  operand[m]=a[5]
}
/^  Test:/ {
  split($0,a,/: /)
  t=a[2]
  patsplit(t,a,/[0-9]+/)
  test[m]=a[1]
#  if (test[m]!=2) {
    modulus = modulus * test[m]
#  }
}
/^    If true:/ {
  iftrue[m]=$NF
}
/^    If false:/ {
  iffalse[m]=$NF
}
END {
  damping=1
  for (i in items) {
    num++
    printf("%s:",i)
    j=0
    while (j++ < numitems[i]) {
      printf(" %s",items[i][j])
    }
    printf("\n")
    printf("  Operation - %s %s\n",operator[i],operand[i])
    printf("  Test - %s\n",test[i])
    printf("    if true  - %s\n",iftrue[i])
    printf("    if false - %s\n",iffalse[i])
  }
  round=0
  numrounds=10000
  while (round++ < numrounds) {
    print("Round: ",round)
    i=0
    while (i < num) {
      printf("Monkey %s:\n",i)
      for (j in items[i]) {
        printf("  Monkey inspects item %s with a worry level of %s.\n",j,items[i][j])
        numinsp[i]++
        old = items[i][j]
        if (operand[i] == "old") {
          operandx = old
        } else {
          operandx = operand[i]
        }
        if (operator[i] == "+") {
          new = old + operandx
        }
        if (operator[i] == "*") {
          new = old * operandx
        }
        new = new % modulus
        printf("    Worry level is %sed with %s to %s.\n",operator[i],operandx,new)
        #new = int(new/damping)
        #printf("    Monkey gets bored with item. Worry level is divided by %s to %s.\n",damping,new)
        if ( (new % test[i]) == 0 ) {
          printf("    Current worry level is divisible by %s.\n",test[i])
          dm=iftrue[i]
        } else {
          printf("    Current worry level is not divisible by %s.\n",test[i])
          dm=iffalse[i]
        }
        printf("    Item with worry level %s is thrown to monkey %s.\n",new,dm)
          delete items[i][j]
          numitems[dm]++
          items[dm][numitems[dm]] = new
      }
      numitems[i]=0
      i++
    }
    print("End of round ",round)
    max1=0
    max2=0
    for (x in items) {
      printf("%s:",x)
      y=0
      while (y++ < numitems[x]) {
        printf(" %s",items[x][y])
      }
      printf(" - num inspections: %s\n", numinsp[x])
      if (numinsp[x] > max1) {
        if (max1 > 0) {
          max2 = max1
        }
        max1 = numinsp[x]
      } else {
        if (numinsp[x] > max2) {
          max2 = numinsp[x]
        }
      }
    }
    printf("Most active monkeys inspections: %s * %s = %s\n",max1,max2,max1*max2)
  }
}
#   Monkey inspects an item with a worry level of 98.
#     Worry level is multiplied by 19 to 1862.
#     Monkey gets bored with item. Worry level is divided by 3 to 620.
#     Current worry level is not divisible by 23.
#     Item with worry level 620 is thrown to monkey 3.
# Monkey 1:
#   Monkey inspects an item with a worry level of 54.
#     Worry level increases by 6 to 60.
#     Monkey gets bored with item. Worry level is divided by 3 to 20.
#     Current worry level is not divisible by 19.
#     Item with worry level 20 is thrown to monkey 0.
#   Monkey inspects an item with a worry level of 65.
#     Worry level increases by 6 to 71.
#     Monkey gets bored with item. Worry level is divided by 3 to 23.
#     Current worry level is not divisible by 19.
#     Item with worry level 23 is thrown to monkey 0.
#   Monkey inspects an item with a worry level of 75.
#     Worry level increases by 6 to 81.
#     Monkey gets bored with item. Worry level is divided by 3 to 27.
#     Current worry level is not divisible by 19.
#     Item with worry level 27 is thrown to monkey 0.
#   Monkey inspects an item with a worry level of 74.
#     Worry level increases by 6 to 80.
#     Monkey gets bored with item. Worry level is divided by 3 to 26.
#     Current worry level is not divisible by 19.
#     Item with worry level 26 is thrown to monkey 0.
# Monkey 2:
#   Monkey inspects an item with a worry level of 79.
#     Worry level is multiplied by itself to 6241.
#     Monkey gets bored with item. Worry level is divided by 3 to 2080.
#     Current worry level is divisible by 13.
#     Item with worry level 2080 is thrown to monkey 1.
#   Monkey inspects an item with a worry level of 60.
#     Worry level is multiplied by itself to 3600.
#     Monkey gets bored with item. Worry level is divided by 3 to 1200.
#     Current worry level is not divisible by 13.
#     Item with worry level 1200 is thrown to monkey 3.
#   Monkey inspects an item with a worry level of 97.
#     Worry level is multiplied by itself to 9409.
#     Monkey gets bored with item. Worry level is divided by 3 to 3136.
#     Current worry level is not divisible by 13.
#     Item with worry level 3136 is thrown to monkey 3.
# Monkey 3:
#   Monkey inspects an item with a worry level of 74.
#     Worry level increases by 3 to 77.
#     Monkey gets bored with item. Worry level is divided by 3 to 25.
#     Current worry level is not divisible by 17.
#     Item with worry level 25 is thrown to monkey 1.
#   Monkey inspects an item with a worry level of 500.
#     Worry level increases by 3 to 503.
#     Monkey gets bored with item. Worry level is divided by 3 to 167.
#     Current worry level is not divisible by 17.
#     Item with worry level 167 is thrown to monkey 1.
#   Monkey inspects an item with a worry level of 620.
#     Worry level increases by 3 to 623.
#     Monkey gets bored with item. Worry level is divided by 3 to 207.
#     Current worry level is not divisible by 17.
#     Item with worry level 207 is thrown to monkey 1.
#   Monkey inspects an item with a worry level of 1200.
#     Worry level increases by 3 to 1203.
#     Monkey gets bored with item. Worry level is divided by 3 to 401.
#     Current worry level is not divisible by 17.
#     Item with worry level 401 is thrown to monkey 1.
#   Monkey inspects an item with a worry level of 3136.
#     Worry level increases by 3 to 3139.
#     Monkey gets bored with item. Worry level is divided by 3 to 1046.
#     Current worry level is not divisible by 17.
#     Item with worry level 1046 is thrown to monkey 1.
