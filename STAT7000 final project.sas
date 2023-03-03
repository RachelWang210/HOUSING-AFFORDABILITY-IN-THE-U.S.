
proc import out=ice 
 datafile='I:\1Mine\stat7000\icecream (1).csv' 
 dbms=csv replace;
run;

/*question 1*/
/*Mean Std CI*/
proc means MaxDec=4 data=ice mean std clm ;
 var price;
 by year;
run;

/*box-plot*/
proc sgplot data=ice;
 vbox price/ category= year;
run;

/*ANOVA. diagnostice and tukey*/
proc glm data = ice plots=diagnostics; 
 class year; 
 model price = year;
 means year/tukey cldiff;
 lsmeans year / adj=tukey tdiff pdiff=all;
run;

quit;

/*compare*/
proc glm data=ice;
 class year;
 model price=year /clparm;
 estimate 'test' year -1 2 -1;
run;

/*question 2*/
/**scattor plot*/
proc sgplot data =ice; 
reg y= consumption x=temp/group=year ; 
run;

/*dummy*/
data ice1;
 set ice;
 if year='1' then year1=1; else year1=0;
 if year='2' then year2=1; else year2=0;
run;

/*linear regression*/
proc reg data=ice1;
 model consumption=temp year1 year2/clb;
run;
quit;

/*interact*/
data ice2;
 set ice1;
 temyear1=temp*year1;
 temyear2=temp*year2;
run;

/*new linear regression*/
proc reg data=ice2;
 model consumption=temp year1 year2 temyear1 temyear2/clb;
run;
quit;

/*f intercection better?*/
proc reg data=ice2;
 model consumption=temp year1 year2 temyear1 temyear2/clb;
 test temyear1=0,temyear2=0;
run;
quit;

/*full and reduce model*/
proc reg data=ice1;
 model consumption =temp year/clb;
run;
quit;
/*F-value*/
data one;
 p=1-cdf('f',3.061,1,26);
run;
proc print data=one;
run;

/*question 3*/
data ice3;
 set ice;
 prin=price*income;
 prtem=price*temp;
 prye=price*year;
 intem=income*temp;
 inyea=income*year;
 temye=temp*year;
run;

/*regression*/
proc reg data=ice3;
 model consumption =price income temp year prin 
prtem prye intem inyea temye/clb;
run;
quit;

/*backward elimination*/
proc reg data =ice3;
 model consumption =price income temp year 
prin prtem prye intem inyea temye
/selection = backward slentry =0.05 slstay=0.05;
run;
/*regression*/
proc reg data=ice3;
 model consumption =  temp year prye   /clb;
run;
quit;

/*stepwise*/
proc reg data =ice3;
 model consumption =price income temp year 
prin prtem prye intem inyea temye
/selection = stepwise slentry =0.05 slstay=0.05;
run;
/*regression*/
proc reg data=ice3;
 model consumption =  intem temye/clb;
run;
quit;

/*compare*/
/*F-value*/
data two;
 p=1-cdf('f',7.248,1,26);
run;
proc print data=two;
run;

