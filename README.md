# Advent of Code
How to invoke shown below per day
## Day 1
part 1

```gawk -f day1-puzzle1.awk day1-input```

part 2

```gawk -f day1-puzzle2.awk day1-input | tail```


## Day 2
part 1

```gawk -f day2-puzzle1.awk day2-input | tail```

part 2

```$ gawk -f day2-puzzle2.awk day2-input | tail```


## Day 3
part 1

```
gawk -f day3-puzzle1.awk day3-puzzle-input | \
  od -t d1 -v -w2 | \
  gawk -f day3-puzzle1-part2.awk | \
  tail
```

part 2

```
gawk -f day3-puzzle2.awk day3-puzzle-input | \
  gawk -f day3-puzzle2-part2.awk | \
  cut -d' ' -f1-2 | sort -nu | awk '{ print $2; }' | \
  od -t d1 -v -w2 | gawk -f day3-puzzle1-part2.awk| tail
```


## Day 4
part 1

```
gawk -f day4-puzzle1.awk day4-input | tail
```

part 2

```
gawk -f day4-puzzle2.awk day4-input | tail
```


## Day 5
part 1

```
gawk -f day5-p1.awk day5-input | tail
```

part 2

```
gawk -f day5-p2.awk day5-input | tail
```

## Day 6
part 1

```
gawk -f day6-p1.awk day6-input | tail
```

part 2

```
gawk -f day6-p2.awk day6-input | tail
```

## Day 7
part 1

```
gawk -f day7-p1.awk day7-input | tail -n3 | head -n1
```

part 2
```
gawk -f day7-p1.awk day7-input | tail -n1
```

## Day 8
part 1

```
gawk -f day8.awk day8-input | tail
```

part 2

```
gawk -f day8-p2.awk day8-input | tail
```

## Day 9
part 1

```
gawk -f day9.awk day9-input | tail
```

part 2

```
gawk -v rl=9 -f day9.awk day9-input | tail
```

## Day 10
part 1

```
gawk -f day10.awk day10-input | tail
```

part 2

```
gawk -v part=2 -f day10.awk day10-input | tail
```

## Day 11
part 1

```
gawk -f day11.awk day11-input | tail
```

part 2

```
gawk -v part=2 -f day11.awk day11-input | tail
```

## Day 12
part 1

```
gawk -f day12.awk day12-input | tail
```

part 2

It takes a while, but it finally shows output:

```
gawk -v part=2 -f day12.awk day12-input | grep ' steps led trail' | sort -nr | tail
```

## Day 13
part 1

```
gawk -f day13.awk day13-input | tail
```

part 2

This one also takes a couple of seconds:

```
gawk -v part=2 -f day13.awk day13-input | tail
```

## Day 14
part 1

```
gawk -f day14.awk day14-input | tail
```

part 2

```
gawk -f day14-p2.awk day14-input | tail
```

## Day 15
part 1

```
gawk -v part=1 -v row=2000000 -f day15-v2.awk day15-input
```

part 2

```
gawk -v part=2 -f day15-v2.awk day15-input
```

Took 3'50" on my system.
