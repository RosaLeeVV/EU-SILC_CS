/* ML_2012_AT_eusilc_cs */

* AUSTRIA - 2012

* ELIGIBILITY
/* -> Employed: earnings at least €376.26/month  
   -> Self-employed: if voluntarily insured => not coded.
   -> Unemployed: if receive unemployment benefits/completed 3 months of 
	continuous  employment		
	
	-> leave is not transferable => single fathers are assumed to be ineligible
*/
   
replace ml_eli = 1 		if country == "AT" & year == 2012 & gender == 1 ///
						& econ_status == 1 & earning >= 376.26
replace ml_eli = 1 		if country == "AT" & year == 2012 & gender == 1 ///
						& econ_status == 3 & duremp >= 3
				
replace ml_eli = 0 		if ml_eli == . & country == "AT" & year == 2012 & gender == 1


* DURATION (weeks)
/*	-> total: 16 weeks
	-> prenatal: 8 weeks
	-> postnatal: 8	weeks		 */
	
replace ml_dur1 = 8 	if country == "AT" & year == 2012 & gender == 1 & ml_eli == 1

replace ml_dur2 = 8 	if country == "AT" & year == 2012 & gender == 1 & ml_eli == 1


* BENEFIT (monthly)
/*	-> 100% earnings, no ceiling
	-> marginally employed, self-insured: €8.22/day (not coded) 
	-> self-employed: €26.97/day	(not coded; LP&R 2012)		
	-> unemployed: 180% of unemployment benefits (not coded)
*/
	
replace ml_ben1 = earning 	if country == "AT" & year == 2012 & gender == 1 ///
							& ml_eli == 1 & econ_status == 1
								
				
replace ml_ben2 = ml_ben1 	if country == "AT" & year == 2012 & gender == 1 & ml_eli == 1
				
foreach x in 1 2 {
    replace ml_dur`x' = 0 	if ml_eli == 0 & country == "AT" & year == 2012
	replace ml_ben`x' = 0 	if ml_eli == 0 & country == "AT" & year == 2012
}
				

