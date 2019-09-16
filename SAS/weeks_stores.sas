libname dff v9 "C:\Data";

*WEEKS & STORES;

data work.weeks;
	length WEEK 4;
	infile "C:\Data\weeks.csv" dlm="," dsd;
	input WEEK START :mmddyy8. END :mmddyy8. SPECIAL_EVENTS :$14.;
	MONTH=mdy(month(END),1,year(END));
	if month(START)=month(END) then MONTH1=MONTH;
	format START END mmddyy8. MONTH MONTH1 monyy7.;
run;

proc sort data=work.weeks;
	by MONTH1;
run;

data work.weeks;
	set work.weeks;
	by MONTH1;
	if first.MONTH1 then WEEK1=0;
	WEEK1+1;
	if MONTH1=. then WEEK1=.;
run;

proc sort data=work.weeks;
	by WEEK;
run;

data work.stores;
	length STORE 4;
	infile "C:\Data\stores.csv" dlm="," dsd;
	input STORE CITY :$22. PRICE_TIER :$10. ZONE ZIP_CODE ADDRESS :$23.;
run;

proc sort data=work.stores;
	by STORE;
run;

*MERGE W/ MOVE & UPC;

proc sort data=dff.upc
	out=work.upc;
	by CAT UPC;
run;

proc sort data=dff.move0
	out=work.move0;
	by WEEK;
run;

data work.move_weeks;
	merge work.move0(in=IN_MOVE) work.weeks;
	by WEEK;
	if IN_MOVE=1;
	drop START END SPECIAL_EVENTS;
run;

proc sort data=work.move_weeks;
	by STORE;
run;

data work.move_weeks_stores;
	merge work.move_weeks(in=IN_MOVE) work.stores/*(in=IN_STORES)*/;
	by STORE;
	if IN_MOVE=1 /*and IN_STORES=1*/;
	drop CITY ZIP_CODE ADDRESS;
run;

proc sort data=work.move_weeks_stores;
	by CAT UPC;
run;

data work.move_weeks_stores_upc;
	merge work.move_weeks_stores(in=IN_MOVE) work.upc/*(in=in_UPC)*/;
	by CAT UPC;
	if IN_MOVE=1 /*and IN_UPC=1*/;
run;

*REPLACE W/ DUMMIES;

data dff.move;
	set work.move_weeks_stores_upc;
	if NITEM=. or NITEM<0 then NITEM=UPC;
	if COM_CODE=. then COM_CODE=999;
	if PRICE_TIER='' then PRICE_TIER='N/A';
	if ZONE=. then ZONE=0;
	if SALE='' then SALE=0;
	else SALE=1;
run;