/* ML_2012_EE_eusilc_cs */


* ESTONIA - 2012

* ELIGIBILITY
/*	-> employed
	-> self-employed
	
	-> is non-transferable => single father cannot use the leave
*/
replace ml_eli = 1 			if country == "EE" & year == 2012 & gender == 1 ///
							& inlist(econ_status,1,2) 
replace ml_eli = 0 			if ml_eli == . & country == "EE" & year == 2012 & gender == 1


* DURATION (weeks)
/*	-> prenatal: 30 calendar days
	-> total: 140 calendar days 	
*/
replace ml_dur1 = 30/7 				if country == "EE" & year == 2012 & gender == 1 & ml_eli == 1

replace ml_dur2 = (140-30)/7 		if country == "EE" & year == 2012 & gender == 1 & ml_eli == 1


* BENEFIT (monthly)
/*	-> employed, self-employed: 100% earnings paid during the previous calendar year (LP&R 2012)
	-> employed, self-employed who didn't work in the previous calendar year: €290/month 	
*/

* employed	
replace ml_ben1 = earning 		if country == "EE" & year == 2012 & ml_eli == 1 ///
								& duremp >= 1 
replace ml_ben1 = 390			if country == "EE" & year == 2012 & ml_eli == 1 ///
								& duremp == 0

								
* self-employed								
replace ml_ben1 = earning 		if country == "EE" & year == 2012 & ml_eli == 1 ///
								& dursemp >= 1 
replace ml_ben1 = 390			if country == "EE" & year == 2012 & ml_eli == 1 ///
								& dursemp == 0



replace ml_ben2 = ml_ben1 		if country == "EE" & year == 2012 & gender == 1 & ml_eli == 1

foreach x in 1 2 {
    replace ml_dur`x' = 0 	if ml_eli == 0 & country == "EE" & year == 2012
	replace ml_ben`x' = 0 	if ml_eli == 0 & country == "EE" & year == 2012
}

