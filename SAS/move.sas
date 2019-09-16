libname dff v6 "C:\Data";

data work.move;
	CAT="ANA";
	set dff.wana;
	SALES=PRICE*MOVE/QTY;
run;

data work.move1;
	CAT="BAT";
	set dff.wbat;
	SALES=PRICE*MOVE/QTY;
run;

proc append
	base=work.move
	data=work.move1;
run;

data work.move1;
	CAT="BER";
	set dff.wber;
	SALES=PRICE*MOVE/QTY;
run;

proc append
	base=work.move
	data=work.move1;
run;

data work.move1;
	CAT="BJC";
	set dff.wbjc;
	SALES=PRICE*MOVE/QTY;
run;

proc append
	base=work.move
	data=work.move1;
run;

data work.move1;
	CAT="CSO";
	set dff.wcso;
	SALES=PRICE*MOVE/QTY;
run;

proc append
	base=work.move
	data=work.move1;
run;

data work.move1;
	CAT="TNA";
	set dff.wtna;
	SALES=PRICE*MOVE/QTY;
run;

proc append
	base=work.move
	data=work.move1;
run;

data work.move1;
	CAT="CER";
	set dff.wcer;
	SALES=PRICE*MOVE/QTY;
run;

proc append
	base=work.move
	data=work.move1;
run;

data work.move1;
	CAT="CIG";
	set dff.wcig;
	SALES=PRICE*MOVE/QTY;
run;

proc append
	base=work.move
	data=work.move1;
run;

data work.move1;
	CAT="CHE";
	set dff.wche;
	SALES=PRICE*MOVE/QTY;
run;

proc append
	base=work.move
	data=work.move1;
run;

data work.move1;
	CAT="COO";
	set dff.wcoo;
	SALES=PRICE*MOVE/QTY;
run;

proc append
	base=work.move
	data=work.move1;
run;

data work.move1;
	CAT="CRA";
	set dff.wcra;
	SALES=PRICE*MOVE/QTY;
run;

proc append
	base=work.move
	data=work.move1;
run;

data work.move1;
	CAT="DID";
	set dff.wdid;
	SALES=PRICE*MOVE/QTY;
run;

proc append
	base=work.move
	data=work.move1;
run;

data work.move1;
	CAT="FSF";
	set dff.wfsf;
	SALES=PRICE*MOVE/QTY;
run;

proc append
	base=work.move
	data=work.move1;
run;

data work.move1;
	CAT="FEC";
	set dff.wfec;
	SALES=PRICE*MOVE/QTY;
run;

proc append
	base=work.move
	data=work.move1;
run;

data work.move1;
	CAT="FRD";
	set dff.wfrd;
	SALES=PRICE*MOVE/QTY;
run;

proc append
	base=work.move
	data=work.move1;
run;

data work.move1;
	CAT="FRE";
	set dff.wfre;
	SALES=PRICE*MOVE/QTY;
run;

proc append
	base=work.move
	data=work.move1;
run;

data work.move1;
	CAT="FRJ";
	set dff.wfrj;
	SALES=PRICE*MOVE/QTY;
run;

proc append
	base=work.move
	data=work.move1;
run;

data work.move1;
	CAT="GRO";
	set dff.wgro;
	SALES=PRICE*MOVE/QTY;
run;

proc append
	base=work.move
	data=work.move1;
run;

data work.move1;
	CAT="LND";
	set dff.wlnd;
	SALES=PRICE*MOVE/QTY;
run;

proc append
	base=work.move
	data=work.move1;
run;

data work.move1;
	CAT="OAT";
	set dff.woat;
	SALES=PRICE*MOVE/QTY;
run;

proc append
	base=work.move
	data=work.move1;
run;

data work.move1;
	CAT="PTW";
	set dff.wptw;
	SALES=PRICE*MOVE/QTY;
run;

proc append
	base=work.move
	data=work.move1;
run;

data work.move1;
	CAT="RFJ";
	set dff.wrfj;
	SALES=PRICE*MOVE/QTY;
run;

proc append
	base=work.move
	data=work.move1;
run;

data work.move1;
	CAT="SOA";
	set dff.wsoa;
	SALES=PRICE*MOVE/QTY;
run;

proc append
	base=work.move
	data=work.move1;
run;

data work.move1;
	CAT="SDR";
	set dff.wsdr;
	SALES=PRICE*MOVE/QTY;
run;

proc append
	base=work.move
	data=work.move1;
run;

data work.move1;
	CAT="SHA";
	set dff.wsha;
	SALES=PRICE*MOVE/QTY;
run;

proc append
	base=work.move
	data=work.move1;
run;

data work.move1;
	CAT="SNA";
	set dff.wsna;
	SALES=PRICE*MOVE/QTY;
run;

proc append
	base=work.move
	data=work.move1;
run;

data work.move1;
	CAT="TBR";
	set dff.wtbr;
	SALES=PRICE*MOVE/QTY;
run;

proc append
	base=work.move
	data=work.move1;
run;

data work.move1;
	CAT="TPA";
	set dff.wtpa;
	SALES=PRICE*MOVE/QTY;
run;

proc append
	base=work.move
	data=work.move1;
run;

data work.move1;
	CAT="TTI";
	set dff.wtti;
	SALES=PRICE*MOVE/QTY;
run;

proc append
	base=work.move
	data=work.move1;
run;

data work.move0;
	set work.move;
	where PRICE>0 and OK=1;
run;

libname dff clear;
libname dff v9 "C:\Data";

data dff.move0;
	set work.move0;
	drop PRICE QTY PROFIT OK;
run;