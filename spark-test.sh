#!/usr/bin/env roundup

describe "spark: Generates sparklines for a set of data."

spark="./spark"

it_graphs_argv_data() {
  graph="$($spark 1,5,22,13,5)"

  test $graph = '▁▂▇▄▂'
}

it_charts_pipe_data() {
  data="0,30,55,80,33,150"
  graph="$(echo $data | $spark)"

  test $graph = '▁▂▃▄▂▇'
}

it_charts_spaced_data() {
  data="0 30 55 80 33 150"
  graph="$($spark $data)"

  test $graph = '▁▂▃▄▂▇'
}

it_charts_way_spaced_data() {
  data="0 30               55 80 33     150"
  graph="$($spark $data)"

  test $graph = '▁▂▃▄▂▇'
}

# tests to make sure decimal inputs are handled properly
it_handles_decimals() {
  data="5.5,20"
  graph="$($spark $data)"

  test $graph = '▁▇'

  test $($spark '1,1.2,1.6,2.2,2.6,7') = '▁▁▂▂▃▇'
  test $($spark '0.1,0.2,0.3,0.4,0.5,0.6,0.7') = '▁▂▃▄▅▆▇'
}

# tests of various staircase patterns
it_charts_sequence() {
  res='▁▂▃▄▅▆▇'
  data="1,2,3,4,5,6,7"
  test $(echo $data | $spark) = $res
  data="2,3,4,5,6,7,8"
  test $(echo $data | $spark) = $res
  data="10,11,12,13,14,15,16"
  test $(echo $data | $spark) = $res
  data="10,20,30,40,50,60,70"
  test $(echo $data | $spark) = $res
  data="12,22,32,42,52,62,72"
  test $(echo $data | $spark) = $res
}

# tests of -z command-line flag
it_zero_baseline() {
  data='100,101,102,103,104,105,106'
  test $(echo $data | $spark)    = '▁▂▃▄▅▆▇'
  test $(echo $data | $spark -z) = '▇▇▇▇▇▇▇'

  data='5,6,7'
  test $(echo $data | $spark)    = '▁▄▇'
  test $(echo $data | $spark -z) = '▅▆▇'  
}

# tests for when min=max
it_zero_range() {
  test $($spark '1,1,1,1')    = '▁▁▁▁'
  test $($spark '53')         = '▁'
  test $($spark -z '1,1,1,1') = '▇▇▇▇'
  test $($spark -z '53')      = '▇'
  test $($spark '0,0,0,0')    = '▁▁▁▁'
  test $($spark '0')          = '▁'
}

it_charts_100_lt_300() {
  data="1,2,3,4,100,5,10,20,50,300"
  graph="$($spark $data)"

  test $graph = '▁▁▁▁▃▁▁▁▂▇'
}

it_charts_50_lt_100() {
  data="1,50,100"
  graph="$($spark $data)"

  test $graph = '▁▄▇'
}

it_charts_4_lt_8() {
  data="2,4,8"
  graph="$($spark -z $data)"

  test $graph = '▂▄▇'

}

it_charts_no_tier_0() {
  data="1,2,3,4,5"
  graph="$($spark -z $data)"

  test $graph = '▁▂▃▄▅'

}
