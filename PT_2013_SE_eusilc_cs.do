/* PT_2013_SE_eusilc_cs */

/*	Sweden doesn't distinguish between ML and PT but only recognizes PARENTAL LEAVE, 
	which is a combination of individual non-transferable and individual transferable
	rights for each parent. 
	The PT data code the share of PARENTAL LEAVE that is individual non-transferable
	right of the father AND paternity leave in connection with childbirth.
*/

* SWEDEN - 2013

* ELIGIBILITY
/*	-> all men are eligible for cash benefits (vary by economic status)
	-> single women: eligible for father's share
*/

replace pt_eli = 1 		if country == "SE" & year == 2013 & gender == 2 

* single women
replace pt_eli = 1		if country == "SE" & year == 2013 & gender == 1 & parstat == 1

replace pt_eli = 0 		if pt_eli == . & country == "SE" & year == 2013 & gender == 2


* DURATION (weeks)
/*	-> total: 90 calendar days 
	-> leave in connection with childbirth: 10 calendar days 	
*/

replace pt_dur = (90/7) + (10/7)		 	if country == "SE" & year == 2013 & pt_eli == 1


* BENEFIT (monthly)
/*	-> 10 days: 77.6% earning
		- ceiling: €38,331/year - this is earning ceiling NOT benefit ceiling 
		- minimum: not specified, also not specified whether only for working parents => 
			assumed identical with the 90 days 
	-> 90 days: 77.6% earning
			- minimum: €26/day
			- ceiling: €51116/year - this is an earning ceiling NOT benefit ceiling (LP&R 2013)
*/


replace pt_ben1 = 0.776 * earning 		if country == "SE" & year == 2013 & pt_eli == 1 ///
										& (earning/21.7) >= 25

replace pt_ben1 = 26 * 21.7				if country == "SE" & year == 2013 & pt_eli == 1 ///
										& (earning/21.7) < 26

replace pt_ben1 = ((0.776 * (38331/12)) * (10/(90+10))) + ((0.776 * earning) * (90/(90+10))) ///
										if country == "SE" & year == 2013 & pt_eli == 1 ///
										& inrange((earning*12),38331,51116)

replace pt_ben1 = ((0.776 * (38331/12)) * (10/(90+10)))	+ ((0.776 * (51116/12)) * (90/(90+10))) ///
											if country == "SE" & year == 2013 & pt_eli == 1 ///
											& earning > 51116/12

	
	
	
replace pt_ben2 = 0.776*earning 		if country == "SE" & year == 2013 & pt_eli == 1 ///
										& (earning/21.7) >= 25

replace pt_ben2 = 26*21.7				if country == "SE" & year == 2013 & pt_eli == 1 ///
										& (earning/21.7) < 26
										
replace pt_ben2 = ((0.776 * (38331/12)) * (10/21.7)) + ((0.776 * earning) * ((21.7-10)/21.7)) ///
										if country == "SE" & year == 2013 & pt_eli == 1 ///
										& inrange((earning*12),38331,51116)
										
replace pt_ben2 = ((0.776 * (38331/12)) * (10/21.7)) + ((0.776 * (51116/12)) * ((21.7-10)/21.7)) ///
										if country == "SE" & year == 2013 & pt_eli == 1 ///
										& earning > 51116/12
								
										




foreach x in 1 2 {
	replace pt_ben`x' = 0 	if country == "SE" & year == 2013 & pt_eli == 0
}

replace pt_dur = 0 		if country == "SE" & year == 2013 & pt_eli == 0 
