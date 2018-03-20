
function f(t){
  t*scale-shift
  return t;
}

BEGIN{ if(ARGC==7){ ARGC=8; ARGV[7]=ARGV[6]}
      else { print "usage: alinha i1=3 i2=6 f1=30 f2=60 a.srt b.srt\n"; }
      FS="\n"; RS="\n\n"
}
{

  if( $1 == 1){
    file++;
  }

  if(file == 1){
    if($1 == i1){
      #Separar os timestamps do record
      split($2, a, " --> ");

      #Guardar o timestamp de aparecer
      startStamp=a[1];

      #obter os segundos de aparecer
      split(startStamp, z, ":");
      split(z[3], sa, ",");
      i1_time = (z[1]*3600 + z[2] * 60 + sa[1] + sa[2]*0.001) * 1000;

    } else if( $1 == f1){
      #Separar os timestamps do record
      split($2, a, " --> ");

      #Guardar o timestamp de aparecer
      startStamp=a[1];

      #obter os segundos de aparecer
      split(startStamp, z, ":");
      split(z[3], sa, ",");
      f1_time = (z[1]*3600 + z[2] * 60 + sa[1] + sa[2]*0.001) * 1000;
      dur1 = f1_time - i1_time;
    }
  }

  if(file == 2){
    if($1 == i2){
      #Separar os timestamps do record
      split($2, a, " --> ");

      #Guardar o timestamp de aparecer
      startStamp=a[1];

      #obter os segundos de aparecer
      split(startStamp, z, ":");
      split(z[3], sa, ",");
      i2_time = (z[1]*3600 + z[2] * 60 + sa[1] + sa[2]*0.001) * 1000;

    } else if( $1 == f2){
      #Separar os timestamps do record
      split($2, a, " --> ");

      #Guardar o timestamp de aparecer
      startStamp=a[1];

      #obter os segundos de aparecer
      split(startStamp, z, ":");
      split(z[3], sa, ",");
      f2_time = (z[1]*3600 + z[2] * 60 + sa[1] + sa[2]*0.001) * 1000;
      dur2 = f2_time - i2_time;
    }
  }

  if(file == 3){ #Se for o ultimo ficheiro
    scale= dur1/dur2;
    shift = i2_time *scale - i1_time;

    #Separar os timestamps do record
    split($2, a, " --> ");

    #Guardar o timestamp de aparecer
    startStamp=a[1];

    #obter os segundos de aparecer
    split(startStamp, z, ":");
    split(z[3], sa, ",");
    totalMiliSeconds = (z[1]*3600 + z[2] * 60 + sa[1])*1000 + sa[2];



    #Calcular novo tempo
    calculated = totalMiliSeconds*scale - shift;
    newStartTime = calculated / 1000;

    newStartHour = int(newStartTime / 3600);
    newStartMinutes = int((newStartTime - (newStartHour*3600)) / 60);
    newStartSeconds = ((newStartTime - (newStartHour*3600)) - (newStartMinutes * 60));
    newStartMili = (newStartSeconds - int(newStartSeconds))*1000;

    #Obter os timestamp de desaparecer
    endStamp=a[2];
    split(endStamp, b, ":");
    split(b[3], s, ",");
    totalMiliSeconds = (b[1]*3600 + b[2] * 60 + s[1])*1000 + s[2];

    #Calcular novo tempo
    calculated = totalMiliSeconds*scale - shift;
    newEndTime = calculated/1000;

    newEndHour = int(newEndTime / 3600);
    newEndMinutes = int((newEndTime - (newEndHour*3600)) / 60);
    newEndSeconds = ((newEndTime - (newEndHour*3600)) - (newEndMinutes * 60));
    newEndMili = (newEndSeconds - int(newEndSeconds))*1000;

    print $1;
    printf "%02d:%02d:%02d,%03.0f --> %02d:%02d:%02d,%03.0f\n", newStartHour, newStartMinutes, newStartSeconds, newStartMili, newEndHour, newEndMinutes, newEndSeconds, newEndMili;
    for(i = 3; i <= NF; i++){
      print $i
    }

    print "";


  }

}
END{ }

# hh:mm:ss -> hh * 3600s + mm * 60s + ss = segundos totais
# segundos totais / 3600 = hh
# segundos totais - (hh*3600) = mm
# mm*60
#
# 5h:20m:30 = 19230
