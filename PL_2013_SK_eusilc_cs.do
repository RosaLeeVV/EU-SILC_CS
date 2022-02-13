/* PL_2013_SK_eusilc_cs */


* SLOVAKIA - 2013

* ELIGIBILITY
/*	-> employed, self-employed: parental leave
	-> all residents: benefits 
	-> benefits: family entitlement => pl_dur & pl_ben assigned to woman in couples 	
*/
	
replace pl_eli = 1 			if country == "SK" & year == 2013 
replace pl_eli =  0			if pl_eli == . & country == "SK" & year == 2013


* DURATION (weeks)
/*	-> until child is 3 years old */

* women eligible for ML
replace pl_dur = (3*52) - ml_dur2 		if country == "SK" & year == 2013 & pl_eli == 1 ///
										& gender == 1 & ml_eli == 1

* women not eligible for ML
replace pl_dur = (3*52) 		 		if country == "SK" & year == 2013 & pl_eli == 1 ///
										& gender == 1 & ml_eli == 0


* single men eligible for ML
replace pl_dur = (3*52) - ml_dur2		if country == "SK" & year == 2013 & pl_eli == 1 ///
										& gender == 2 & parstat == 1 & ml_eli == 1

* single men not eligible for ML
replace pl_dur = (3*52)					if country == "SK" & year == 2013 & pl_eli == 1 ///
										& gender == 2 & parstat == 1 & pl_dur == . 


* BENEFIT (monthly)
/*	-> €199.60/month  (per family) */

replace pl_ben1 = 199.60		if country == "SK" & year == 2013 & pl_eli == 1 & pl_dur != . 

								
replace pl_ben2 = pl_ben1		if country == "SK" & year == 2013 & pl_eli == 1


foreach x in 1 2 {
	replace pl_ben`x' = 0 	if pl_eli == 0 & country == "SK" & year == 2013
}

replace pl_dur = 0 	if pl_eli == 0 & country == "SK" & year == 2013
