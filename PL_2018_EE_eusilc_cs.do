/* PL_2018_EE_eusilc_cs

date created: 24/03/2021

*/

* ESTONIA - 2018

* ELIGIBILITY
/*	-> all residents 
	-> only one parent receives the benefit (i.e. family entitlement)
*/
replace pl_eli = 1	 		if country == "EE" & year == 2018 
replace pl_eli = 0 			if pl_eli == . & country == "EE" & year == 2018


* DURATION (weeks)
/*	-> until child is 3 years old
	-> family entitlement => assigned to women
	-> women eligible for ML => postnatal ML deducted from PL duration
	-> unemployed and inactive parent: benefits paid until child is 18 months old 	
*/

* women	
replace pl_dur = (3*52) - ml_dur2 		if country == "EE" & year == 2018 ///
										& pl_eli == 1 & ml_eli == 1 & gender == 1
										
replace pl_dur = 18/4.3 		if country == "EE" & year == 2018 & pl_dur == . ///
								& pl_eli == 1 & inlist(econ_status,3,4) & gender == 1 

								
* single men										
replace pl_dur = 3*52 			if country == "EE" & year == 2018 ///
										& pl_eli == 1 & ml_eli == 1 ///
										& gender == 2 & parstat == 1
replace pl_dur = 18/4.3 		if country == "EE" & year == 2018 & pl_dur == . ///
								& pl_eli == 1 & gender == 2 & parstat == 1 ///
								& inlist(econ_status,3,4)
								


* BENEFIT (monthly)
/*	-> 100% earnings
	-> minimum: €500/month
	-> maximum: €3,089.55/month		
	-> unemployed and inactive parent: €470
*/

replace pl_ben1 = earning 	if country == "EE" & year == 2018 & pl_eli == 1 

* family entitlement -> cohabiting men = 0
replace pl_ben1 = 0 		if country == "EE" & year == 2018 & gender == 2 ///
							& parstat == 2
							
	
replace pl_ben1 = 500		if country == "EE" & year == 2018 & pl_eli == 1 ///
							& pl_ben1 < 500 & pl_ben1 != 0

							
replace pl_ben1 = 3089.55	if country == "EE" & year == 2018 & pl_eli == 1 ///
							& pl_ben1 >= 3089.55
							
replace pl_ben1 = 470 		if country == "EE" & year == 2018 & pl_eli == 1 ///
							& inlist(econ_status,3,4) & gender == 1

replace pl_ben1 = 470 		if country == "EE" & year == 2018 & pl_eli == 1 ///
							& inlist(econ_status,3,4) & gender == 2 & parstat == 1							
							
replace pl_ben2 = pl_ben1 		if country == "EE" & year == 2018 & pl_eli == 1 
							

							
foreach x in 1 2 {
	replace pl_ben`x' = 0 	if pl_eli == 0 & country == "EE" & year == 2018
}

replace pl_dur = 0 	if pl_eli == 0 & country == "EE" & year == 2018
