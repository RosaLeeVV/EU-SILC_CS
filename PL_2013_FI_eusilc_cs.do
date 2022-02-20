/* PL_2013_FI_eusilc_cs */


* FINLAND - 2013

* ELIGIBILITY
/*	-> all residents
	-> non-residents: 4 months of employment or self-employment (not coded)
 */
replace pl_eli = 1 			if country == "FI" & year == 2013 
			
replace pl_eli = 0 			if pl_eli == . & country == "FI" & year == 2013


* DURATION (weeks)
/* 	-> family entitlement 
	-> 158 days 
	-> couples: assigned to women
*/
   
replace pl_dur = 158/21.7 		if country == "FI" & year == 2013 & pl_eli == 1 ///
								& gender == 1

* single men
replace pl_dur = 158/21.7 		if country == "FI" & year == 2013 & pl_eli == 1 ///
								& gender == 2 & parstat == 1



* BENEFIT (monthly)
/*	-> €23.77/day if unemployed or earnings are less than €10,189/year (income group a)
	-> 70% on earnings between €10,189/year and €35,458/year (IG b)
	-> 40% on earnings between €35,458/year and €56,443/year (IG c)
	-> 25% on earnings above €56,443/year   (IG d) 		*/


* WOMEN 
* IGa
replace pl_ben1 = 23.77 * 21.7 			if country == "FI" & year == 2013 & gender == 1 ///
										& pl_eli == 1 
									

* IGb
replace pl_ben1 = earning * 0.7 		if country == "FI" & year == 2013 & gender == 1 ///
										& pl_eli == 1 & inrange((earning*12),10189,35458)

									
* IGc 
gen pl_bena = (35458/12) * 0.7 		if country == "FI" & year == 2013 & gender == 1 ///
									& pl_eli == 1 & earning*12 >= 35458
			
gen pl_benb = (earning - (35458/12)) * 0.4 		///
									if country == "FI" & year == 2013	///
									& gender == 1 & pl_eli == 1 ///
									& inrange((earning*12),35458,54552)

replace pl_ben1 = pl_bena + pl_benb 		if country == "FI" ///
												& year == 2013	& gender == 1 ///
												& pl_eli == 1 & inrange((earning*12),35458,54552)			

																								
												
												
* IGd	


gen pl_benc = (54552/12) * 0.4			if country == "FI" & year == 2013	& gender == 1 ///
										& pl_eli == 1 & (earning*12) > 54552
	
gen pl_bend = (earning - (54552/12)) * 0.25  		///
									if country == "FI" & year == 2013	///
									& gender == 1 & pl_eli == 1 ///
									& (earning*12) >= 54552
			

replace pl_ben1 = pl_bena + pl_benc + pl_bend 		if country == "FI" ///
							& year == 2013	& gender == 1 & pl_eli == 1 ///
							& (earning*12) >= 54552


							
* SINGLE MEN
* IGa
replace pl_ben1 = 23.77 * 21.7 			if country == "FI" & year == 2013 & gender == 2 ///
										& pl_eli == 1 & parstat == 1
									

* IGb
replace pl_ben1 = earning * 0.7 		if country == "FI" & year == 2013 & gender == 2 ///
										& pl_eli == 1 & inrange((earning*12),10189,35458) ///
										 & parstat == 1

									
* IGc 
replace pl_bena = (35458/12) * 0.7 		if country == "FI" & year == 2013 & gender == 2 ///
									& pl_eli == 1 & earning*12 >= 35458 & parstat == 1
			
replace pl_benb = (earning - (35458/12)) * 0.4 		///
									if country == "FI" & year == 2013	///
									& gender == 2 & pl_eli == 1 ///
									& inrange((earning*12),35458,54552) & parstat == 1

replace pl_ben1 = pl_bena + pl_benb 		if country == "FI" ///
												& year == 2013	& gender == 2 ///
												& pl_eli == 1 & inrange((earning*12),35458,54552) ///
												& parstat == 1

																								
												
												
* IGd	


replace pl_benc = (54552/12) * 0.4		if country == "FI" & year == 2013	& gender == 2 ///
										& pl_eli == 1 & (earning*12) > 54552 & parstat == 1
	
replace pl_bend = (earning - (54552/12)) * 0.25  		///
									if country == "FI" & year == 2013	///
									& gender == 2 & pl_eli == 1 ///
									& (earning*12) >= 54552 & parstat == 1
			
			
replace pl_ben1 = pl_bena + pl_benc + pl_bend 		if country == "FI" ///
							& year == 2013	& gender == 2 & pl_eli == 1 ///
							& (earning*12) >= 54552 & parstat == 1			
			
			
			



replace pl_ben2 = pl_ben1 			if country == "FI" & year == 2013 & pl_eli == 1

foreach x in 1 2 {
	replace pl_ben`x' = 0 	if pl_eli == 0 & country == "FI" & year == 2013
}

replace pl_dur = 0 	if pl_eli == 0 & country == "FI" & year == 2013
