declare variable $x external;

for $i in //term[key=$x and not(empty(sound))]
order by data($i/o[1])
return concat( "mpg123 -q audio/", data($i/sound[1]/@file),
  " ; sleep 1; flite -t '", data($i/d[1]), "' ; sleep 1") 
  