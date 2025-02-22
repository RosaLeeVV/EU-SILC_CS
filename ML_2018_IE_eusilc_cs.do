/* ML_2018_IE_eusilc_cs

date created: 26/03/2018

*/

* IRELAND - 2018

* ELIGIBILITY
/*	-> employed: at least 39 weeks (9 months) compulsory social insurance contributions in past 12 months
	-> self-employed: at least 52 weeks compulsory social insurance contribution in past 12 months
	-> transferable to the father only in case of mother's death => assumed this does not apply to abandoned 
		children by their mother
*/
	
replace ml_eli = 1 			if country == "IE" & year == 2018 & gender == 1 ///
							& econ_status == 1 & duremp >= 9
							
replace ml_eli = 1 			if country == "IE" & year == 2018 & gender == 1 ///
							& econ_status == 2 & dursemp >= 12
							
replace ml_eli = 0 			if ml_eli == . & country == "IE" & year == 2018 & gender == 1


* DURATION (weeks)
/*	-> 26 weeks paid leave
	-> 16 weeks unpaid leave
	-> prenatal leave: 2 weeks
*/
	
replace ml_dur1 = 2 		if country == "IE" & year == 2018 & ml_eli == 1

replace ml_dur2 = 26+16-2 		if country == "IE" & year == 2018 & ml_eli == 1


* BENEFIT (monthly)
/*	-> 26 weeks: €240/weeks
	-> 16 weeks: unpaid 	*/
	
replace ml_ben1 = ((240*4.3)/(26/(26+12)))  	if country == "IE" & year == 2018 & ml_eli == 1


replace ml_ben2 = 240*4.3 		if country == "IE" & year == 2018 & ml_eli == 1


foreach x in 1 2 {
    replace ml_dur`x' = 0 	if ml_eli == 0 & country == "IE" & year == 2018
	replace ml_ben`x' = 0 	if ml_eli == 0 & country == "IE" & year == 2018
}

