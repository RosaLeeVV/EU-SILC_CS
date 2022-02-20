/* PT_2013_FI_eusilc_cs */


* Finland - 2013

* ELIGIBILITY
/*	-> all residents
	-> non-residents: 4 months of employment or self-employment (not coded)
*/
replace pt_eli = 1 		if country == "FI" & year == 2013 & gender == 2 
						

replace pt_eli = 0 if pt_eli == . & country == "FI" & year == 2013 & gender == 2


* DURATION (weeks)
/* -> 54 days */ 
replace pt_dur = 54/6 if country == "FI" & year == 2013 & pt_eli == 1 


* BENEFIT (monthly)
/*	-> €23.77/day if unemployed or earnings are less than €10,189/year (income group a)
	-> 70% on earnings between €10,189/year and €35,458/year (IG b)
	-> 40% on earnings between €35,458/year and €54,552/year (IG c)
	-> 25% on earnings above €54,552/year   (IG d) 									
*/


* IGa
replace pt_ben1 = 23.77 * 21.7 			if country == "FI" & year == 2013 & gender == 2 ///
									& pt_eli == 1 


									
* IGb
replace pt_ben1 = earning * 0.7 	if country == "FI" & year == 2013 & gender == 2 ///
									& pt_eli == 1 & inrange((earning*12),10189,35458)

									
									
									
* IGc 
gen pt_bena = (36687/12) * 0.7 		if country == "FI" & year == 2013 & gender == 2 ///
									& pt_eli == 1 & (earning*12) > 36687
			
gen pt_benb = (earning - (36687/12)) * 0.4 		///
									if country == "FI" & year == 2013	///
									& gender == 2 & pt_eli == 1 ///
									& inrange((earning*12),36687,54552)
															

replace pt_ben1 = pt_bena + pt_benb 		if country == "FI" ///
												& year == 2013	& gender == 2 ///
												& pt_eli == 1 & inrange((earning*12),36687,54552)			
			


* IGd	
gen pt_benc = (54552/12) * 0.4			if country == "FI" ///
													& year == 2013	& gender == 2 ///
													& pt_eli == 1 & (earning*12) > 54552
	
gen pt_bend = (earning - (54552/12)) * 0.25 		///
									if country == "FI" & year == 2013	///
									& gender == 2 & pt_eli == 1 ///
									& (earning*12) > 54552
									
									

replace pt_ben1 = pt_bena + pt_benc + pt_bend 		if country == "FI" ///
									& year == 2013	& gender == 2 & pt_eli == 1 ///
									& (earning*12) > 54552


replace pt_ben2 = pt_ben1 	if country == "FI" & year == 2013 & gender == 2 & pt_eli == 1
									

foreach x in 1 2 {
	replace pt_ben`x' = 0 	if pt_eli == 0 & country == "FI" & year == 2013
}

replace pt_dur = 0 if pt_eli == 0 & country == "FI" & year == 2013			
			
drop pt_bena pt_benb


