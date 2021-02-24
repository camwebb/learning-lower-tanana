declare variable $x external;

for $i in //sound[@conv = $x]
order by $i/@part
return concat( "mpg123 -q audio/", data($i/@file), " ; sleep 1; flite -t '", data($i/../d[1]) , "' ; sleep 1") 
  