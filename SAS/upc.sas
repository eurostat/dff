libname dff v6 "C:\Data";

data work.upc;
	CAT="ANA";
	set dff.upcana;
run;

data work.upc1;
	CAT="BAT";
	set dff.upcbat;
run;

proc append
	base=work.upc
	data=work.upc1;
run;

data work.upc1;
	CAT="BER";
	set dff.upcber;
run;

proc append
	base=work.upc
	data=work.upc1;
run;

data work.upc1;
	CAT="BJC";
	set dff.upcbjc;
run;

proc append
	base=work.upc
	data=work.upc1;
run;

data work.upc1;
	CAT="CSO";
	set dff.upccso;
run;

proc append
	base=work.upc
	data=work.upc1;
run;

data work.upc1;
	CAT="TNA";
	set dff.upctna;
run;

proc append
	base=work.upc
	data=work.upc1;
run;

data work.upc1;
	CAT="CER";
	set dff.upccer;
run;

proc append
	base=work.upc
	data=work.upc1;
run;

data work.upc1;
	CAT="CIG";
	set dff.upccig;
run;

proc append
	base=work.upc
	data=work.upc1;
run;

data work.upc1;
	CAT="CHE";
	set dff.upcche;
run;

proc append
	base=work.upc
	data=work.upc1;
run;

data work.upc1;
	CAT="COO";
	set dff.upccoo;
run;

proc append
	base=work.upc
	data=work.upc1;
run;

data work.upc1;
	CAT="CRA";
	set dff.upccra;
run;

proc append
	base=work.upc
	data=work.upc1;
run;

data work.upc1;
	CAT="DID";
	set dff.upcdid;
run;

proc append
	base=work.upc
	data=work.upc1;
run;

data work.upc1;
	CAT="FSF";
	set dff.upcfsf;
run;

proc append
	base=work.upc
	data=work.upc1;
run;

data work.upc1;
	CAT="FEC";
	set dff.upcfec;
run;

proc append
	base=work.upc
	data=work.upc1;
run;

data work.upc1;
	CAT="FRD";
	set dff.upcfrd;
run;

proc append
	base=work.upc
	data=work.upc1;
run;

data work.upc1;
	CAT="FRE";
	set dff.upcfre;
run;

proc append
	base=work.upc
	data=work.upc1;
run;

data work.upc1;
	CAT="FRJ";
	set dff.upcfrj;
run;

proc append
	base=work.upc
	data=work.upc1;
run;

data work.upc1;
	CAT="GRO";
	set dff.upcgro;
run;

proc append
	base=work.upc
	data=work.upc1;
run;

data work.upc1;
	CAT="LND";
	set dff.upclnd;
run;

proc append
	base=work.upc
	data=work.upc1;
run;

data work.upc1;
	CAT="OAT";
	set dff.upcoat;
run;

proc append
	base=work.upc
	data=work.upc1;
run;

data work.upc1;
	CAT="PTW";
	set dff.upcptw;
	*;
	drop WSTART;
	*;
run;

proc append
	base=work.upc
	data=work.upc1;
run;

data work.upc1;
	CAT="RFJ";
	*;
	*set dff.upcrfj;
	*;
	length DESCRIP $ 20 SIZE $ 6;
	infile "C:\Data\upcrfj.csv" dlm=",";
	input UPC DESCRIP $ SIZE $;
run;

proc append
	base=work.upc
	data=work.upc1;
run;

data work.upc1;
	CAT="SOA";
	set dff.upcsoa;
run;

proc append
	base=work.upc
	data=work.upc1;
run;

data work.upc1;
	CAT="SDR";
	set dff.upcsdr;
run;

proc append
	base=work.upc
	data=work.upc1;
run;

data work.upc1;
	CAT="SHA";
	set dff.upcsha;
run;

proc append
	base=work.upc
	data=work.upc1;
run;

data work.upc1;
	CAT="SNA";
	set dff.upcsna;
run;

proc append
	base=work.upc
	data=work.upc1;
run;

data work.upc1;
	CAT="TBR";
	set dff.upctbr;
run;

proc append
	base=work.upc
	data=work.upc1;
run;

data work.upc1;
	CAT="TPA";
	set dff.upctpa;
run;

proc append
	base=work.upc
	data=work.upc1;
run;

data work.upc1;
	CAT="TTI";
	set dff.upctti;
run;

proc append
	base=work.upc
	data=work.upc1;
run;

libname dff clear;
libname dff v9 "C:\Data";

data dff.upc;
	set work.upc;
	drop DESCRIP SIZE CASE;
run;