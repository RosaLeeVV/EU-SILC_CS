/* PL_2013_LU_eusilc_cs */

* LUXEMBOURG - 2013

* ELIGIBILITY
/*	-> employed
	-> self-employed 	
	-> worked for at least 12 months (coded) at a minimum of 20h/week before childbirth with the same employer (not coded) 	
	-> not transferable
	-> can be taken simultaneously
	
	-> Source: https://cae.public.lu/en/conge-parental.html , accessed 6.12.2021 	*/
	
replace pl_eli = 1 			if country == "LU" & year == 2013 & inlist(econ_status,1,2) ///
							& (duremp+dursemp) >= 12
							

replace pl_eli =  0			if pl_eli == . & country == "LU" & year == 2013


* DURATION (weeks)
/*	-> 6 months per parent. Leave is an individual entitlement
	-> first parental leave must be taken immediately after maternity leave (not coded)
	-> second parental leave can be taken anytime until child is 6 years old (not coded)
	
*/
replace pl_dur = 6*4.3 		if country == "LU" & year == 2013 & pl_eli == 1


* BENEFIT (monthly)
/*	flat-rate: €1,778/month  	*/
		
replace pl_ben1 = 1778 		if country == "LU" & year == 2013 & pl_eli == 1
replace pl_ben2 = pl_ben1		if country == "LU" & year == 2013 & pl_eli == 1


foreach x in 1 2 {
	replace pl_ben`x' = 0 	if pl_eli == 0 & country == "LU" & year == 2013
}

replace pl_dur = 0 	if pl_eli == 0 & country == "LU" & year == 2013
