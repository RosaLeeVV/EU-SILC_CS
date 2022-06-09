/* PL_2011_BG_eusilc_cs */


* BULGARIA - 2011

* ELIGIBILITY
/* 	-> Parental leave is specifically designed for women (LP&R 2011)
	-> All women are entitled to a cash benefit. 
	
	-> single father is not automatically entitled - mother's consent is required => not coded
   Source: MISSOC 01/07/2011										*/

replace pl_eli = 1 	if country == "BG" & year == 2011 & gender == 1
replace pl_eli = 0 	if pl_eli == . & country == "BG" & year == 2011 


* DURATION (weeks)
/*	-> until child is 2 (coded: minus postnatal ML)			
	Source: MISSOC 01/07/2011										
*/
   
replace pl_dur = (2*52) - ml_dur2 		if country == "BG" & year == 2011 & pl_eli == 1 ///
										& gender == 1 & ml_eli == 1


* BENEFIT (monthly)
/*	-> €123/month
	Source: MISSOC 01/07/2011*/
   
replace pl_ben1 =  123	 if country == "BG" & year == 2011 & pl_eli == 1 ///
						 & gender == 1 



replace pl_ben2 = pl_ben1 	if country == "BG" & year == 2011 & pl_eli == 1 ///
							& gender == 1

							
foreach x in 1 2 {
	replace pl_ben`x' = 0 	if pl_eli == 0 & country == "BG" & year == 2011
}

replace pl_dur = 0 	if pl_eli == 0 & country == "BG" & year == 2011
