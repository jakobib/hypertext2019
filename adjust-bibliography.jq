#!/usr/bin/env jq

# for all records
.[] |= 

# Limit date to year if it's first of January
if (.issued["date-parts"][0][1:] == [1,1]) then
  .issued["date-parts"][0] = .issued["date-parts"][0][:1]
else
  .
end
