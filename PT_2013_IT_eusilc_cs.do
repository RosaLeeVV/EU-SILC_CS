/* PT_2013_IT_eusilc_cs */


* ITALY - 2013

* ELIGIBILITY
/*	-> employed (LP&R 2013; MISSOC 2013 understands paternity leave to also 
		be the maternity leave entitlements that cannot be used by mother) 		*/
		
replace pt_eli = 1 		if country == "IT" & year == 2013 & gender == 2 ///
						& econ_status == 1
replace pt_eli = 0 		if pt_eli == . & country == "IT" & year == 2013 & gender == 2


* DURATION (weeks)
/*	-> 3 days */

replace pt_dur = 3/5 	if country == "IT" & year == 2013 & pt_eli == 1


* BENEFIT (monthly)
/*	-> 80% earning */
replace pt_ben1 = 0.8*earning 	if country == "IT" & year == 2013 & pt_eli == 1
replace pt_ben2 = 0.8*earning 	if country == "IT" & year == 2013 & pt_eli == 1


foreach x in 1 2 {
	replace pt_ben`x' = 0 	if pt_eli == 0 & country == "IT" & year == 2013
}

replace pt_dur = 0 if pt_eli == 0 & country == "IT" & year == 2013
