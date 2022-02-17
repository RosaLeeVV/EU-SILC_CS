/* PL_2013_CZ_eusilc_cs */


* CZECHIA - 2013

* ELIGIBILITY
/*	-> cash benefits are available to all residents
	-> all employees are entitled to parental leave 8,458
*/
	
replace pl_eli = 1 		if country == "CZ" & year == 2013 
replace pl_eli = 0 		if pl_eli == . & country == "CZ" & year == 2013

* DURATION (weeks)
/*	-> parents choose the monthly benefit amount (determines also the duration of PL) 

	-> maximum amount of benefit for the whole period: €8,458
   
	-> 70% of the daily assessment base
	-> ceiling: €442/month 
    
	-> The benefit is calculated from the higher daily assessment base (if man's dab is higher, it is calculated
   from his daily assessment base; if woman's dab is higher, it is calculated from hers).
	-> If neither of the parents have social insurance:
		- €292/month until child is 10 months old, €146 until child is 48 months old => duration 4 years
		
	-> the most generous benefit is coded
   
	-> Social insurance is obligatory for employees, voluntary for self-employed (not coded)
	
	-> family entitlement => couples - all assigned to woman
*/


* Daily assessment base

/* daily assessment base (source: MISSOC 2013, IV. Maternity/Paternity):
	
	-> up to €33/day = 100% daily earning
	-> €33 - €50/day = 60% daily earning
	-> €50/day = 30% daily earning  
	-> earning over €100/day are not taken into account
	
	NOTE: 	DAB calculated in ML section
			Here only DAB for partner's variables (p_*)
*/

* daily earning < 33
gen p_dab = p_earning/21.7 				if country == "CZ" & year == 2013 ///
										& (p_earning/21.7) < 33 & parstat == 2 ///
										& econ_status != 1 & p_econ_status == 1

* daily earning between €33 and €50
gen p_dab1 = 33 							if country == "CZ" & year == 2013 ///
											& inrange(p_earning/21.7,33,50) & parstat == 2 ///
											& econ_status != 1 & p_econ_status == 1
											
gen p_dab2 = ((p_earning/21.7) - 33)*0.6 	if country == "CZ" & year == 2013 ///
											& inrange(p_earning/21.7,33,50) & parstat == 2 ///
											& econ_status != 1 & p_econ_status == 1
											 
replace p_dab = p_dab1 + p_dab2 			if country == "CZ" & year == 2013 ///
											& inrange(p_earning/21.7,33,50) & p_dab == .  ///
											& parstat == 2 & econ_status != 1 & p_econ_status == 1
drop p_dab1 p_dab2

										
* daily earning between €50 and €100										
gen p_dab1 = 33 						if country == "CZ" & year == 2013  ///
										& inrange(p_earning/21.7,50,100) ///
										& parstat == 2 & econ_status != 1 & p_econ_status == 1
										
gen p_dab2 = (50 - 33)*0.6 				if country == "CZ" & year == 2013 ///
										& inrange(p_earning/21.7,50,100) ///
										& parstat == 2 & econ_status != 1 & p_econ_status == 1
										
gen p_dab3 = ((p_earning/21.7) - 50)*0.3 	if country == "CZ" & year == 2013 ///
											& inrange(p_earning/21.7,50,100) & parstat == 2 ///
											& econ_status != 1 & p_econ_status == 1

										
replace p_dab = p_dab1 + p_dab2 + p_dab3  		if country == "CZ" & year == 2013 ///
												& inrange(p_earning/21.7,50,100)  ///
												& p_dab == . & parstat == 2 & econ_status != 1 ///
												& p_econ_status == 1
drop p_dab1 p_dab2 p_dab3 


* daily earning over €100
gen p_dab1 = 33 						if country == "CZ" & year == 2013  ///
										& p_earning/21.7 > 100 ///
										& parstat == 2 & econ_status != 1  & p_econ_status == 1
										
gen p_dab2 = (50 - 33)*0.6 				if country == "CZ" & year == 2013 ///
										& p_earning/21.7 > 100 & parstat == 2 ///
										& econ_status != 1 & p_econ_status == 1
										
gen p_dab3 = (100 - 50)*0.3			 	if country == "CZ" & year == 2013 ///
										& p_earning/21.7 > 100  & parstat == 2 ///
										& econ_status != 1 & p_econ_status == 1

										
replace p_dab = p_dab1 + p_dab2 + p_dab3  		if country == "CZ" & year == 2013 ///
												& p_earning/21.7 > 100   ///
												& p_dab == . & parstat == 2 & econ_status != 1 ///
												& p_econ_status == 1
drop p_dab1 p_dab2 p_dab3 



*** DURATION
/* -> maximum amount of benefit for the whole period: €8,458
   
	-> if at least one of the parents has social insurance:
		-> 70% of the daily assessment base (dab)
		-> ceiling: €442/month 
		-> If neither of the parents have social insurance: €292/month
	-> social insurance compulsory only for employees
*/	
									
* SINGLE (women & men)
	* not employed (4 years)
replace pl_dur = 4*52		if country == "CZ" & year == 2013 & pl_eli == 1 ///
										& econ_status != 1 & parstat == 1

	* employed
replace pl_dur = (8458 / ((0.7*dab)*21.7)) * 4.3 		if country == "CZ" & year == 2013 & pl_eli == 1 ///
														& econ_status == 1 & parstat == 1 & pl_dur == . ///
														& earning < 442
	* employed, above ceiling	
replace pl_dur = (8458 / 442) * 4.3 					if country == "CZ" & year == 2013 & pl_eli == 1 ///
														& econ_status == 1 & parstat == 1 & pl_dur == . ///
														& earning >= 442


* COUPLE (assigned to women)
	* neither is working (4 years)														
replace pl_dur = 4*52 		if country == "CZ" & year == 2013 & pl_eli == 1 ///
										& econ_status != 1 & !inlist(p_econ_status,.,1) & parstat == 2
										
	* woman not employed, man employed, below ceiling
replace pl_dur = (8458/((0.7 * p_dab)*21.7)) * 4.3 	if country == "CZ" & year == 2013 & pl_eli == 1 /// 
													& p_econ_status == 1 & !inlist(econ_status,.,1) ///
													& parstat == 2 & ((0.7*p_dab)*21.7) < 442
																										
	* woman not employed, man employed, above ceiling
replace pl_dur = (8458/442) * 4.3					if country == "CZ" & year == 2013 & pl_eli == 1 /// 
													& p_econ_status == 1 & econ_status != 1 ///
													& parstat == 2 & ((0.7*p_dab)*21.7) >= 442
															
	* woman employed, below ceiling
replace pl_dur = (8458/((0.7 * dab)*21.7)) * 4.3 	if country == "CZ" & year == 2013 & pl_eli == 1 /// 
													& econ_status == 1 & parstat == 2 ///
													& ((0.7*dab)*21.7) < 442

	* woman employed, above ceiling
replace pl_dur = (8458/442) * 4.3				 	if country == "CZ" & year == 2013 & pl_eli == 1 /// 
													& econ_status == 1 & parstat == 2 ///
													& ((0.7*dab)*21.7) >= 442
	
	
	
	
	


* BENEFIT (monthly)
/* For explanation see "Duration (weeks)" above. 
   pl_ben2/3 refer to the most generous benefit 		*/

* SINGLE
	* not employed
replace pl_ben1 = (292 * (10/58)) + (146 * (48/58)) 					if country == "CZ" & year == 2013 & pl_eli == 1 ///
										& econ_status != 1 & parstat == 1
										
	* employed, below ceiling
replace pl_ben1 = 0.7 * (21.7*dab)		if country == "CZ" & year == 2013 & pl_eli == 1 ///
										& econ_status == 1 & parstat == 1 
										
	* employed, above ceiling
replace pl_ben1 = 442					if country == "CZ" & year == 2013 & pl_eli == 1 ///
										& econ_status == 1 & parstat == 1 & pl_ben1 >= 442

	
		
* COUPLE (assigned to women)
	* neither employed
replace pl_ben1 = (292 * (10/58)) + (146 * (48/58)) 					if country == "CZ" & year == 2013 & pl_eli == 1 ///
										& econ_status != 1 & !inlist(p_econ_status,.,1) & parstat == 2
										
	* woman not employed, man employed
replace pl_ben1 =  0.7 * (21.7*p_dab)	if country == "CZ" & year == 2013 & pl_eli == 1 ///
										& econ_status != 1 & p_econ_status == 1 & parstat == 2
										
	
	* woman not employed, man employed, above ceiling
replace pl_ben1 =  442					if country == "CZ" & year == 2013 & pl_eli == 1 ///
										& econ_status != 1 & p_econ_status == 1 & parstat == 2 ///
										& pl_ben1 >= 442	
										
	* woman employed, below ceiling
replace pl_ben1 =  0.7 * (21.7*dab)	if country == "CZ" & year == 2013 & pl_eli == 1 ///
										& econ_status == 1 & parstat == 2 
										
	
	* above ceiling
replace pl_ben1 =  442					if country == "CZ" & year == 2013 & pl_eli == 1 ///
										& econ_status == 1 & parstat == 2 ///
										& pl_ben1 >= 442
	

replace pl_ben2 = pl_ben1 				if country == "CZ" & year == 2013 & pl_eli == 1 

foreach x in 1 2 {
	replace pl_ben`x' = 0 	if pl_eli == 0 & country == "CZ" & year == 2013
}

replace pl_dur = 0 	if pl_eli == 0 & country == "CZ" & year == 2013

drop dab dab1 dab2 dab3 
