/* ML_2019_PT_eusilc_cs

date created: 12/08/2021

*/

* PORTUGAL - 2019

* ELIGIBILITY
/*	-> pooled rights (i.e. individual and family rights to leave)
		- total leave: 120 or 150 (parents' choice)
		- ML refers to the leave reserved for mother
	-> compulsorily social insurance for employed and self-employed 
		- 6 months of work before childbirth	
		
	-> transferable to father only if the mother died or is incapacitated => 
		we assume that this does not extend to abandonment of child by the mother (not coded)
*/
	
replace ml_eli = 1 			if country == "PT" & year == 2019 & gender == 1 ///
							& econ_status == 1 & duremp >= 6
replace ml_eli = 1 			if country == "PT" & year == 2019 & gender == 1 ///
							& econ_status == 2 & dursemp >= 6
replace ml_eli = 1 			if country == "PT" & year == 2019 & gender == 1 ///
							& inlist(econ_status,1,2) & duremp + dursemp >= 6

							
replace ml_eli = 0 			if ml_eli == . & country == "PT" & year == 2019 & gender == 1


* DURATION (weeks)
/*	-> postnatal leave: 6 weeks
	-> prenatal leave: voluntary leave, option of 30 days from the leave (not coded) */
	
replace ml_dur1 = 0 		if country == "PT" & year == 2019 & ml_eli == 1

replace ml_dur2 = 6 		if country == "PT" & year == 2019 & ml_eli == 1



* BENEFIT (monthly)
/*	-> benefits are identical for all types of leave (reserved for mother, father, shared leave)
	-> influenced by parents' choice of duration (120 or 150 days) and whether leave is shared 
	-> 120 days: 100% earning (coded)
	-> 150 days, not shared: 80% earning 
	-> 150 days, shared: 100% earning
	-> 180 days, shared: 83% earning 
	-> minimum: €435.76 /month 
*/

replace ml_ben1 = earning 		if country == "PT" & year == 2019 & ml_eli == 1
replace ml_ben1 = 435.76 		if country == "PT" & year == 2019 & ml_eli == 1 ///
								& ml_ben1 < 435.76 
								
replace ml_ben2 = ml_ben1 		if country == "PT" & year == 2019 & ml_eli == 1

foreach x in 1 2 {
    replace ml_dur`x' = 0 	if ml_eli == 0 & country == "PT" & year == 2019
	replace ml_ben`x' = 0 	if ml_eli == 0 & country == "PT" & year == 2019
}

