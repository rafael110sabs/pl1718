BEGIN{id=1; FS="\n"; RS="\n\n"}
{
  printf "%s ", $2;
  printf "%s", $3;
  for(i = 4; i <= NF; i++){
    printf " | %s",$i;
  }
  print ""
}
END{}
