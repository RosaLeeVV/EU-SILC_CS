/* PL_2012_HR_eusilc_cs */


* CROATIA - 2012

* ELIGIBILITY
/*	-> all parents but conditions and benefits differ by categories

	-> parental leave is an individual partially transferable (3 months) entitlement (LP&R 2012)

	-> employed: parental leave
	-> self-employed: parental leave
	-> unemployed: parental exeption from work	
	-> inactive: parental care for a child
		
*/

replace pl_eli = 1 		if country == "HR" & year == 2012
replace pl_eli = 0 		if pl_eli == . & country == "HR" & year == 2012



* DURATION (weeks)
/*	-> 3 months/parent/child
  										*/
   
replace pl_dur = 3 		if country == "HR" & year == 2012 & pl_eli == 1 ///
						& inlist(econ_status,1,2) 
						
						
				


* BENEFIT (monthly)
/*	-> Employed & self-employd: 
		-> 100% for the first 6 months
		-> 50% of the budgetary base rate for the remaining 2 months 
		-> ceiling: 80% budgetary base rate
		
	-> all others:
		-> 50% of the budgetary base rate per month 
*/

replace pl_ben1 = earning 		if country == "HR" & year == 2012 & pl_eli == 1 ///
								& inlist(econ_status,1,2) & (duremp+dursemp) >= 12 & gender == 1
								
replace pl_ben1 = (earning * (2/4)) + (439*0.5) * (2/4)) if country == "HR" & year == 2012 & pl_eli == 1 ///
								& inlist(econ_status,1,2) & (duremp+dursemp) >= 12 & gender == 2

replace pl_ben1 = 351 	if country == "HR" & year == 2012 & pl_eli == 1 ///
						& inlist(econ_status,1,2) & (duremp+dursemp) >= 12 & earning > 351
						
replace pl_ben1 = 439*0.5 	if country == "HR" & year == 2012 & pl_eli == 1 ///
						& pl_ben1 == . & pl_eli == 1
						

						

replace pl_ben2 = earning  	if country == "HR" & year == 2012 & pl_eli == 1 ///
								& inlist(econ_status,1,2) & (duremp+dursemp) >= 12
replace pl_ben2 = 351 		if country == "HR" & year == 2012 & pl_eli == 1 ///
						& inlist(econ_status,1,2) & (duremp+dursemp) >= 12 & earning > 351
						
replace pl_ben2 = 439*0.5 	if country == "HR" & year == 2012 & pl_eli == 1 ///
						& pl_ben1 == . & pl_eli == 1

 foreach x in 1 2 {
	replace pl_ben`x' = 0 	if pl_eli == 0 & country == "HR" & year == 2012
}

replace pl_dur = 0 	if pl_eli == 0 & country == "HR" & year == 2012
