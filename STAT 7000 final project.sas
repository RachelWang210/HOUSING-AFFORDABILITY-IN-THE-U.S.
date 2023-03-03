/*import data*/
proc import out=house
 datafile="I:\project\7000\house.xlsx"
 dbms=xlsx;
run;

/*remove all labels*/

/*add dummy variables*/
data house1;
 set house;
 attrib _all_ label='';
 if loc='Central City' then loca=0;
 if loc='Suburb' then loca=1;
 if loc='Nonmetro' then loca=2;
 if cond='1 Adequate' then condi=0;
 if cond='2 Moderately Inadequate' then condi=1;
 if cond='3 Severely Inadequate' then condi=2;
 if cond='Vacant--no information' then condi=3;
run;

/*get only 200 obs*/
data house2;
 set house1;
 RowNumber=_n_;
run;

/*randomly choose 300 samples*/
data house3;
 set house2;
 where rownumber<=300;
run;

/*scatter plot*/
proc sgscatter data=house3;
 matrix value year nroom loca condi ins inc/
 diagonal=(histogram normal);
run;

/*linear regression*/
proc reg data=house3;
 model value = year nroom loca condi ins inc / clb;
run;
quit;

/*backward analysis*/
proc reg data=house3;
 model value = year nroom loca condi ins inc /
 selection = backward slentry= 0.05 slstay=0.05;
run;

/*correlation*/
proc corr data =house3;
 var value year nroom loca condi ins inc;
run;

/*new variable*/
data house4;
 set house3;
 Yearo = Year * Nroom;
 Yearis = Year * Ins;
 Roinc = Nroom * Inc;
 Locins = Loca * Ins;
 Insinc = Ins * Inc;
run; 

/*new model*/
proc reg data=house4;
 model value = year nroom loca condi ins inc
               yearo yearis roinc locins insinc /clb;
run;
quit;

/*backward*/
proc reg data=house4;
 model value = year nroom loca condi ins inc
               yearo yearis roinc locins insinc 
               /selection = backward slentry=0.05 slstay=0.05;
run;
quit;


/*remove insignificant variables*/
proc reg data=house4;
 model value = condi inc
               yearo yearis insinc/ clb noint;
run;
quit;








