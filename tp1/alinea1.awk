BEGIN{endStampStamp=0; startStamp=0; lastSecond=0; thisSecond=0; id=1; FS="\n"; RS="\n\n"}
{

  #Separar os timestamps do record
  split($2, a, " --> ");

  #Guardar o timestamp de ela aparecer
  startStamp=a[1];

  #obter os segundos de aparecer
  split(startStamp, z, ":");
  split(z[3], sa, ",");
  thisSecond = sa[1];

  if(NR > 1) #Se já se encontrar no segundo record
    if( thisSecond - lastSecond >= 2) #Se começa depois de um silencia de 2 ou + segs
      print endStamp " --> " startStamp " =============================";

  endStamp=a[2];
  split(endStamp, b, ":");
  split(b[3], s, ",");

  lastSecond = s[1];
  printf "%s ", $2;
  printf "%s", $3;
  for(i = 4; i <= NF; i++){
    printf " | %s",$i;
  }
  print ""
}
endStamp{}
