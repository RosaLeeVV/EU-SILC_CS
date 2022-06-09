/* PT_2011_BE_eusilc_cs */


* Belgium - 2011

* ELIGIBILITY
/*	-> employed
*/
replace pt_eli = 1 		if country == "BE" & year == 2011 & gender == 2 ///
						& econ_status == 1
replace pt_eli = 0 		if pt_eli == . & country == "BE" & year == 2011 & gender == 2 


* DURATION (weeks)
/*	->  10 days		 */
replace pt_dur = 10/5 	if country == "BE" & year == 2011 & gender == 2 ///
						& pt_eli == 1


* BENEFIT (monthly)
/*	-> 100% earning for 3 days
	-> 82% of earnings for remaining 7 days
	-> to be used within 4 months from birth
*/
	


replace pt_ben1 = (earning * (3/21.7)) +(earning*0.82) * (7/21.7)) + (earning * ((21.7-10)/21.7)) ///
									if country == "BE" & year == 2011 ///
									& gender == 2  & pt_eli == 1					
									

replace pt_ben2 = pt_ben1 			if country == "BE" & year == 2011 & gender == 2


foreach x in 1 2 {
	replace pt_ben`x' = 0 	if pt_eli == 0 & country == "BE" & year == 2011
}

replace pt_dur = 0 if pt_eli == 0 & country == "BE" & year == 2011


