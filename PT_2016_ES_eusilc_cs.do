/* PT_2016_ES_eusilc_cs */

* SPAIN - 2016

* ELIGIBILITY
/*	-> employed, self-employed
	-> 180 contribution days (coded) during the past 7 years (not coded) or 360 over their working life (not coded)
*/

replace pt_eli = 1 		if country == "ES" & year == 2016 & gender == 2 ///
						& inlist(econ_status,1,2) & (duremp+dursemp) >= 180/21.7
						
replace pt_eli = 0 		if pt_eli == . & country == "ES" & year == 2016 & gender == 2


* DURATION 
/*	-> 15 calendar days: 2 to be taken before childbirth and 13 days to be taken after childbirth 
	
*/
replace pt_dur = (15/5)  		if country == "ES" & year == 2016 & pt_eli == 1 ///
								& econ_status == 1


* BENEFIT (monthly)
/*	-> 100%
	-> ceiling: €3,642.00/month
*/

replace pt_ben1 = earning 	if country == "ES" & year == 2016 & pt_eli == 1

replace pt_ben1 = 3642 		if country == "ES" & year == 2016 & pt_eli == 1 ///
							& pt_ben1 > 3642

replace pt_ben2 = pt_ben1 	if country == "ES" & year == 2016 & pt_eli == 1



foreach x in 1 2 {
	replace pt_ben`x' = 0 	if country == "ES" & year == 2016 & pt_eli == 0
}

replace pt_dur = 0 		if country == "ES" & year == 2016 & pt_eli == 0 
