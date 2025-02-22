/* PL_2018_DK_eusilc_cs

date created: 24/03/2021

*/

* DENMARK - 2018


* ELIGIBILITY
/* -> employed
	-> self-employed
	-> unemployed (from unemployment insurance)	
	-> students (extra student grant; pl031 == 6)
*/

replace pl_eli = 1	 		if country == "DK" & year == 2018 & inlist(econ_status,1,2,3) 
replace pl_eli = 1	 		if country == "DK" & year == 2018 & pl031 == 6
							

replace pl_eli = 0 			if pl_eli == . & country == "DK" & year == 2018


* DURATION (weeks)
/*	-> 32 weeks per parent
	-> maximum duration in total: 32 weeks
		-> couples: all assigned to woman
		-> single men: all assigned to them
*/

* couples => to women	
replace pl_dur = 32 		if country == "DK" & year == 2018 & pl_eli == 1 & gender == 1

* single men
replace pl_dur = 32 		if country == "DK" & year == 2018 & pl_eli == 1 & gender == 2 ///
							& parstat == 1



* BENEFIT (monthly)
/* 	-> employed, self-employed: 100% earning
	-> ceiling: €577/week 	
	-> unemployed: unemployment benefits (not coded)
	-> students: extra 12 months of study grant (not coded) 
	-> the entitlement to benefit is a family entitlement => assigned to women 
	-> assigned to single men
*/
	
replace pl_ben1 = earning 		if country == "DK" & year == 2018 & pl_eli == 1 ///
								& inlist(econ_status,1,2) & earning/4.3 < 577 ///
								& gender == 1

replace pl_ben1 = 577*4.3		if country == "DK" & year == 2018 & pl_eli == 1 ///
								& inlist(econ_status,1,2) & pl_ben1/4.3 >= 577 ///
								& pl_ben1 == . & gender == 1

* single men
replace pl_ben1 = earning 		if country == "DK" & year == 2018 & pl_eli == 1 ///
								& inlist(econ_status,1,2) & earning/4.3 < 577 ///
								& gender == 2 & parstat == 1

replace pl_ben1 = 577*4.3		if country == "DK" & year == 2018 & pl_eli == 1 ///
								& inlist(econ_status,1,2) & pl_ben1/4.3 >= 577 ///
								& pl_ben1 == . & gender == 2 & parstat == 1


replace pl_ben2 = pl_ben1 		if country == "DK" & year == 2018 & pl_eli == 1 ///
								& gender == 1

foreach x in 1 2 {
	replace pl_ben`x' = 0 	if pl_eli == 0 & country == "DK" & year == 2018
}

replace pl_dur = 0 	if pl_eli == 0 & country == "DK" & year == 2018
