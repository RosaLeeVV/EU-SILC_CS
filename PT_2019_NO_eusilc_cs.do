/* PT_2019_NO_eusilc_cs

date created: 12/08/2021

*/

/*	Norway doesn't recognise ML and PT but only PL with individual entitlements for mother
	and father, and family entitlement. 
	The information here refers to the individual entitlement for fathers (father's quota).
	Additional source: https://familie.nav.no/om-foreldrepenger#hvor-lenge-kan-du-fa-foreldrepenger
	Accessed: 01/04/2021
*/

* NORWAY - 2019

* ELIGIBILITY
/*	-> any economic activity if they were employed or self-employed for at least 6 months
		during 10 months before birth (compulsory social insurance for employed & self-employed) 
		- receipt of sickness, unemployment or parental leave benefit counts towards the 6 months
			but EU-SILC collects this information on a HH level => not coded 
		- applies to: fathers, mothers whose male partner doesn't fulfill the conditions, single mother
*/

* only man is eligibile
replace pt_eli = 1 			if country == "NO" & year == 2019 & gender == 2 ///
							& (duremp + dursemp) >= 6  & (p_duremp + p_dursemp) < 6

* both partners are eligible
replace pt_eli = 1 			if country == "NO" & year == 2019 & gender == 2 ///
							& (duremp + dursemp) >= 6  & (p_duremp + p_dursemp) >= 6

* only woman is eligible							
replace pt_eli = 1 			if country == "NO" & year == 2019 & gender == 1 ///
							& (duremp + dursemp) >= 6  & (p_duremp + p_dursemp) < 6

* single woman							
replace pt_eli = 1			if country == "NO" & year == 2019 & gender == 2 ///
							& (duremp + dursemp) >= 6  & parstat == 1

replace pt_eli = 0 			if pt_eli == . & country == "NO" & year == 2019 & gender == 2


* DURATION (weeks)
/*	-> 15 weeks
	-> mother, when father is not eligible: 15 weeks
	-> single mother: 15 weeks
	-> parents can choose between 2 options for the whole parental leave:
		- 49 weeks on 100% earning
		- 59 weeks on 80% earning
*/

* both are eligible and only man is eligible
replace pt_dur = 15 		if country == "NO" & year == 2019 & pt_eli == 1 & gender == 2 ///
							& (duremp + dursemp) >= 6  & (p_duremp + p_dursemp) < 6
replace pt_dur = 15 		if country == "NO" & year == 2019 & gender == 2 ///
							& (duremp + dursemp) >= 6  & (p_duremp + p_dursemp) >= 6

* only woman is eligible 
replace pt_dur = 15 		if country == "NO" & year == 2019 & pt_eli == 1 & gender == 1 ///
							& (duremp + dursemp) >= 6  & (p_duremp + p_dursemp) < 6

* single woman
replace pt_dur = 15			if country == "NO" & year == 2019 & pt_eli == 1 & gender == 1 ///
							& parstat == 1



* BENEFIT (monthly)
/*	-> 100% earning
	-> ceiling: €61,868/year  
	-> minimum: maternity grant - €8,585 for the whole period (11 months)
*/

replace pt_ben1 = earning 		if country == "NO" & year == 2019 & pt_eli == 1
replace pt_ben1 = 61868/12		if country == "NO" & year == 2019 & pt_eli == 1 ///
								& pt_ben1 >= 61868/12
replace pt_ben1 = 8585/11		if country == "NO" & year == 2019 & pt_eli == 1 ///
								& pt_ben1 < 8585/11


replace pt_ben2 = ml_ben1 		if country == "NO" & year == 2019 & pt_eli == 1





foreach x in 1 2 {
	replace pt_ben`x' = 0 	if country == "NO" & year == 2019 & pt_eli == 0
}

replace pt_dur = 0 		if country == "NO" & year == 2019 & pt_eli == 0 
