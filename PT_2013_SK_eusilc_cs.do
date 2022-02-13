/* PT_2013_SK_eusilc_cs */

/*
*** NOTE: No statutory right to paternity leave. The individual entitlements 
		  for fathers is a hybrid between individual transferable right (mother) 
		  and individual entitlement (father). Father can use the entitlement 
		  when the mother of the child agrees with him providing full-time care 
		  for the child, when the mother dies, cannot provide care, or abandons
		  the child. Father can use the right after mother's entitlement to maternity
		  leave expires.
		  Source: z.c. 461/2003 z.z., zakon o socialnom poisteni 				
		  (https://www.zakonypreludi.sk/zz/2003-461/znenie-20210101#cast1-hlava2-diel5)
		  accessed: 30/03/2021
*/

* SLOVAKIA - 2013

* ELIGIBILITY
/*	-> employed, self-employed
	-> 270 calendar days (coded) 
		of work during the past 2 years	(not coded) 	
	-> single fathers can also claim "ML" - already coded in ml_eli!	*/
	
replace pt_eli = 1 		if country == "SK" & year == 2013 & gender == 2 ///
						& inlist(econ_status,1,2) & (duremp+dursemp) >= 270/30 & parstat == 2
		
						
replace pt_eli = 0 		if pt_eli == . & country == "SK" & year == 2013 & gender == 2



* DURATION (weeks)
/*	-> 28 weeks
	-> single fathers: 31 weeks (coded in ml_eli) */
	
replace pt_dur = 28 	if country == "SK" & year == 2013 & pt_eli == 1 


* BENEFIT (monthly)
/*	-> 65% average earnings
	-> ceiling: monthly ceiling 1.5-times of national average monthly wage (€889).
	
	source: Statistical Office of the Slovak Republic, Average monthly wage of employee 
		in economy of the SR in the 3rd quarter of 2013, shorturl.at/stvAT , accessed 30.12.2021	*/
	
replace pt_ben1 = 0.65*earning 		if country == "SK" & year == 2013 & pt_eli == 1
replace pt_ben1 = 1.5*889		 		if country == "SK" & year == 2013 & pt_eli == 1 ///
									& pt_ben1 >= 1.5*889


replace pt_ben2 = pt_ben1 	if country == "SK" & year == 2013 & pt_eli == 1

foreach x in 1 2 {
	replace pt_ben`x' = 0 	if pt_eli == 0 & country == "SK" & year == 2013
}

replace pt_dur = 0 if pt_eli == 0 & country == "SK" & year == 2013
