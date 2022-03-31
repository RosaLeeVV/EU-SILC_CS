/* PL_2012_FI_eusilc_cs */


* FINLAND - 2012

* ELIGIBILITY
/*	-> all residents
	-> non-residents: 4 months of employment or self-employment (not coded)
 */
replace pl_eli = 1 			if country == "FI" & year == 2012 
			
replace pl_eli = 0 			if pl_eli == . & country == "FI" & year == 2012


* DURATION (weeks)
/* 	-> family entitlement 
	-> 158 days 
	-> couples: assigned to women
*/
   
replace pl_dur = 158/21.7 		if country == "FI" & year == 2012 & pl_eli == 1 ///
								& gender == 1

* single men
replace pl_dur = 158/21.7 		if country == "FI" & year == 2012 & pl_eli == 1 ///
								& gender == 2 & parstat == 1



* BENEFIT (monthly)
/*	-> first 30 days:
		-> €22.96/day if unemployed or earnings are less than €9,842/year (income group 30a)
		-> 75% on earnings between €9,842/year and €51,510/year (IG 30b)
		-> 32.5% on earnings above €51,510/year (IG 30c)
		
	-> remaining 128 days:
		-> €22.96/day if unemployed or earnings are less than €9,842/year (IG 24a)
		-> 70% on earnings between €9,842/year and €33,479/year (IG 24b)
		-> 40% on earnings between €33,480/year and €51,5102/year (IG 24c)
		-> 25% on earnings above €51,510/year 		*/


* WOMEN 
* Income group (IG) 30a
replace pl_ben30 = 22.96 * 21.7 		if country == "FI" & year == 2012 ///
									& gender == 1 & pl_eli == 1 ///
									& (earning*12) < 9842

* IG 30b			
replace pl_ben30 = (earning * 0.75) 	if country == "FI" & year == 2012 ///
									& gender == 1 & pl_eli == 1 & pl_ben30 == . ///
									& inrange((earning*12),9842,51510)

* IG 30c			
gen pl_ben30a = (51510/12) * 0.75 	if country == "FI" & year == 2012 ///
									& gender == 1 & (earning*12) > 51510 ///
									& pl_eli == 1
									
gen pl_ben30b = (earning - (51510/12)) * 0.325 		if country == "FI" & year == 2012 ///
													& gender == 1 ///
													& (earning*12) > 51510 & pl_eli == 1
	
	
replace pl_ben30 = pl_ben30a + pl_ben30b 		if country == "FI" & year == 2012 ///
												& gender == 1 & pl_eli == 1 ///
												& pl_ben30 == . ///
												& (earning*12) > 51510 



* IG 128a - annual earnings less than €9,842/year
replace pl_ben128 = 22.96 * 21.7 		if country == "FI" & year == 2012 & gender == 1 ///
									& pl_eli == 1 & (earning*12) < 9842

* IG 128b - €9,842/year and €33,479/year
replace pl_ben128 = earning * 0.7 	if country == "FI" & year == 2012 & gender == 1 ///
									& pl_eli == 1 & pt_ben24 == . ///
									& inrange((earning*12),9842,33479)

* IG 128c - annual earnings between €33,480/year and €51,510/year
gen pl_ben128a = (33480/12) * 0.7 	if country == "FI" & year == 2012 & gender == 1 ///
									& pl_eli == 1 & (earning*12) > 33480
			
gen pl_ben128b = (earning - (33480/12)) * 0.4 		if country == "FI" ///
									& year == 2012	& gender == 1 & pl_eli == 1 ///
									& inrange((earning*12),33480,51510)

replace pl_ben128 = pl_ben128a + pl_ben128b 		if country == "FI" ///
												& year == 2012	& gender == 1 ///
												& pl_eli == 1 & pl_ben128 == . ///
												& inrange((earning*12),33480,51510)			
			
* IG 128d - annual earnings above €51510	
gen pl_ben128c = (51510/12) * 0.4			if country == "FI" ///
													& year == 2012	& gender == 1 ///
													& pl_eli == 1 & (earning*12) > 51510
	
gen pl_ben128d = (earning - (51510/12)) * 0.25 		if country == "FI" ///
									& year == 2012	& gender == 1 & pl_eli == 1 ///
									& (earning*12) > 51510
			

replace pl_ben128 = pl_ben128a + pl_ben128c + pl_ben128d 		if country == "FI" ///
							& year == 2012	& gender == 1 & pl_eli == 1 & pl_ben128 == . ///
							& (earning*12) > 51510




* SINGLE MEN
* Income group (IG) 30a
replace pl_ben30 = 22.96 * 21.7 		if country == "FI" & year == 2012 ///
									& gender == 2 & pl_eli == 1 ///
									& (earning*12) < 9842 & parstat == 1

* IG 30b			
replace pl_ben30 = (earning * 0.75) 	if country == "FI" & year == 2012 ///
									& gender == 2 & pl_eli == 1 & pl_ben30 == . ///
									& inrange((earning*12),9842,51510) & parstat == 1

* IG 30c			
gen pl_ben30a = (51510/12) * 0.75 	if country == "FI" & year == 2012 ///
									& gender == 2 & (earning*12) > 51510 ///
									& pl_eli == 1 & parstat == 1
									
gen pl_ben30b = (earning - (51510/12)) * 0.325 		if country == "FI" & year == 2012 ///
													& gender == 2 ///
													& (earning*12) > 51510 & pl_eli == 1 & parstat == 1
	
	
replace pl_ben30 = pl_ben30a + pl_ben30b 		if country == "FI" & year == 2012 ///
												& gender == 2 & pl_eli == 1 ///
												& pl_ben30 == . ///
												& (earning*12) > 51510 & parstat == 1



* IG 128a - annual earnings less than €9,842/year
replace pl_ben128 = 22.96 * 21.7 		if country == "FI" & year == 2012 & gender == 2 ///
									& pl_eli == 1 & (earning*12) < 9842 & parstat == 1

* IG 128b - €9,842/year and €33,479/year
replace pl_ben128 = earning * 0.7 	if country == "FI" & year == 2012 & gender == 2 ///
									& pl_eli == 1 & pt_ben24 == . ///
									& inrange((earning*12),9842,33479) & parstat == 1

* IG 128c - annual earnings between €33,480/year and €51,510/year
gen pl_ben128a = (33480/12) * 0.7 	if country == "FI" & year == 2012 & gender == 2 ///
									& pl_eli == 1 & (earning*12) > 33480 & parstat == 1
			
gen pl_ben128b = (earning - (33480/12)) * 0.4 		if country == "FI" ///
									& year == 2012	& gender == 2 & pl_eli == 1 ///
									& inrange((earning*12),33480,51510) & parstat == 1

replace pl_ben128 = pl_ben128a + pl_ben128b 		if country == "FI" ///
												& year == 2012	& gender == 2 ///
												& pl_eli == 1 & pl_ben128 == . ///
												& inrange((earning*12),33480,51510) & parstat == 1			
			
* IG 128d - annual earnings above €51,510	
gen pl_ben128c = (51510/12) * 0.4			if country == "FI" ///
													& year == 2012	& gender == 2 ///
													& pl_eli == 1 & (earning*12) > 51510 & parstat == 1
	
gen pl_ben128d = (earning - (51510/12)) * 0.25 		if country == "FI" ///
									& year == 2012	& gender == 2 & pl_eli == 1 ///
									& (earning*12) > 51510 & parstat == 1
			

replace pl_ben128 = pl_ben128a + pl_ben128c + pl_ben128d 		if country == "FI" ///
							& year == 2012	& gender == 2 & pl_eli == 1 & pl_ben128 == . ///
							& (earning*12) > 51510 & parstat == 1








* PT benefit 
replace pl_ben1 = ((pl_ben30 * (30/158) ) + (pt_ben24 * (128/158)))		if country == "FI" ///
												& year == 2012	& gender == 1 & pl_eli == 1
			
replace pl_ben1 = ((pl_ben30 * (30/158) ) + (pt_ben24 * (128/158)))		if country == "FI" ///
												& year == 2012	& gender == 2 & pl_eli == 1 & parstat == 1


replace pl_ben2 = pl_ben30			if country == "FI" & year == 2012 & pl_eli == 1


foreach x in 1 2 {
	replace pl_ben`x' = 0 	if pl_eli == 0 & country == "FI" & year == 2012
}

replace pl_dur = 0 	if pl_eli == 0 & country == "FI" & year == 2012
