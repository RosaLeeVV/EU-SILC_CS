/* PT_2016_LT_eusilc_cs */


* LITHUANIA - 2016

* ELIGIBILITY
/*	-> employed, self-employed: for 12 months (coded) during past 2 years (not coded) */

replace pt_eli = 1 		if country == "LT" & year == 2016 & gender == 2 ///
						& inlist(econ_status,1,2) & (duremp+dursemp) >= 12


replace pt_eli = 0 		if pt_eli == . & country == "LT" & year == 2016 & gender == 2


* DURATION (weeks)
/*	-> 1 month */
replace pt_dur = 4.3 	if country == "LT" & year == 2016 & pt_eli == 1


* BENEFIT (monthly)
/*	-> 100% average earnings (MISSOC 07/2016)
	-> ceiling: €1,617.40/month (LP&R 2016)
*/
	
replace pt_ben1 = earning 	if country == "LT" & year == 2016 & pt_eli == 1 
							
replace pt_ben1 = 1617.40 	if country == "LT" & year == 2016 & pt_eli == 1 ///
							& pt_ben1 >= 1617.40	
							
replace pt_ben2 = pt_ben1  	if country == "LT" & year == 2016 & pt_eli == 1


foreach x in 1 2 {
	replace pt_ben`x' = 0 	if pt_eli == 0 & country == "LT" & year == 2016
}

replace pt_dur = 0 if pt_eli == 0 & country == "LT" & year == 2016
