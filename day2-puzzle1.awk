BEGIN {
  score=0
}
  { 
    opponent = $1;
    me = $2;
    if (me == "X" ) { 
      score+=1;
      if (opponent == "A") score+=3;
      if (opponent == "B") score+=0;
      if (opponent == "C") score+=6;
    }
    if (me == "Y" ) { 
      score+=2;
      if (opponent == "A") score+=6;
      if (opponent == "B") score+=3;
      if (opponent == "C") score+=0;
    }
    if (me == "Z" ) { 
      score+=3;
      if (opponent == "A") score+=0;
      if (opponent == "B") score+=6;
      if (opponent == "C") score+=3;
    }
    print(NR,opponent,me,score);
  }

