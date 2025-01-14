/* ML_2018_LV_eusilc_cs

date created: 29/03/2021

*/

* LATVIA - 2018

* ELIGIBILITY
/*	-> employed (conditions are listed in LP&R 2018 but not in MISSOC 01/07/2018 => not coded)
	-> self-employed
	-> father after mother's death or mother relinquished the care and raising the child 
		=> coded for single fathers			*/
	
replace ml_eli = 1 			if country == "LV" & year == 2018 & gender == 1 ///
							& inlist(econ_status,1,2) 

* single men
replace ml_eli = 1 			if country == "LV" & year == 2018 & gender == 2 ///
							& inlist(econ_status,1,2) & parstat == 1
							
replace ml_eli = 0 			if ml_eli == . & country == "LV" & year == 2018 & gender == 1


* DURATION (weeks)
/*	-> total: 112 calendar days
	-> prenatal compulsory: 2 weeks
	-> father who takes ML from mother: 42 calendar days (coded) within 70 calendar days since birth (not 		
		coded)	*/

replace ml_dur1 = 2 		if country == "LV" & year == 2018 & ml_eli == 1

replace ml_dur2 = (112-(2*7))/7 		if country == "LV" & year == 2018 & ml_eli == 1 & gender == 1
replace ml_dur2 = 42/7					if country == "LV" & year == 2018 & ml_eli == 1 & gender == 2


* BENEFIT (monthly)
/*	-> 80% gross earnings */

replace ml_ben1 = 0.8*earning 		if country == "LV" & year == 2018 & ml_eli == 1
replace ml_ben2 = ml_ben1 			if country == "LV" & year == 2018 & ml_eli == 1


foreach x in 1 2 {
    replace ml_dur`x' = 0 	if ml_eli == 0 & country == "LV" & year == 2018
	replace ml_ben`x' = 0 	if ml_eli == 0 & country == "LV" & year == 2018
}

