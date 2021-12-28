/* PT_2016_CZ_eusilc_cs */


* Czechia - 2016

* ELIGIBILITY
/*	-> 	employed (insured) */
replace pt_eli = 1 		if country == "CZ" & year == 2016 & gender == 2 ///
						& econ_status == 1
replace pt_eli = 0 		if pt_eli == . & country == "CZ" & year == 2016 & gender == 2


* DURATION (weeks)
/*	-> 7 days */
replace pt_dur = 7/5  	if country == "CZ" & year == 2016 & gender == 2 & pt_eli == 1 // MISSOC 01/07/2016


* BENEFIT (monthly)
/*	-> daily assessment base:
		-> Benefits are not calculated from earnings but from a "daily assessment base" (MISSOC 01/07/2016) 
		-> up to €33/day = 100% daily earning
		-> €38 - €58/day = 60% daily earning
		-> €58/day = 30% daily earning  
		-> earning over €115/day are not taken into account
	
	-> 70% of daily assessment base
	-> ceiling: €47/day 
*/

** DAILY ASSESSMENT BASE

* daily earning < €33
gen dab = earning/21.7 				if country == "CZ" & year == 2016 & pt_eli == 1 ///
									& earning/21.7 < 33
									
* daily earning between €33 and €50
gen dab1 = 33 						if country == "CZ" & year == 2016 & pt_eli == 1 ///
									& inrange(earning/21.7,33,50)
gen dab2 = ((earning/21.7) - 33)*0.6 	if country == "CZ" & year == 2016 & pt_eli == 1 ///
										& inrange(earning/21.7,33,50)
replace dab = dab1 + dab2 				if country == "CZ" & year == 2016 & pt_eli == 1 ///
										& inrange(earning/21.7,33,50) & dab == .
drop dab1 dab2
										
* daily earning between €50 adn €100										
gen dab1 = 33 						if country == "CZ" & year == 2016 & pt_eli == 1 ///
									& inrange(earning/21.7,50,100)
gen dab2 = (50 - 33)*0.6 			if country == "CZ" & year == 2016 & pt_eli == 1 ///
									& inrange(earning/21.7,50,100)
gen dab3 = ((earning/21.7) - 50)*0.3 	if country == "CZ" & year == 2016 & pt_eli == 1 ///
										& inrange(earning/21.7,50,100)

replace dab = dab1 + dab2 + dab3  	if country == "CZ" & year == 2016 & pt_eli == 1 ///
									& inrange(earning/21.7,50,100) & dab == .									
drop dab1 dab2 dab3 

* daily earning over €100
gen dab1 = 33 						if country == "CZ" & year == 2016 & pt_eli == 1 ///
									& earning/21.7 > 100
gen dab2 = (50 - 33)*0.6 			if country == "CZ" & year == 2016 & pt_eli == 1 ///
									& earning/21.7 > 100
										
gen dab3 = (100 - 50)*0.3 			if country == "CZ" & year == 2016 & pt_eli == 1 ///
									& earning/21.7 > 100

replace dab = dab1 + dab2 + dab3 	if country == "CZ" & year == 2016 & pt_eli == 1 ///
									& earning/21.7 > 100 & dab == . 		

									
* Benefits

replace pt_ben1 = ((dab * 0.7) * pt_dur) + (earning * ((21.7 - 7)/21.7))	///
							if country == "CZ" & year == 2016 & pt_eli == 1
							
							
replace pt_ben1 = (47 * pt_dur) + (earning * ((21.7 - 7)/21.7))	///
							if country == "CZ" & year == 2016 & pt_eli == 1 ///
							& dab*0.7 >= 47 & pt_eli == 1


replace pt_ben2 = pt_ben1 	if country == "CZ" & year == 2016 & pt_eli == 1


foreach x in 1 2 {
	replace pt_ben`x' = 0 	if pt_eli == 0 & country == "CZ" & year == 2016
}

replace pt_dur = 0 if pt_eli == 0 & country == "CZ" & year == 2016

drop dab dab1 dab2 dab3 
