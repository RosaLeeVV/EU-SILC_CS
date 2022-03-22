/* PL_2011_AT_eusilc_cs */

* AUSTRIA - 2011

* ELIGIBILITY
/*	-> parental leave: employed, individual entitlement
	-> parental benefit: all parents, family entitlement
*/
replace pl_eli = 1 	if country == "AT" & year == 2011 
replace pl_eli = 0 	if pl_eli == . & country == "AT" & year == 2011



* DURATION (weeks)
/*	-> parents choose the duration of benefits (affects benefit amount)
		- the duration of PL is between 12 months and 30 months
		- the shortest period has the most generous per day benefits
		=> most generous option is coded (12 months)
	-> benefit family entitlement => father can claim if mother is not eligible 
	-> Benefits are family entitlement => all entitlements assigned to the woman for 
		cohabiting couples. For single individuals they are asigned to the individual. 
	-> The duration of leave (365 days) is for after the birth of the child => 
		the period of postnatal maternity leave is deduced for women who would be 
		eligible for maternity leave. 	
		
	-> NOTE: if missing values on partner's economic status or earning => women's information is used
*/

* employed   
	* eligible for ML
	* and cohabiting
replace pl_dur = 52 - ml_dur2 	if country == "AT" & year == 2011 & pl_eli == 1 ///
									& gender == 1 & (econ_status == 1 | p_econ_status == 1) ///
									& parstat == 2 & ml_eli == 1
	* and single
replace pl_dur = 52 - ml_dur2 	if country == "AT" & year == 2011 & pl_eli == 1 ///
									& gender == 1 & econ_status == 1 & parstat == 1 & ml_eli == 1 & pl_dur == .



	* not eligible for ML
	* and cohabiting
replace pl_dur = 52 	if country == "AT" & year == 2011 & pl_eli == 1 ///
							& gender == 1 & (econ_status == 1 | p_econ_status == 1) ///
							& parstat == 2 & ml_eli != 1 & pl_dur == .
	* and single
replace pl_dur = 52 	if country == "AT" & year == 2011 & pl_eli == 1 ///
							& econ_status == 1 & parstat == 1 & ml_eli != 1 & pl_dur == . 

		

		
* all other women
 replace pl_dur = 52 	if country == "AT" & year == 2011 & pl_eli == 1 ///
							& gender == 1 & econ_status != 1 & pl_dur == . 





* BENEFIT (monthly)
/*	-> benefit is a family entitlement but among working parents it calculated 
		from one parents income => we assume parents will use earnings of the parent 
		with higher earnings
	-> employed: 80% of earnings (parent who claims the benefits)
			- no ceiling
			- paid for 365 days after childbirth
*/


 ** employed & single
replace pl_ben1 = 0.8 * earning 	if country == "AT" & year == 2011 & pl_eli == 1 /// 
									& econ_status == 1 & parstat == 1 
									
								
 
 
 ** cohabiting -> asssigned to a woman
	* employed, woman higher earning
replace pl_ben1 = 0.8 * earning		if country == "AT" & year == 2011 & pl_eli == 1 ///
									& econ_status == 1 & earning > p_earning & pl_ben1 == . ///
									& gender == 1 & parstat == 2 & p_earning != .
									
	* employed, man higher earning
replace pl_ben1 = 0.8 * p_earning	if country == "AT" & year == 2011 & pl_eli == 1 ///
									& p_econ_status == 1 & earning < p_earning & pl_ben1 == . ///
									& gender == 1 & parstat == 2 & p_earning != .
								

									
	* employed, partner's earning is missing	
replace pl_ben1 = 0.8 * earning 	if country == "AT" & year == 2011 & pl_eli == 1 /// 
									& econ_status == 1 & parstat == 2 & p_earning == .
								
									


									


 
 
 
replace pl_ben2 = pl_ben1		if country == "AT" & year == 2011 & pl_eli == 1


foreach x in 1 2 {
	replace pl_ben`x' = 0 	if pl_eli == 0 & country == "AT" & year == 2011
}

replace pl_dur = 0 	if pl_eli == 0 & country == "AT" & year == 2011


