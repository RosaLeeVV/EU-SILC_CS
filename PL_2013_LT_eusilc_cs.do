/* PL_2013_LT_eusilc_cs */


* LITHUANIA - 2013

* ELIGIBILITY
/*	-> employed, self-employed for 12 months (coded) in past 2 years (not coded)
	-> family entitlement => in couples assigned to women
*/

replace pl_eli = 1 			if country == "LT" & year == 2013 & inlist(econ_status,1,2) ///
							& (duremp+dursemp) >= 12

							
replace pl_eli =  0			if pl_eli == . & country == "LT" & year == 2013


* DURATION (weeks)
/*	-> parents can choose the duration of leave => affects benefits
	-> until child is 3 years old
		-> choose 1 year = 100% earning
		-> choose 2 years = 70% earning
		-> 3rd year unpaid
	-> more generous option coded (until child is 1)		*/

* women	
replace pl_dur = 52-ml_dur2 		if country == "LT" & year == 2013 & pl_eli == 1 ///
									& gender == 1

* single men
replace pl_dur = 52-pt_dur 			if country == "LT" & year == 2013 & pl_eli == 1 ///
									& gender == 2 & parstat == 1
									

									


* BENEFIT (monthly)
/* 	-> choice of leave until child is 1: 100%
		-> ceiling: €1,379/month (coded)
	-> choice of leave until child is 2: 70%
		-> ceiling: €965.30/month 
		
replace pl_ben1 = 0.7*earning 		if country == "LT" & year == 2013 & pl_eli == 1
								
replace pl_ben1 = 1379	 		if country == "LT" & year == 2013 & pl_eli == 1 ///
								& pl_ben1 >= 1379


replace pl_ben2 = pl_ben1		if country == "LT" & year == 2013 & pl_eli == 1

foreach x in 1 2 {
	replace pl_ben`x' = 0 	if pl_eli == 0 & country == "LT" & year == 2013
}

replace pl_dur = 0 	if pl_eli == 0 & country == "LT" & year == 2013
