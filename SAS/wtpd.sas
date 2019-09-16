libname dff v9 "C:\Data";

*AGGREGATION;

proc summary data=dff.move nway;
	class CAT COM_CODE MONTH /*MONTH1 WEEK WEEK1*/ /*PRICE_TIER ZONE STORE*/ NITEM /*UPC*/ /*SALE*/;
	output out=work.move_monthly0(drop=_type_ _freq_)
	sum(MOVE)= sum(SALES)=;
run;

data work.move_monthly;
	set work.move_monthly0;
	where MONTH>="01OCT1989"d and MONTH<="01APR1997"d;
run;

/*

*EXPORT;

proc export data=work.move_monthly
	outfile="C:\Data\move_monthly.csv"
	dbms=csv replace;
run;

*/

*UNIT VALUES;

data work.move_monthly;
	set work.move_monthly;
	PRICE=SALES/MOVE;
	LOGPRICE=log(PRICE);
run;

proc sort data=work.move_monthly;
	by CAT MONTH;
run;

*EXPENDITURE SHARES;

proc summary data=work.move_monthly nway;
	class CAT MONTH;
	output out=work.move_monthly1(drop=_type_ _freq_)
	sum(SALES)=TOTAL;
run;

data work.move_monthly;
	merge work.move_monthly work.move_monthly1;
	by CAT MONTH;
	SHARE=SALES/TOTAL;
run;

*MONTH INDEX;

proc sort data=work.move_monthly;
	by MONTH;
run;

data work.move_monthly;
	set work.move_monthly;
	by MONTH;
	if first.MONTH then MONTH2+1;
run;

*ITEM INDEX;

proc sort data=work.move_monthly;
	by CAT COM_CODE NITEM;
run;

data work.move_monthly;
	set work.move_monthly;
	by CAT COM_CODE NITEM;
	if first.NITEM then NITEM2+1;
run;

*REGRESSION;

proc sort data=work.move_monthly;
	by CAT MONTH2 NITEM2;
run;

proc glm data=work.move_monthly;
	class MONTH2 NITEM2;
	model LOGPRICE=MONTH2 NITEM2 / solution;
	by CAT;
	weight SHARE;
	ods output ParameterEstimates=work.wtpd(keep=CAT Parameter Estimate StdErr);
run;
quit;

*PRICE INDICES;

data work.wtpd1;
	set work.wtpd;
	where substr(Parameter,1,6)='MONTH2';
	Estimate=exp(Estimate);
	MONTH2=input(substr(Parameter,11,2),8.);
	drop Parameter;
run;

proc sort data=work.wtpd1;
	by MONTH2;
run;

proc transpose data=work.wtpd1(drop=StdErr) out=work.wtpd1(drop=_name_ _label_);
	by MONTH2;
	id CAT;
run;

*HETEROGENEITY;

data work.wtpd0;
	set work.wtpd;
	where substr(Parameter,1,6)='NITEM2';
	NITEM2=input(substr(Parameter,11,5),8.);
	drop Parameter;
run;

proc summary data=work.wtpd0 nway;
	class CAT;
	output out=work.wtpd2(drop=_type_ _freq_)
	n(NITEM2)= stddev(Estimate)=STDDEV kurtosis(Estimate)=KURTOSIS;
run;

data work.wtpd2;
	set work.wtpd2;
	Estimate=STDDEV/sqrt((NITEM2-1.5-KURTOSIS/4)/(NITEM2-1));
	drop STDDEV KURTOSIS;
run;
