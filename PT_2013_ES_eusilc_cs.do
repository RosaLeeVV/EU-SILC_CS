/* PT_2013_ES_eusilc_cs */

* SPAIN - 2013

* ELIGIBILITY
/*	-> employed, self-employed
	-> 180 contribution days (coded) during the past 7 years (not coded) or 360 over their working life (not coded)
*/

replace pt_eli = 1 		if country == "ES" & year == 2013 & gender == 2 ///
						& inlist(econ_status,1,2) & (duremp+dursemp) >= 180/21.7
						
replace pt_eli = 0 		if pt_eli == . & country == "ES" & year == 2013 & gender == 2


* DURATION (weeks)
/*	-> employed only: 2 days (birth leave) + 4 weeks (paternity leave)
	-> self-employed: 4 weeks
*/
replace pt_dur = (2/5) + 4 		if country == "ES" & year == 2013 & pt_eli == 1 ///
								& econ_status == 1

replace pt_dur = 4 				if country == "ES" & year == 2013 & pt_eli == 1 ///
								& econ_status == 2


* BENEFIT (monthly)
/*	-> 100%
	-> ceiling: €3,262.5/month
*/

replace pt_ben1 = earning 	if country == "ES" & year == 2013 & pt_eli == 1

replace pt_ben1 = 3262.5		if country == "ES" & year == 2013 & pt_eli == 1 ///
							& pt_ben1 > 3262.5

replace pt_ben2 = pt_ben1 	if country == "ES" & year == 2013 & pt_eli == 1



foreach x in 1 2 {
	replace pt_ben`x' = 0 	if country == "ES" & year == 2013 & pt_eli == 0
}

replace pt_dur = 0 		if country == "ES" & year == 2013 & pt_eli == 0 
