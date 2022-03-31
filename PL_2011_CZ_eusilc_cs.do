/* PL_2011_CZ_eusilc_cs */


* CZECHIA - 2011

* ELIGIBILITY
/*	-> cash benefits are available to all residents
	-> all employees are entitled to parental leave 
*/
	
replace pl_eli = 1 		if country == "CZ" & year == 2011 
replace pl_eli = 0 		if pl_eli == . & country == "CZ" & year == 2011

* DURATION (weeks)
/*	-> parents choose the monthly benefit amount (determines also the duration of PL) 

    
	-> The benefit is calculated from the higher daily assessment base (if man's dab is higher, it is calculated
   from his daily assessment base; if woman's dab is higher, it is calculated from hers).
	-> If neither of the parents have social insurance:
		- €313/month until child is 9 months old, €158 until child is 48 months old => duration 4 years
		
	-> the most generous benefit is coded
   
	-> Social insurance is obligatory for employees, voluntary for self-employed (not coded)
	
	-> family entitlement => couples - all assigned to woman
*/


* Daily assessment base

/* daily assessment base (source: MISSOC 2011, IV. Maternity/Paternity):
	
	-> up to €34/day = 100% daily earning
	-> €34 - €51/day = 60% daily earning
	-> €51/day = 30% daily earning  
	-> earning over €102/day are not taken into account
	
	NOTE: 	DAB calculated in ML section
			Here only DAB for partner's variables (p_*)
*/

* daily earning < 34
gen p_dab = p_earning/21.7 				if country == "CZ" & year == 2011 ///
										& (p_earning/21.7) < 34 & parstat == 2 ///
										& econ_status != 1 & p_econ_status == 1

* daily earning between €34 and €51
gen p_dab1 = 34 							if country == "CZ" & year == 2011 ///
											& inrange(p_earning/21.7,34,51) & parstat == 2 ///
											& econ_status != 1 & p_econ_status == 1
											
gen p_dab2 = ((p_earning/21.7) - 34)*0.6 	if country == "CZ" & year == 2011 ///
											& inrange(p_earning/21.7,34,51) & parstat == 2 ///
											& econ_status != 1 & p_econ_status == 1
											 
replace p_dab = p_dab1 + p_dab2 			if country == "CZ" & year == 2011 ///
											& inrange(p_earning/21.7,34,51) & p_dab == .  ///
											& parstat == 2 & econ_status != 1 & p_econ_status == 1
drop p_dab1 p_dab2

										
* daily earning between €51 and €102										
gen p_dab1 = 34 						if country == "CZ" & year == 2011  ///
										& inrange(p_earning/21.7,51,102) ///
										& parstat == 2 & econ_status != 1 & p_econ_status == 1
										
gen p_dab2 = (51 - 34)*0.6 				if country == "CZ" & year == 2011 ///
										& inrange(p_earning/21.7,51,102) ///
										& parstat == 2 & econ_status != 1 & p_econ_status == 1
										
gen p_dab3 = ((p_earning/21.7) - 51)*0.3 	if country == "CZ" & year == 2011 ///
											& inrange(p_earning/21.7,51,102) & parstat == 2 ///
											& econ_status != 1 & p_econ_status == 1

										
replace p_dab = p_dab1 + p_dab2 + p_dab3  		if country == "CZ" & year == 2011 ///
												& inrange(p_earning/21.7,51,102)  ///
												& p_dab == . & parstat == 2 & econ_status != 1 ///
												& p_econ_status == 1
drop p_dab1 p_dab2 p_dab3 


* daily earning over €102
gen p_dab1 = 34 						if country == "CZ" & year == 2011  ///
										& p_earning/21.7 > 102 ///
										& parstat == 2 & econ_status != 1  & p_econ_status == 1
										
gen p_dab2 = (51 - 34)*0.6 				if country == "CZ" & year == 2011 ///
										& p_earning/21.7 > 102 & parstat == 2 ///
										& econ_status != 1 & p_econ_status == 1
										
gen p_dab3 = (102 - 51)*0.3			 	if country == "CZ" & year == 2011 ///
										& p_earning/21.7 > 102  & parstat == 2 ///
										& econ_status != 1 & p_econ_status == 1

										
replace p_dab = p_dab1 + p_dab2 + p_dab3  		if country == "CZ" & year == 2011 ///
												& p_earning/21.7 > 102   ///
												& p_dab == . & parstat == 2 & econ_status != 1 ///
												& p_econ_status == 1
drop p_dab1 p_dab2 p_dab3 



*** DURATION
/* -> maximum amount of benefit for the whole period: €8,114
   
	-> if at least one of the parents has social insurance:
		-> 70% of the daily assessment base (dab)
		-> ceiling: €1,171/month 
		-> If neither of the parents have social insurance: €292/month
	-> social insurance compulsory only for employees
*/	
									
* SINGLE (women & men)
	* not employed (4 years)
replace pl_dur = 4*52		if country == "CZ" & year == 2011 & pl_eli == 1 ///
										& econ_status != 1 & parstat == 1

	* employed
replace pl_dur = (8114 / ((0.7*dab)*21.7)) * 4.3 		if country == "CZ" & year == 2011 & pl_eli == 1 ///
														& econ_status == 1 & parstat == 1 & pl_dur == . ///
														& earning < 424
	* employed, above ceiling	
replace pl_dur = (8114 / 424) * 4.3 					if country == "CZ" & year == 2011 & pl_eli == 1 ///
														& econ_status == 1 & parstat == 1 & pl_dur == . ///
														& earning >= 424


* COUPLE (assigned to women)
	* neither is working (4 years)														
replace pl_dur = 4*52 		if country == "CZ" & year == 2011 & pl_eli == 1 ///
										& econ_status != 1 & !inlist(p_econ_status,.,1) & parstat == 2
										
	* woman not employed, man employed, below ceiling
replace pl_dur = (8114/((0.7 * p_dab)*21.7)) * 4.3 	if country == "CZ" & year == 2011 & pl_eli == 1 /// 
													& p_econ_status == 1 & !inlist(econ_status,.,1) ///
													& parstat == 2 & ((0.7*p_dab)*21.7) < 424
																										
	* woman not employed, man employed, above ceiling
replace pl_dur = (8114/424) * 4.3					if country == "CZ" & year == 2011 & pl_eli == 1 /// 
													& p_econ_status == 1 & econ_status != 1 ///
													& parstat == 2 & ((0.7*p_dab)*21.7) >= 424
															
	* woman employed, below ceiling
replace pl_dur = (8114/((0.7 * dab)*21.7)) * 4.3 	if country == "CZ" & year == 2011 & pl_eli == 1 /// 
													& econ_status == 1 & parstat == 2 ///
													& ((0.7*dab)*21.7) < 424

	* woman employed, above ceiling
replace pl_dur = (8114/424) * 4.3				 	if country == "CZ" & year == 2011 & pl_eli == 1 /// 
													& econ_status == 1 & parstat == 2 ///
													& ((0.7*dab)*21.7) >= 424
	
	
	
	
	


* BENEFIT (monthly)
/* For explanation see "Duration (weeks)" above. 
   pl_ben2/3 refer to the most generous benefit 		*/

* SINGLE
	* not employed
replace pl_ben1 = (292 * (10/58)) + (158 * (48/58)) 					if country == "CZ" & year == 2011 & pl_eli == 1 ///
										& econ_status != 1 & parstat == 1
										
	* employed, below ceiling
replace pl_ben1 = 0.7 * (21.7*dab)		if country == "CZ" & year == 2011 & pl_eli == 1 ///
										& econ_status == 1 & parstat == 1 
										
	* employed, above ceiling
replace pl_ben1 = 424					if country == "CZ" & year == 2011 & pl_eli == 1 ///
										& econ_status == 1 & parstat == 1 & pl_ben1 >= 424

	
		
* COUPLE (assigned to women)
	* neither employed
replace pl_ben1 = (292 * (10/58)) + (158 * (48/58)) 					if country == "CZ" & year == 2011 & pl_eli == 1 ///
										& econ_status != 1 & !inlist(p_econ_status,.,1) & parstat == 2
										
	* woman not employed, man employed
replace pl_ben1 =  0.7 * (21.7*p_dab)	if country == "CZ" & year == 2011 & pl_eli == 1 ///
										& econ_status != 1 & p_econ_status == 1 & parstat == 2
										
	
	* woman not employed, man employed, above ceiling
replace pl_ben1 =  424					if country == "CZ" & year == 2011 & pl_eli == 1 ///
										& econ_status != 1 & p_econ_status == 1 & parstat == 2 ///
										& pl_ben1 >= 424	
										
	* woman employed, below ceiling
replace pl_ben1 =  0.7 * (21.7*dab)	if country == "CZ" & year == 2011 & pl_eli == 1 ///
										& econ_status == 1 & parstat == 2 
										
	
	* above ceiling
replace pl_ben1 =  424					if country == "CZ" & year == 2011 & pl_eli == 1 ///
										& econ_status == 1 & parstat == 2 ///
										& pl_ben1 >= 424
	

replace pl_ben2 = pl_ben1 				if country == "CZ" & year == 2011 & pl_eli == 1 

foreach x in 1 2 {
	replace pl_ben`x' = 0 	if pl_eli == 0 & country == "CZ" & year == 2011
}

replace pl_dur = 0 	if pl_eli == 0 & country == "CZ" & year == 2011

drop dab dab1 dab2 dab3 
