INPUT
	PUBLICID		$1-14 	/* PUBLICID IS THE PUBLIC-USE ID FOR NHIS AND LSOA II */
	
	ELIGSTAT		15
	MORTSTAT		16
	CAUSEAVL		17
	UCOD_LEADING	$18-20
	DIABETES		21
	HYPERTEN		22
	

	DODQTR			23		/*NHIS AND LSOA II ONLY*/
	DODYEAR			24-27	/*NHIS AND LSOA II ONLY*/
	WGT_NEW			28-35	/*NHIS ONLY*/
	SA_WGT_NEW		36-43 	/*NHIS ONLY*/
	
	MORTSRCE_NDI	50
	MORTSRCE_CMS	51
	MORTSRCE_SSA	52
	MORTSRCE_DC		53
	MORTSRCE_DCL	54
     ;
/* END READ INPUT */

PROC FORMAT;
  VALUE ELIGFMT
    1 = "Eligible"
    2 = "Under age 18"
    3 = "Ineligible" ;

  VALUE MORTFMT
    0 = "Assumed alive"
    1 = "Assumed deceased"
    . = "Ineligible or under age 18";

  VALUE MRSRCFMT
  	1 = "Yes";

 VALUE CAUSEFMT
  	0 = "No"
	1 = "Yes"
	. = "Ineligible, under age 18 or assumed alive";

  VALUE FLAGFMT
    0 = "No"
    1 = "Yes"  
    . = "Ineligible, under age 18, assumed alive or no cause data";

  VALUE QRTFMT
    1 = "January - March"
    2 = "April   - June"
    3 = "July    - September"
    4 = "October - December" 
    . = "Ineligible, under age 18 or assumed alive";

  VALUE DODYFMT
    . = "Ineligible, under age 18 or assumed alive";
RUN ;
/* END PROC FORMAT */

FORMAT    
	ELIGSTAT 		ELIGFMT.          
	MORTSTAT 		MORTFMT.
	MORTSRCE_NDI 	MRSRCFMT.
	MORTSRCE_CMS 	MRSRCFMT.
	MORTSRCE_SSA 	MRSRCFMT.
	MORTSRCE_DC 	MRSRCFMT.
	MORTSRCE_DCL 	MRSRCFMT.
	
	CAUSEAVL 		CAUSEFMT.
	DODQTR   		QRTFMT.           
	DODYEAR  		DODYFMT.
	DIABETES 		FLAGFMT.          
	HYPERTEN 		FLAGFMT. 
     	;
RUN;
/* FMT END */


