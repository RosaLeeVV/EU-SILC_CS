/* PL_2013_RO_eusilc_cs */

* ROMANIA - 2013

* ELIGIBILITY
/*	-> all residents: 12 months taxable personal income (coded) within the last 2 years (not coded)
			-> or 12 months of unemployment benefits, invalidity pension, temporary working incapacity benefit, etc. - 
					such data is provided at HH level in EU-SILC => not coded
*/

replace pl_eli = 1 			if country == "RO" & year == 2013 & duremp + dursemp >= 12

replace pl_eli =  0			if pl_eli == . & country == "RO" & year == 2013


* DURATION (weeks)
/*	-> benefit is a family entitlement => in couples, all is assigned to the woman
	-> parents can choose between 1 and 2 years of parental leave
		-> 1 year coded (more generous)
*/

* women	
replace pl_dur =  52 - ml_dur2		if country == "RO" & year == 2013 & pl_eli == 1 ///
										& gender == 1 

* single men
replace pl_dur = 52 - pt_dur - ml_dur2 		if country == "RO" & year == 2013 & pl_eli == 1 ///
												& gender == 2 & parstat == 1


* BENEFIT (monthly)
/*	-> 85% earning (net, but coded gross)
	-> ceiling until child is 1 year old: €761.6/month (6.8*RSI (RSI = €112), MISSOC 2014)
	-> ceiling until child is 2 years old: €268.8/month (2.4*RSI)
	-> minimum: €134.4/month (1.2*RSI)	*/
	
	* women
replace pl_ben1 = 0.85*earning 			if country == "RO" & year == 2013 & pl_eli == 1 ///
									& gender == 1
replace pl_ben1 = 134.4		 		if country == "RO" & year == 2013 & pl_eli == 1 ///
									& pl_ben1 < 134.4 & gender == 1
replace pl_ben1 = 761.6				if country == "RO" & year == 2013 & pl_eli == 1 ///
									& pl_ben1 >= 761.6 & gender == 1 


									
	* single men
replace pl_ben1 = 0.85*earning 			if country == "RO" & year == 2013 & pl_eli == 1 ///
									& gender == 2 & parstat == 1
replace pl_ben1 = 134.4		 		if country == "RO" & year == 2013 & pl_eli == 1 ///
									& pl_ben1 < 134.4 & gender == 2 & parstat == 1
replace pl_ben1 = 761.6		 		if country == "RO" & year == 2013 & pl_eli == 1 ///
									& pl_ben1 >= 761.6 & gender == 2 & parstat == 1 	



replace pl_ben2 = pl_ben1			if country == "RO" & year == 2013 & pl_eli == 1



foreach x in 1 2 {
    
	replace pl_ben`x' = 0 	if pl_eli == 0 & country == "RO" & year == 2013
}

replace pl_dur = 0 	if country == "RO" & year == 2013 & pl_eli == 0
