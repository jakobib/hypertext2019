#!/usr/bin/jq -Mf

# walk was introduced after jq 1.5 so include it here
def walk(f):
  . as $in
  | if type == "object" then
      reduce keys_unsorted[] as $key
        ( {}; . + { ($key):  ($in[$key] | walk(f)) } ) | f
  elif type == "array" then map( walk(f) ) | f
  else f
  end;

# replace non-breaking spaces in metadata (CCS)
.meta |= walk( 
  if type == "object" and .t == "Str" then
    .c = (.c|sub(" "; " → "))
  else 
    .
  end
)
|

# move headers one level up
walk( 
  if type == "object" and .t == "Header" then
    .c[0] = .c[0] + 1
  else 
    .
  end
)
