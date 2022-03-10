/* ML_2012_FI_eusilc_cs */


* Finland - 2012 

* ELIGIBILITY (MISSOC 01/07/2012)
/*	-> all residents (women)
	-> non-residents: 4 months of employment or self-employment (not coded)
	-> ML can be transferred to father in case of death or illness => it is assumed that 
		this does not apply to cases where the mother abandoned her child (not coded)
*/
replace ml_eli = 1 			if country == "FI" & year == 2012 & gender == 1 
			
			
replace ml_eli = 0 			if ml_eli == . & country == "FI" & year == 2012 & gender == 1



* DURATION (weeks)
/*	-> prenatal: 30 days
	-> total: 105 days
	-> 6 days working week */

replace ml_dur1 = 30/6 if country == "FI" & year == 2012 & gender == 1 & ml_eli == 1

replace ml_dur2 = (105-30)/6 if country == "FI" & year == 2012 & gender == 1 & ml_eli == 1



* BENEFIT (monthly; LP&R 2012)
/* first 56 days:
	-> €22.96/day if unemployed or earnings are less than €9,842/year (income group 56a)
	-> 90% of earnings between €9,842/year and €51,510/year (IG 56b)
	-> 32.5% of earnings above €51,510/year (IG 56c)

remaining 49 days:
	-> €22.96/day if unemployed or earnings are less than €9,842/year (income group 49a)
	-> 70% on earnings between €9,842/year and €33,479/year (IG 49b)
	-> 40% on earnings between €33,480/year and €51,510/year (IG 49c)
	-> 25% on earnings above €51,510/year   (IG 49d) 						*/ 

* Income group (IG) 56a
gen ml_ben56 = 22.96 * 21.7 		if country == "FI" & year == 2012 ///
									& gender == 1 & ml_eli == 1 ///
									& econ_status == 3


replace ml_ben56 = 22.96 * 21.7 		if country == "FI" & year == 2012 ///
									& gender == 1 & ml_eli == 1 ///
									& (earning*12) < 9842

* IG 56b			
replace ml_ben56 = (earning * 0.9) 	if country == "FI" & year == 2012 ///
									& gender == 1 & ml_eli == 1 & ml_ben56 == . ///
									& inrange((earning*12),9842,51510)

* IG 56c			
gen ml_ben56a = (51510/12) * 0.9 	if country == "FI" & year == 2012 ///
									& gender == 1 & (earning*12) > 51510 ///
									& ml_eli == 1
									
gen ml_ben56b = (earning - (51510/12)) * 0.325 		if country == "FI" & year == 2012 ///
													& gender == 1 ///
													& (earning*12) > 51510 & ml_eli == 1
	
	
replace ml_ben56 = ml_ben56a + ml_ben56b 		if country == "FI" & year == 2012 ///
												& gender == 1 & ml_eli == 1 ///
												& ml_ben56 == . ///
												& (earning*12) > 51510 & ml_eli == 1


* IG 49a
gen ml_ben49 = 22.96 * 21.7 		if country == "FI" & year == 2012 & gender == 1 ///
									& ml_eli == 1 & econ_status == 3


replace ml_ben49 = 22.96 * 21.7 		if country == "FI" & year == 2012 & gender == 1 ///
									& ml_eli == 1 & (earning*12) < €9842

* IG 49b - annual earnings under €33479
replace ml_ben49 = earning * 0.7 	if country == "FI" & year == 2012 & gender == 1 ///
									& ml_eli == 1 & ml_ben49 == . ///
									& inrange((earning*12),9842,33479)

* IG 49c - annual earnings between €33,480/year and €51,510/year
gen ml_ben49a = (33480/12) * 0.7 	if country == "FI" & year == 2012 & gender == 1 ///
									& ml_eli == 1 & (earning*12) > 33480
			
gen ml_ben49b = (earning - (33480/12)) * 0.4 		if country == "FI" ///
									& year == 2012	& gender == 1 & ml_eli == 1 ///
									& inrange((earning*12),33480,51510)

replace ml_ben49 = ml_ben49a + ml_ben49b 		if country == "FI" ///
												& year == 2012	& gender == 1 ///
												& ml_eli == 1 & ml_ben49 == . ///
												& inrange((earning*12),33480,51510)			
			
* IG 49d - annual earnings above €51,510	
gen ml_ben49c = (51510/12) * 0.4			if country == "FI" ///
													& year == 2012	& gender == 1 ///
													& ml_eli == 1 & (earning*12) > 51510	
	
gen ml_ben49d = (earning - (51510/12)) * 0.25 		if country == "FI" ///
									& year == 2012	& gender == 1 & ml_eli == 1 ///
									& (earning*12) > 51510	
			

replace ml_ben49 = ml_ben49a + ml_ben49c + ml_ben49d 		if country == "FI" ///
							& year == 2012	& gender == 1 & ml_eli == 1 & ml_ben49 == . ///
							& (earning*12) > 51510	
			

* ML benefit 
replace ml_ben1 = ((ml_ben56 * (56/105) ) + (ml_ben49 * (49/105)))		if country == "FI" ///
												& year == 2012	& gender == 1 & ml_eli == 1


			 
replace ml_ben2 = ml_ben56 		if country == "FI" & year == 2012 & gender == 1 & ml_eli == 1

foreach x in 1 2 {
    replace ml_dur`x' = 0 	if ml_eli == 0 & country == "FI" & year == 2012
	replace ml_ben`x' = 0 	if ml_eli == 0 & country == "FI" & year == 2012
}



drop ml_ben56a ml_ben56b ml_ben49a ml_ben49b ml_ben49c ml_ben49d
