/* PT_2012_EE_eusilc_cs */

* ESTONIA - 2012

* ELIGIBILITY
/*	-> employed (coded) fathers with permanent contract (MISSOC 01/07/2012; not coded) */ 

replace pt_eli = 1 		if country == "EE" & year == 2012 & gender == 2 ///
						& econ_status == 1
replace pt_eli = 0 		if pt_eli == . & country == "EE" & year == 2012


* DURATION (weeks)
/*	-> 10 woring days */

replace pt_dur = 10/5 	if country == "EE" & year == 2012 & pt_eli == 1


* BENEFIT (monthly)
/*	-> no payment		*/
	
replace pt_ben1 = earning 	if country == "EE" & year == 2012 & pt_eli == 1
							


foreach x in 1 2 {
	replace pt_ben`x' = 0 	if pt_eli == 0 & country == "EE" & year == 2012
}

replace pt_dur = 0 if pt_eli == 0 & country == "EE" & year == 2012
