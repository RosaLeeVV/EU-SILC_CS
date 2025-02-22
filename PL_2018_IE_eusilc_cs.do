/* PL_2018_IE_eusilc_cs

date created: 26/03/2021

*/

* IRELAND - 2018

* ELIGIBILITY
/*	-> employed
	-> who completed at least 12 months (coded) with their current employer (not coded; LP&R 2018)
*/
replace pl_eli = 1 			if country == "IE" & year == 2018 & econ_status == 1 ///
							& duremp >= 12
replace pl_eli = 0 			if pl_eli == . & country == "IE" & year == 2018


* DURATION (weeks)
/*	-> 18 weeks
	-> before child's 8th birthday
*/
replace pl_dur = 18 		if country == "IE" & year == 2018 & pl_eli == 1


* BENEFIT (monthly)
/*	-> unpaid */

replace pl_ben1 = 0 		if country == "IE" & year == 2018 & pl_eli == 1
replace pl_ben2 = 0 		if country == "IE" & year == 2018 & pl_eli == 1


foreach x in 1 2 {
	replace pl_ben`x' = 0 	if pl_eli == 0 & country == "IE" & year == 2018
}

replace pl_dur = 0 	if pl_eli == 0 & country == "IE" & year == 2018
