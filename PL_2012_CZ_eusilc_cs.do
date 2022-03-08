/* PL_2012_CZ_eusilc_cs */


* CZECHIA - 2012

* ELIGIBILITY
/*	-> cash benefits are available to all residents
	-> all employees are entitled to parental leave 
*/
	
replace pl_eli = 1 		if country == "CZ" & year == 2012 
replace pl_eli = 0 		if pl_eli == . & country == "CZ" & year == 2012

* DURATION (weeks)
/*	-> parents choose the monthly benefit amount (determines also the duration of PL) 

	-> maximum amount of benefit for the whole period: €8,541
   
	-> 70% of the daily assessment base
	-> ceiling: €446/month 
    
	-> The benefit is calculated from the higher daily assessment base (if man's dab is higher, it is calculated
   from his daily assessment base; if woman's dab is higher, it is calculated from hers).
	-> If neither of the parents have social insurance:
		- €295/month until child is 10 months old, €148 until child is 48 months old => duration 4 years
		
	-> the most generous benefit is coded
   
	-> Social insurance is obligatory for employees, voluntary for self-employed (not coded)
	
	-> family entitlement => couples - all assigned to woman
*/


* Daily assessment base

/* daily assessment base (source: MISSOC 2012, IV. Maternity/Paternity):
	
	-> up to €33/day = 100% daily earning
	-> €33 - €49/day = 60% daily earning
	-> €49 - €98/day  = 30% daily earning  
	-> earning over €98/day are not taken into account
	
	NOTE: 	DAB calculated in ML section
			Here only DAB for partner's variables (p_*)
*/

* daily earning < 33
gen p_dab = p_earning/21.7 				if country == "CZ" & year == 2012 ///
										& (p_earning/21.7) < 33 & parstat == 2 ///
										& econ_status != 1 & p_econ_status == 1

* daily earning between €33 and €49
gen p_dab1 = 33 							if country == "CZ" & year == 2012 ///
											& inrange(p_earning/21.7,33,49) & parstat == 2 ///
											& econ_status != 1 & p_econ_status == 1
											
gen p_dab2 = ((p_earning/21.7) - 33)*0.6 	if country == "CZ" & year == 2012 ///
											& inrange(p_earning/21.7,33,49) & parstat == 2 ///
											& econ_status != 1 & p_econ_status == 1
											 
replace p_dab = p_dab1 + p_dab2 			if country == "CZ" & year == 2012 ///
											& inrange(p_earning/21.7,33,49) & p_dab == .  ///
											& parstat == 2 & econ_status != 1 & p_econ_status == 1
drop p_dab1 p_dab2

										
* daily earning between €49 and €98										
gen p_dab1 = 33 						if country == "CZ" & year == 2012  ///
										& inrange(p_earning/21.7,49,98) ///
										& parstat == 2 & econ_status != 1 & p_econ_status == 1
										
gen p_dab2 = (49 - 33)*0.6 				if country == "CZ" & year == 2012 ///
										& inrange(p_earning/21.7,49,98) ///
										& parstat == 2 & econ_status != 1 & p_econ_status == 1
										
gen p_dab3 = ((p_earning/21.7) - 49)*0.3 	if country == "CZ" & year == 2012 ///
											& inrange(p_earning/21.7,49,98) & parstat == 2 ///
											& econ_status != 1 & p_econ_status == 1

										
replace p_dab = p_dab1 + p_dab2 + p_dab3  		if country == "CZ" & year == 2012 ///
												& inrange(p_earning/21.7,49,98)  ///
												& p_dab == . & parstat == 2 & econ_status != 1 ///
												& p_econ_status == 1
drop p_dab1 p_dab2 p_dab3 


* daily earning over €98
gen p_dab1 = 33 						if country == "CZ" & year == 2012  ///
										& p_earning/21.7 > 98 ///
										& parstat == 2 & econ_status != 1  & p_econ_status == 1
										
gen p_dab2 = (49 - 33)*0.6 				if country == "CZ" & year == 2012 ///
										& p_earning/21.7 > 98 & parstat == 2 ///
										& econ_status != 1 & p_econ_status == 1
										
gen p_dab3 = (98 - 49)*0.3			 	if country == "CZ" & year == 2012 ///
										& p_earning/21.7 > 98  & parstat == 2 ///
										& econ_status != 1 & p_econ_status == 1

										
replace p_dab = p_dab1 + p_dab2 + p_dab3  		if country == "CZ" & year == 2012 ///
												& p_earning/21.7 > 98   ///
												& p_dab == . & parstat == 2 & econ_status != 1 ///
												& p_econ_status == 1
drop p_dab1 p_dab2 p_dab3 



*** DURATION
/* -> maximum amount of benefit for the whole period: €8,541
   
	-> if at least one of the parents has social insurance:
		-> 70% of the daily assessment base (dab)
		-> ceiling: €1,259/month 
		-> If neither of the parents have social insurance: €295/month
	-> social insurance compulsory only for employees
*/	
									
* SINGLE (women & men)
	* not employed (4 years)
replace pl_dur = 4*52		if country == "CZ" & year == 2012 & pl_eli == 1 ///
										& econ_status != 1 & parstat == 1

	* employed
replace pl_dur = (8541 / ((0.7*dab)*21.7)) * 4.3 		if country == "CZ" & year == 2012 & pl_eli == 1 ///
														& econ_status == 1 & parstat == 1 & pl_dur == . ///
														& earning < 446
	* employed, above ceiling	
replace pl_dur = (8541 / 446) * 4.3 					if country == "CZ" & year == 2012 & pl_eli == 1 ///
														& econ_status == 1 & parstat == 1 & pl_dur == . ///
														& earning >= 446


* COUPLE (assigned to women)
	* neither is working (4 years)														
replace pl_dur = 4*52 		if country == "CZ" & year == 2012 & pl_eli == 1 ///
										& econ_status != 1 & !inlist(p_econ_status,.,1) & parstat == 2
										
	* woman not employed, man employed, below ceiling
replace pl_dur = (8541/((0.7 * p_dab)*21.7)) * 4.3 	if country == "CZ" & year == 2012 & pl_eli == 1 /// 
													& p_econ_status == 1 & !inlist(econ_status,.,1) ///
													& parstat == 2 & ((0.7*p_dab)*21.7) < 446
																										
	* woman not employed, man employed, above ceiling
replace pl_dur = (8541/446) * 4.3					if country == "CZ" & year == 2012 & pl_eli == 1 /// 
													& p_econ_status == 1 & econ_status != 1 ///
													& parstat == 2 & ((0.7*p_dab)*21.7) >= 446
															
	* woman employed, below ceiling
replace pl_dur = (8541/((0.7 * dab)*21.7)) * 4.3 	if country == "CZ" & year == 2012 & pl_eli == 1 /// 
													& econ_status == 1 & parstat == 2 ///
													& ((0.7*dab)*21.7) < 446

	* woman employed, above ceiling
replace pl_dur = (8541/446) * 4.3				 	if country == "CZ" & year == 2012 & pl_eli == 1 /// 
													& econ_status == 1 & parstat == 2 ///
													& ((0.7*dab)*21.7) >= 446
	
	
	
	
	


* BENEFIT (monthly)
/* For explanation see "Duration (weeks)" above. 
   pl_ben2/3 refer to the most generous benefit 		*/

* SINGLE
	* not employed
replace pl_ben1 = (295 * (10/58)) + (140 * (48/58)) 					if country == "CZ" & year == 2012 & pl_eli == 1 ///
										& econ_status != 1 & parstat == 1
										
	* employed, below ceiling
replace pl_ben1 = 0.7 * (21.7*dab)		if country == "CZ" & year == 2012 & pl_eli == 1 ///
										& econ_status == 1 & parstat == 1 
										
	* employed, above ceiling
replace pl_ben1 = 446					if country == "CZ" & year == 2012 & pl_eli == 1 ///
										& econ_status == 1 & parstat == 1 & pl_ben1 >= 446

	
		
* COUPLE (assigned to women)
	* neither employed
replace pl_ben1 = (295 * (10/58)) + (140 * (48/58)) 					if country == "CZ" & year == 2012 & pl_eli == 1 ///
										& econ_status != 1 & !inlist(p_econ_status,.,1) & parstat == 2
										
	* woman not employed, man employed
replace pl_ben1 =  0.7 * (21.7*p_dab)	if country == "CZ" & year == 2012 & pl_eli == 1 ///
										& econ_status != 1 & p_econ_status == 1 & parstat == 2
										
	
	* woman not employed, man employed, above ceiling
replace pl_ben1 =  446					if country == "CZ" & year == 2012 & pl_eli == 1 ///
										& econ_status != 1 & p_econ_status == 1 & parstat == 2 ///
										& pl_ben1 >= 446	
										
	* woman employed, below ceiling
replace pl_ben1 =  0.7 * (21.7*dab)	if country == "CZ" & year == 2012 & pl_eli == 1 ///
										& econ_status == 1 & parstat == 2 
										
	
	* above ceiling
replace pl_ben1 =  446					if country == "CZ" & year == 2012 & pl_eli == 1 ///
										& econ_status == 1 & parstat == 2 ///
										& pl_ben1 >= 446
	

replace pl_ben2 = pl_ben1 				if country == "CZ" & year == 2012 & pl_eli == 1 

foreach x in 1 2 {
	replace pl_ben`x' = 0 	if pl_eli == 0 & country == "CZ" & year == 2012
}

replace pl_dur = 0 	if pl_eli == 0 & country == "CZ" & year == 2012

drop dab dab1 dab2 dab3 
