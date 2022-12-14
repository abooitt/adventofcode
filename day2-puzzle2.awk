BEGIN {
  score=0
}
  { 
    opponent = $1;
    me = $2;
    if (me == "X" ) { # loose
      score+=0;
      if (opponent == "A") score+=3; # rock defeats scissors
      if (opponent == "B") score+=1; # paper defeats rock
      if (opponent == "C") score+=2; # scissors defeats paper
    }
    if (me == "Y" ) { # draw
      score+=3;
      if (opponent == "A") score+=1;
      if (opponent == "B") score+=2;
      if (opponent == "C") score+=3;
    }
    if (me == "Z" ) { # win
      score+=6;
      if (opponent == "A") score+=2;
      if (opponent == "B") score+=3;
      if (opponent == "C") score+=1;
    }
    print(NR,opponent,me,score);
  }

