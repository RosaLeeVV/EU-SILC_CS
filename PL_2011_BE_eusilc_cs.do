/* PL_2011_BE_eusilc_cs */


* BELGIUM - 2011

* ELIGIBILITY
/*	-> private sector: employees, 12 months (coded) of employement in last 15 months with the same employer (not 
		coded)
	-> public sector: employees (not coded; LP&R 2011)						*/
   
replace pl_eli = 1 		if country == "BE" & year == 2011 & pl_eli == . ///
						& econ_status == 1 & duremp >= 12 
replace pl_eli = 0 		if pl_eli == . & country == "BE" & year == 2011


* DURATION (weeks)
/*	-> 3 months 
	-> until child is 12 years old (not coded) 		*/
	
replace pl_dur = 3 * 4.3 	if country == "BE" & year == 2011 & pl_eli == 1


* BENEFIT (monthly)
/*	-> full-time workers: €684.94/month 
*/

replace pl_ben1 = 684.94 		if country == "BE" & year == 2011 & pl_eli == 1 ///
								& pl_ben1 == . 
			

replace pl_ben2 = pl_ben1 		if country == "BE" & year == 2011 & pl_eli == 1
								


foreach x in 1 2 {
	replace pl_ben`x' = 0 	if pl_eli == 0 & country == "BE" & year == 2011
}

replace pl_dur = 0 	if pl_eli == 0 & country == "BE" & year == 2011
