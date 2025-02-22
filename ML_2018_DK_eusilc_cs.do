/* ML_2018_DK_eusilc_cs

date created: 24/03/2021

*/

* DENMARK - 2018

* ELIGIBILITY
/*	-> employed
	-> self-employed
	-> unemployed (from unemployment insurance)	
	-> students (extra student grant; pl031 == 6; LP&R 2018)
	
	-> it is unclear whether the leave can be transferred between parents, 
		the sources provide no indication that this is the case => not coded for single fathers
*/
replace ml_eli = 1	 	if country == "DK" & year == 2018 & gender == 1 ///
						& inlist(econ_status,1,2,3)
						
replace ml_eli = 1	 	if country == "DK" & year == 2018 & gender == 1 ///
						& pl031 == 6
						
replace ml_eli = 0 		if ml_eli == . & country == "DK" & year == 2018 & gender == 1


* DURATION (weeks)
/*	-> combined entitlement for mother and father (MISSOC 01/07/2018)
	-> prenatal: 4 weeks
	-> postnatal: 14 weeks but 2 are for the father => coded as 12 weeks 	*/
	
replace ml_dur1 = 4 	if country == "DK" & year == 2018 & ml_eli == 1

replace ml_dur2 = 12 	if country == "DK" & year == 2018 & ml_eli == 1


* BENEFIT (monthly)
/* 	-> employed, self-employed: 100% earning
	-> ceiling: €577/week 	
	-> unemployed: unemployment benefits (not coded; LP&R 2018)
	-> students: extra 12 months of study grant (not coded; LP&R 2018) */
	
replace ml_ben1 = earning 		if country == "DK" & year == 2018 & ml_eli == 1 ///
								& inlist(econ_status,1,2) & earning < 577*4.3

replace ml_ben1 = 577*4.3		if country == "DK" & year == 2018 & ml_eli == 1 ///
								& inlist(econ_status,1,2) & ml_ben1 >= 577*4.3 ///
								& ml_ben1 == .

replace ml_ben2 = ml_ben1 if country == "DK" & year == 2018 & ml_eli == 1


foreach x in 1 2 {
    replace ml_dur`x' = 0 	if ml_eli == 0 & country == "DK" & year == 2018
	replace ml_ben`x' = 0 	if ml_eli == 0 & country == "DK" & year == 2018
}

