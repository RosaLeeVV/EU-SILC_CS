/* PL_2013_HR_eusilc_cs */


* CROATIA - 2013

* ELIGIBILITY
/*	-> all parents but conditions and benefits differ by categories

	-> parental leave is an individual transferable entitlement (LP&R 2013) => assigned to women

	-> employed: parental leave
		-> 12 months of continual insurance (coded) or 18 months of non-continual insurance (not coded) during past 2 years (not coded)
	-> self-employed: parental leave
	-> unemployed: parental exemption from work	
	-> inactive: parental care for a child
		
*/

replace pl_eli = 1 		if country == "HR" & year == 2013
replace pl_eli = 0 		if pl_eli == . & country == "HR" & year == 2013



* DURATION (weeks)
/*	-> parental leave/parental exemption from work: 90 days/parent/child
		-> additional 2 months if father uses his share of leave (not coded)
	-> parental care for the child: 6 months (from the age of 6 months until child is 1 year old)
		-> for 3rd + child: until child is 3 years old
  										*/
   
replace pl_dur = (90+90)/5 		if country == "HR" & year == 2013 & pl_eli == 1 ///
						& inrange(econ_status,1,3) & gender == 1
						
replace pl_dur = (6 * 4.3) 		if country == "HR" & year == 2013 & pl_eli == 1 ///
						& econ_status == 4 & gender == 1
						
						
				


* BENEFIT (monthly)
/*	-> Employed & self-employd: 
		-> 100% for the first 6 months
		-> if don't fulfill the 12 months insurance condition: 50% of the budgetary base rate (€439, LP&R 2013) for the remaining 2 months 
		-> ceiling: 80% budgetary base rate
		
	-> unemployed & inactive:
		-> 50% of the budgetary base rate per month = € 439/month
*/

replace pl_ben1 = earning 		if country == "HR" & year == 2013 & pl_eli == 1 ///
								& inlist(econ_status,1,2) & (duremp+dursemp) >= 12 & gender == 1
								
replace pl_ben1 = (439*2) * 0.8 	if country == "HR" & year == 2013 & pl_eli == 1 ///
						& inlist(econ_status,1,2) & (duremp+dursemp) >= 12 & earning > 351
						
replace pl_ben1 = 439 	if country == "HR" & year == 2013 & pl_eli == 1 ///
						& pl_ben1 == . & pl_eli == 1
						

						

replace pl_ben2 = pl_ben1   	if country == "HR" & year == 2013 & pl_eli == 1 


 foreach x in 1 2 {
	replace pl_ben`x' = 0 	if pl_eli == 0 & country == "HR" & year == 2013
}

replace pl_dur = 0 	if pl_eli == 0 & country == "HR" & year == 2013
