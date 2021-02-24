declare variable $x external;

for $i in //term[key=$x]
order by data($i/o[1])
return concat( data($i/o[1]), " = ", data($i/d[1]) )

  (: run xq/list_o_by_key.xq greeting :)
  