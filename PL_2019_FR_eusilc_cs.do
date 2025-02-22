/* PL_2019_FR_eusilc_cs

date created: 24/08/2021

*/

* FRANCE - 2019

* ELIGIBILITY
/*	-> employed (parental leave)
	-> benefits are available to all parents 	*/
	
replace pl_eli = 1 			if country == "FR" & year == 2019 
replace pl_eli = 0 			if pl_eli == . & country == "FR" & year == 2019


* DURATION (weeks)
/*	-> each parent is entitled to 24 months
	-> the total leave per child cannot exceed their 3rd birthday => larger share of leave assigned to woman 
	-> first child: 6 months of benefits/parent 
	-> 2+ children: 24 months/parent, max. total period 36 months
		=> mother assigned 24 months, father 12 months 
*/

* men and women with one hypothetical child										
replace pl_dur = 6 						if country == "FR" & year == 2019 ///
										& childc == 0 & pl_dur == .


* women with at least one child, eligible for ML	
replace pl_dur = (2*52) - ml_dur2 		if country == "FR" & year == 2019 ///
										& pl_eli == 1 & gender == 1 & ml_eli == 1 ///
										& childc >= 1

* women with at least one child, not eligible for ML										
replace pl_dur = 2*52 			if country == "FR" & year == 2019 & gender == 1 ///
								& pl_eli == 1 & pl_dur == . & childc >= 1
										
* men, cohabiting, at least one child
replace pl_dur = 52	 					if country == "FR" & year == 2019 ///
										& pl_eli == 1 & gender == 2 & childc >= 1 ///
										& parstat == 2 & pl_dur == .
										
* single men, at least one child
replace pl_dur = 2*52	 				if country == "FR" & year == 2019 ///
										& pl_eli == 1 & gender == 2 & childc >= 1 ///
										& parstat == 1 & pl_dur == .


								

* BENEFIT (monthly)
/*	-> €397.20/month for full-time leave
	-> lower income parents: supplementary means-tested allowance (lower income not specified => not coded; LP&R 2019) 
*/

replace pl_ben1 = 397.20		if country == "FR" & year == 2019 & pl_eli == 1
replace pl_ben2 = pl_ben1 		if country == "FR" & year == 2019 & pl_eli == 1


foreach x in 1 2 {
	replace pl_ben`x' = 0 	if pl_eli == 0 & country == "FR" & year == 2019
}

 replace pl_dur = 0 	if pl_eli == 0 & country == "FR" & year == 2019
