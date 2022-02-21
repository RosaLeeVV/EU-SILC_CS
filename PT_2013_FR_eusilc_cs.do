/* PT_2013_FR_eusilc_cs */


* FRANCE - 2013

* ELIGIBILITY
/*	-> employed
	-> self-employed 
*/

replace pt_eli = 1 		if country == "FR" & year == 2013 & gender == 2 ///
						& inlist(econ_status,1,2) 
replace pt_eli = 0 		if pt_eli == . & country == "FR" & year == 2013 & gender == 2


* DURATION (weeks)
/*	-> 11 days
	-> multiple births: 18 days  (not coded)
	-> must be taken within 4 months after childbirth (not coded)	*/ 
	
replace pt_dur = 11/5 	if country == "FR" & year == 2013 & pt_eli == 1


* BENEFIT (monthly)
/*	-> 100%
	-> minimum: €9.20/day
	-> ceiling: €80.15/ day
	-> no ceiling in public sector (not coded; LP&R 2013)
	-> source: MISSOC 01/07/2013	*/ 

replace pt_ben1 = earning 		if country == "FR" & year == 2013 & pt_eli == 1 ///
								& pt_ben1 == .
	
* ceiling
replace pt_ben1 = ((80.15*11) * (11/21.7)) + (earning * ((21.7-11)/21.7)) ///
											if country == "FR" & year == 2013  ///
											& pt_eli == 1 & pt_ben1/21.7 >= 80.15
	

* minimum
replace pt_ben1 = ((9.20*11) * (11/21.7)) + (earning * ((21.7-11)/21.7)) ///
											if country == "FR" & year == 2013  ///
											& pt_eli == 1 & pt_ben1/11 < (9.20*5)

											

replace pt_ben2 = pt_ben1 		if country == "FR" & year == 2013 & pt_eli == 1


foreach x in 1 2 {
	replace pt_ben`x' = 0 	if pt_eli == 0 & country == "FR" & year == 2013
}

replace pt_dur = 0 if pt_eli == 0 & country == "FR" & year == 2013
	
	
