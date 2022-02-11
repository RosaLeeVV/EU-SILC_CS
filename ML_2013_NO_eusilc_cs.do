/* ML_2013_NO_eusilc_cs */

/*	Norway doesn't recognise ML and PT but only PL with individual entitlements for mother
	and father, and family entitlement. 
	The information here refers to the individual entitlement for mothers (mother's quota).
	Additional source: https://familie.nav.no/om-foreldrepenger#hvor-lenge-kan-du-fa-foreldrepenger
	Accessed: 01/04/2021
*/

* NORWAY - 2013

* ELIGIBILITY
/*	-> any economic activity if they were employed or self-employed for at least 6 months
		during 10 months (not coded) before birth (compulsory social insurance for employed & self-employed) 
		- receipt of sickness, unemployment or parental leave benefit counts towards the 6 months (coded)
			but EU-SILC collects this information on a HH level => not coded 
		- applies to: mothers, fathers whose female partner doesn't fulfill the conditions, single father
*/

* only woman is eligibile
replace ml_eli = 1 			if country == "NO" & year == 2013 & gender == 1 ///
							& (duremp + dursemp) >= 6  & (p_duremp + p_dursemp) < 6

* both partners are eligible
replace ml_eli = 1 			if country == "NO" & year == 2013 & gender == 1 ///
							& (duremp + dursemp) >= 6  & (p_duremp + p_dursemp) >= 6

* only man is eligible							
replace ml_eli = 1 			if country == "NO" & year == 2013 & gender == 2 ///
							& (duremp + dursemp) >= 6  & (p_duremp + p_dursemp) < 6

* single man							
replace ml_eli = 1			if country == "NO" & year == 2013 & gender == 2 ///
							& (duremp + dursemp) >= 6  & parstat == 1


replace ml_eli = 0 			if ml_eli == . & country == "NO" & year == 2013 & gender == 1


* DURATION (weeks)
/*	-> prenatal: 3 weeks compulsory
	-> total: 15 weeks
	-> postnatal: 6 weeks compulsory for mother (non-transferable) 	
	-> father, when mother is not eligible: 6 weeks
	-> single father: 12 weeks
	-> parents can choose between 2 options for the whole leave:
		- 49 weeks on 100% earning
		- 59 weeks on 80% earning
*/

replace ml_dur1 = 3 		if country == "NO" & year == 2013 & ml_eli == 1 & gender == 1

* both partners are eligible
replace ml_dur2 = 15-3 		if country == "NO" & year == 2013 & ml_eli == 1 & gender == 1 ///
							& (duremp + dursemp) >= 6  & (p_duremp + p_dursemp) >= 6

* only man is eligible
replace ml_dur2 = 6 		if country == "NO" & year == 2013 & gender == 2 ///
							& (duremp + dursemp) >= 6  & (p_duremp + p_dursemp) < 6

* single man
replace ml_dur2 = 12		if country == "NO" & year == 2013 & gender == 2 ///
							& (duremp + dursemp) >= 6  & parstat == 1

							
							

* BENEFIT (monthly)
/*	-> 100% earning
	-> ceiling: €64,464/year
	-> minimum: maternity grant - €4,444 for the whole period (11 months)
*/
	
replace ml_ben1 = earning 		if country == "NO" & year == 2013 & ml_eli == 1
replace ml_ben1 = 64464/12			if country == "NO" & year == 2013 & ml_eli == 1 ///
								& ml_ben1 >= 64464/12
replace ml_ben1 = 4444/11			if country == "NO" & year == 2013 & ml_eli == 1 ///
								& ml_ben1 < 4444/11


replace ml_ben2 = ml_ben1 		if country == "NO" & year == 2013 & ml_eli == 1


foreach x in 1 2 {
	replace ml_dur`x' = 0 	if country == "NO" & year == 2013 & ml_eli == 0
	replace ml_ben`x' = 0 	if country == "NO" & year == 2013 & ml_eli == 0
	
}
