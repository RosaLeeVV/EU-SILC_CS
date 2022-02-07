/* PL_2013_BG_eusilc_cs */


* BULGARIA - 2013

* ELIGIBILITY
/* 	-> Parental leave is specifically designed for women (LP&R 2013)
	-> All women are entitled to a cash benefit. 
	
	-> single father is not automatically entitled - mother's consent is required => not coded
   Source: MISSOC 01/07/2013										*/

replace pl_eli = 1 	if country == "BG" & year == 2013 & gender == 1
replace pl_eli = 0 	if pl_eli == . & country == "BG" & year == 2013 


* DURATION (weeks)
/*	-> employed for at least 12 months: until child is 2 (coded: minus postnatal ML)
	-> all other women: until child is 1 year old			
	Source: MISSOC 01/07/2013										
*/
   
replace pl_dur = (2*52) - ml_dur2 		if country == "BG" & year == 2013 & pl_eli == 1 ///
										& gender == 1 & econ_status == 1 & duremp >= 12 ///
										& ml_eli == 1
replace pl_dur = 52 		if country == "BG" & year == 2013 & pl_eli == 1 ///
							& gender == 1 & pl_dur == . & pl_eli == 1



* BENEFIT (monthly)
/*	-> women employed for at least 12 months: €179/month
	-> all other women: €51/month
	Source: MISSOC 01/07/2013*/
   
replace pl_ben1 = 179	 if country == "BG" & year == 2013 & pl_eli == 1 ///
						 & gender == 1 & econ_status == 1 & duremp >= 12
replace pl_ben1 = 51	 if country == "BG" & year == 2013 & pl_eli == 1 ///
						 & gender == 1 & pl_ben1 == . & pl_eli == 1 


replace pl_ben2 = pl_ben1 	if country == "BG" & year == 2013 & pl_eli == 1 ///
							& gender == 1

							
foreach x in 1 2 {
	replace pl_ben`x' = 0 	if pl_eli == 0 & country == "BG" & year == 2013
}

replace pl_dur = 0 	if pl_eli == 0 & country == "BG" & year == 2013
