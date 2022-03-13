/* ML_2012_FR_eusilc_cs */


* FRANCE - 2012

* ELIGIBILITY
/*	-> employed
	-> self-employed
	-> transferable to father only in the event of mother's death (not coded)
*/

replace ml_eli = 1 			if country == "FR" & year == 2012 & gender == 1 ///
							& inlist(econ_status,1,2)
replace ml_eli = 0 			if ml_eli == . & country == "FR" & year == 2012 & gender == 1


* DURATION (weeks)
/*	-> prenatal: 2 weeks 
	-> total: 16 weeks
	-> for 3rd and subsequent child: 26 weeks (coded as <2 and >= 2 due to 
	the hypothetical child the microsimulation adds to the HH)
*/
	
replace ml_dur1 = 2 		if country == "FR" & year == 2012 & gender == 1 & ml_eli == 1

replace ml_dur2 = 16-2 		if country == "FR" & year == 2012 & gender == 1 ///
							& ml_eli == 1 & childc < 2
							
replace ml_dur2 = 26-2 		if country == "FR" & year == 2012 & gender == 1 ///
							& ml_eli == 1 & childc >= 2


* BENEFIT (monthly)
/*	-> 100%
	-> minimum: €8.90/day
	-> ceiling: €80.04/ day
	-> no ceiling in public sector (not coded; LP&R 2012)
	-> source: MISSOC 01/07/2012
*/ 
	
replace ml_ben1 = earning 			if country == "FR" & year == 2012 & ml_eli == 1 ///
									& ml_ben1 == .

* minimum
replace ml_ben1 = 8.90 * 21.7		if country == "FR" & year == 2012  ///
									& ml_eli == 1 & ml_ben1 < 8.90*21.7
		
* maximum
replace ml_ben1 = 80.04 * 21.7			if country == "FR" & year == 2012  ///
									& ml_eli == 1 & ml_ben1 >= 80.04*21.7
		


replace ml_ben2 = ml_ben1 		if country == "FR" & year == 2012 & ml_eli == 1


foreach x in 1 2 {
    replace ml_dur`x' = 0 	if ml_eli == 0 & country == "FR" & year == 2012
	replace ml_ben`x' = 0 	if ml_eli == 0 & country == "FR" & year == 2012
}

