/* ML_2018_GR_eusilc_cs

date created: 26/03/2021

*/

* GREECE - 2018

* ELIGIBILITY
/*	-> employed
	-> self-employed
	-> not transferable => assumed that single fathers are not eligible for this share of leave
	Source: MISSOC 01/07/2018		*/
	
replace ml_eli = 1 			if country == "GR" & year == 2018 & gender == 1 ///
							& inlist(econ_status,1,2)	
							
replace ml_eli = 0 			if ml_eli == . & country == "GR" & year == 2018 & gender == 1


* DURATION (weeks)
/*	-> total: 119 days
	-> prenatal: 56 days
	-> postnatal: 63 days 	*/
	
replace ml_dur1 = 56/5 		if country == "GR" & year == 2018 & ml_eli == 1

replace ml_dur2 = 63/5 		if country == "GR" & year == 2018 & ml_eli == 1


* BENEFIT (monthly)
/*	Due to considerable differences in the information provided by MISSOC and LP&R,
	the maternity leave benefits are not coded. 
*/
	
	
replace ml_ben1 = . 		if country == "GR" & year == 2018 & ml_eli == 1

replace ml_ben2 = . 		if country == "GR" & year == 2018 & ml_eli == 1


foreach x in 1 2 {
    replace ml_dur`x' = 0 	if ml_eli == 0 & country == "GR" & year == 2018
	replace ml_ben`x' = 0 	if ml_eli == 0 & country == "GR" & year == 2018
}

