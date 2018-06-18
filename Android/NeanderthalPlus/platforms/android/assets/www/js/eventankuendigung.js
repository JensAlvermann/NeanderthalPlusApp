// Auf der Basis von www.web-toolbox.net


// Tabellenbreite in Prozent)
var TabellenBreite = "100";


// Zeilenh�he in Pixel
var ZeilenHoehe = "60";

// ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
// :::::::::::::::: Anpassungen Ende ::::::::::::::::::::::::::




// diese Variablen nicht �ndern

var TabFormat = 'style="width:' + TabellenBreite + '%;"';
var CountTermine = 0;
var Anzahl = "";
var Tage;
var WochenTag = "Mo"

var ArrayTage = new Array
("So.","Mo.","Di.","Mi.","Do.","Fr.","Sa.");

// abh�ngig von Tageszahl Text zusammenstellen
function Abstand(Tage) {
  if (Tage < -1) {
  Anzahl = "vor " + StrTage + " Tagen";
  }
  if(Tage == -1) {
  Anzahl = "vor " + StrTage + " Tag";
  }
  if(Tage == 0) {
  Anzahl = "Heute ";
  }
  if(Tage == 1) {
  Anzahl = "Morgen ";
  }
  if(Tage == 2) {
  Anzahl = "&uuml;bermorgen ";
  }
  if(Tage > 2) {
  Anzahl = "in " + Tage + " Tagen";
  }
return Anzahl;
}

// Hintergrundfarbe + Grafik ausw�hlen
function FarbeGrafik(Tage) {

   if(Tage < 0)
   {
   document.write("<tr bgcolor='#404040'>");
   document.write('<td><img src="../symb/cal_weiss.svg" width="14" height="16" border="0" alt=""></td>');
   }
   else if(Tage == 0)
   {
   document.write("<tr bgcolor='#00305d' valign='top'>");
   document.write('<td><img src="../symb/cal_weiss_heute.svg" width="30" height="30" border="0" alt="" style="padding-top: 9px"></td>');
   }
   else if(Tage < 20 && Tage > 0)
   {
   document.write("<tr bgcolor='#404040' valign='top'>");
   document.write('<td><img src="../symb/cal_weiss.svg" width="30" height="30" border="0" alt="" style="padding-top: 9px"></td>');
   }
   else
   {
   document.write("<tr bgcolor='#404040' valign='top'>");
   document.write('<td><img src="../symb/cal_weiss.svg" width="30" height="30" border="0" alt="" style="padding-top: 9px"></td>');
   }

return
}



function ZeileSchreiben(Tage) {
      var Monat = DatumTermin2.getMonth() +1;
      Monat = ((Monat < 10) ? "0" : "")+ Monat;
      var Monatstag = DatumTermin2.getDate();
      Monatstag = ((Monatstag < 10) ? "0" : "")+ Monatstag;

      var WochenTag = DatumTermin2.getDay();
      Abstand(Tage);
      FarbeGrafik(Tage);


      
      document.write("<td style='padding-top: 10px' height='" + ZeilenHoehe + "'>" + Anzahl + "<br>" + Monatstag + "." + Monat + "." + DatumTermin2.getFullYear() + "</td>");


      document.write("<td>" + Termin[i+1] + "</td></tr>");
      CountTermine++;
return
}




// Termine - abh�ngig von den Variablen 'WelcheTermine' + 'WieViele'

function Terminliste06(WelcheTermine,WieViele) {
CountTermine = "0";
var JetztTermin = new Date();

if(WieViele == "0") {
WieViele = "10000";
}

// einleitendes TABLE-Tag + Attribute schreiben
document.write('<table ' + TabFormat + '" id="rand06" cellspacing="0" cellpadding="5">');


// Liste abarbeiten
for (i=0; i < Termin.length; i++ )
{

  var DatumTermin = new Date(Termin[i]);
  DatumTermin2 =  new Date(DatumTermin);
  var Diff2 = DatumTermin2.getTime() - JetztTermin.getTime();
  var Tage = Math.floor(Diff2 / (1000 * 60 * 60 * 24));
  Tage = Tage +1;
  StrTage = Math.abs(Tage);


  if(WelcheTermine < "0" || WelcheTermine > "2")
  {
  alert("ung�ltige Vorgabe f�r den Typ der Terminliste");
  return;
  }

  if(WelcheTermine == "0") {
    if (i%2==0)
    {
    ZeileSchreiben(Tage);
    }
  }

  if(WelcheTermine == "2") {
    if (i%2==0  && Tage < 0)
    {
    ZeileSchreiben(Tage);
    }
  }

  if(WelcheTermine == "1") {
    if (i%2==0  && Tage >= 0 && CountTermine < WieViele)
    {
    ZeileSchreiben(Tage);
    }
  }

}


document.write("</table>");
return
}

