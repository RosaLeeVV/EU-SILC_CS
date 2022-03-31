/* PT_2012_FI_eusilc_cs */


* Finland - 2012

* ELIGIBILITY
/*	-> all residents
	-> non-residents: 4 months of employment or self-employment (not coded)
*/
replace pt_eli = 1 		if country == "FI" & year == 2012 & gender == 2 
						

replace pt_eli = 0 if pt_eli == . & country == "FI" & year == 2012 & gender == 2


* DURATION (weeks)
/* -> 18 days */ 
replace pt_dur = 18/6 if country == "FI" & year == 2012 & pt_eli == 1 


* BENEFIT (monthly)
/*	-> first 30 days:
		-> €22.96/day if unemployed or earnings are less than €9,842/year (income group 30a)
		-> 75% on earnings between €9,842/year and €51,510/year (IG 30b)
		-> 32.5% on earnings above €51,5102/year (IG 30c)
		
	-> remaining 24 days:
		
		-> 25% on earnings above €56,032/year
								
*/


* Income group (IG) 30a
replace pt_ben30 = 22.96 * 21.7 		if country == "FI" & year == 2012 ///
									& gender == 2 & pt_eli == 1 ///
									& (earning*12) < 9842

* IG 30b			
replace pt_ben30 = (earning * 0.75) 	if country == "FI" & year == 2012 ///
									& gender == 2 & pt_eli == 1 & pt_ben30 == . ///
									& inrange((earning*12),9842,51510)

* IG 30c			
gen pt_ben30a = (51510/12) * 0.75 	if country == "FI" & year == 2012 ///
									& gender == 2 & (earning*12) > 51510 ///
									& pt_eli == 1
									
gen pt_ben30b = (earning - (51510/12)) * 0.325 		if country == "FI" & year == 2012 ///
													& gender == 2 ///
													& (earning*12) > 51510 & pt_eli == 1
	
	
replace pt_ben30 = pt_ben30a + pt_ben30b 		if country == "FI" & year == 2012 ///
												& gender == 2 & pt_eli == 1 ///
												& pt_ben30 == . ///
												& (earning*12) > 51510 




* PT benefit 
replace pt_ben1 = ((pt_ben30 * (30/18) ) + (pt_ben24 * (24/18)))		if country == "FI" ///
												& year == 2012	& gender == 2 & pt_eli == 1


			 
replace pt_ben2 = pt_ben30 		if country == "FI" & year == 2012 & gender == 2 & pt_eli == 1




								
foreach x in 1 2 {
	replace pt_ben`x' = 0 	if pt_eli == 0 & country == "FI" & year == 2012
}

replace pt_dur = 0 if pt_eli == 0 & country == "FI" & year == 2012			
			
drop pt_bena pt_benb


