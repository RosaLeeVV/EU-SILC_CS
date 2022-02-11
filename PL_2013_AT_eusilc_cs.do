/* PL_2013_AT_eusilc_cs */

* AUSTRIA - 2013

* ELIGIBILITY
/*	-> parental leave: employed, individual entitlement
	-> parental benefit: all parents, family entitlement
*/
replace pl_eli = 1 	if country == "AT" & year == 2013 
replace pl_eli = 0 	if pl_eli == . & country == "AT" & year == 2013



* DURATION (weeks)
/*	-> parents can choose from 5 options:
		-> €14.53 daily until the child reaches 30 months of age; if other parent applies as well -> 36 months (not coded)
		-> €20.80 daily until the child reaches 20 months of age; if other parent applies as well -> 24 months (not coded)
		-> €26.60 daily until the child reaches 15 months of age; if other parent applies as well -> 18 months (not coded)
		-> €33 daily until the child reaches 12 months of age (coded); if other parent applies as well -> 14 months (not coded)
		-> 80% of earnings until the child reaches 12 months of age (coded); if other parent applies as well -> 14 months (not coded)
			- only available to employed parents
		
	-> benefit family entitlement => father can claim if mother is not eligible 
	-> Benefits are family entitlement => all entitlements assigned to the woman for 
		cohabiting couples. For single individuals they are asigned to the individual. 
	-> The duration of leave (365 days) is for after the birth of the child => 
		the period of postnatal maternity leave is deduced for women who would be 
		eligible for maternity leave. 	
		
	-> NOTE: if missing values on partner's economic status or earning => women's information is used
*/

 
* eligible for ML
replace pl_dur = 52 - ml_dur2 	if country == "AT" & year == 2014 & pl_eli == 1 ///
									& gender == 1 & ml_eli == 1

* not eligible for ML
replace pl_dur = 52 	if country == "AT" & year == 2014 & pl_eli == 1 ///
							& gender == 1 & ml_eli != 1 & pl_dur == .



* BENEFIT (monthly)
/*	-> benefit is a family entitlement but among working parents it calculated 
		from one parents income => we assume parents will use earnings of the parent 
		with higher earnings
	-> parents can choose from 5 options:
		-> €14.53 daily until the child reaches 30 months of age; if other parent applies as well -> 36 months (not coded)
		-> €20.80 daily until the child reaches 20 months of age; if other parent applies as well -> 24 months (not coded)
		-> €26.60 daily until the child reaches 15 months of age; if other parent applies as well -> 18 months (not coded)
		-> €33 daily until the child reaches 12 months of age (coded); if other parent applies as well -> 14 months (not coded)
		-> 80% of earnings until the child reaches 12 months of age (coded); if other parent applies as well -> 14 months (not coded)
			- only available to employed parents
			
	-> income-related benefit is coded for all employed eligible women
	-> most financially generous option is coded for the remaining women (€33/day)
*/


 ** employed 
replace pl_ben1 = 0.8 * earning 	if country == "AT" & year == 2013 & pl_eli == 1 /// 
									& econ_status == 1 & parstat == 1 
									
									

** self-employed, unemployed, inactive
replace pl_ben1 = 33 * 21.7 		if country == "AT" & year == 2013 & pl_eli == 1 ///
									& inrange(econ_status,2,4) 


									


replace pl_ben2 = pl_ben1		if country == "AT" & year == 2013 & pl_eli == 1


foreach x in 1 2 {
	replace pl_ben`x' = 0 	if pl_eli == 0 & country == "AT" & year == 2013
}

replace pl_dur = 0 	if pl_eli == 0 & country == "AT" & year == 2013


