/* PT_2013_SI_eusilc_cs */


* SLOVENIA - 2013

* ELIGIBILITY
/*	-> employed
	-> self-employed
	-> unemployed, inactive if they were compulsorily insured for at least 12 months (coded)
		over the past 3 years (not coded; LP&R 2013)
	-> benefits for unemployed and inactive people are not clearly specified in the sources => not coded
	
*/

replace pt_eli = 1 			if country == "SI" & year == 2013 & gender == 2 ///
							& inlist(econ_status,1,2) 
replace pt_eli = 1 			if country == "SI" & year == 2013 & gender == 2 ///
							& inlist(econ_status,3,4) & (duremp + dursemp) >= 12	
	

* DURATION (weeks)
/*	-> 90 calendar days in total
*/

replace pt_dur = 90/7 	if country == "SI" & year == 2013 & pt_eli == 1


* BENEFIT (monthly)
/*	-> 90% earnings for 15 days
	-> 75 days unpaid
	-> ceiling: €2,863/month (LP&R 2013) 	
	-> minimum: €323.55/month (LP&R 2013)		*/

replace pt_ben1 = (0.9*earning) * (15/70) 	 if country == "SI" & year == 2013 & pt_eli == 1 
replace pt_ben1 = 323.55	 	 	if country == "SI" & year == 2013 & pt_eli == 1 ///
									& (0.9*earning) < 323.55
replace pt_ben1 = 2863		 	 	if country == "SI" & year == 2013 & pt_eli == 1 ///
									& (0.9*earning) > 2863


replace pt_ben2 = (0.9*earning) * (20/21.7) 	if country == "SI" & year == 2013 & pt_eli == 1
replace pt_ben2 = pt_ben1 	if country == "SI" & year == 2013 & pt_eli == 1 if ((0.9*earning) < 790.73 | (0.9*earning) > 2863)

foreach x in 1 2 {
	replace pt_ben`x' = 0 	if pt_eli == 0 & country == "SI" & year == 2013
}

replace pt_dur = 0 if pt_eli == 0 & country == "SI" & year == 2013
