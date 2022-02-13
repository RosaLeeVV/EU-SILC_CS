/* ML_2013_SK_eusilc_cs */

* SLOVAKIA - 2013

* ELIGIBILITY
/*	-> employed
	-> self-employed
	-> 270 calendar days (coded) of work during the past 2 years	(not coded) 	
	-> single fathers can also claim "ML" 	*/
	
replace ml_eli = 1 			if country == "SK" & year == 2013 & gender == 1 /// 
							& inlist(econ_status,1,2) & (duremp+dursemp) >= (270/7)/4.3


* single men
replace ml_eli = 1 			if country == "SK" & year == 2013 & gender == 2 /// 
							& inlist(econ_status,1,2) & (duremp+dursemp) >= (270/7)/4.3 & parstat == 1

							
replace ml_eli = 0 			if ml_eli == . & country == "SK" & year == 2013 & gender == 1


* DURATION (weeks)
/*	-> total: 34 weeks obligatory 
	-> prenatal: 6 weeks 	
	-> single mother: 37 weeks
	-> single father: 31 weeks 
	
	-> source: z.c. 461/2003 z.z., zakon o socialnom poisteni 
	(https://www.zakonypreludi.sk/zz/2003-461/znenie-20210101#cast1-hlava2-diel5)
	accessed: 30/03/2021	
*/
	
replace ml_dur1 = 6 		if country == "SK" & year == 2013 & ml_eli == 1 & gender == 1

* cohabiting women
replace ml_dur2 = 34-6 		if country == "SK" & year == 2013 & ml_eli == 1 ///
							& gender == 1 & parstat == 2
* single women
replace ml_dur2 = 37-6		if country == "SK" & year == 2013 & ml_eli == 1 ///
							& gender == 1 & parstat == 1

* single men
replace ml_dur2 = 31		if country == "SK" & year == 2013 & ml_eli == 1 ///
							& gender == 2 & parstat == 1


* BENEFIT (monthly)
/*	-> 65% average earnings
	-> ceiling: monthly ceiling 1.5-times of national average monthly wage (€889).
	
	source: Statistical Office of the Slovak Republic, Average monthly wage of employee 
		in economy of the SR in the 3rd quarter of 2013, shorturl.at/stvAT , accessed 30.12.2021 */
	
replace ml_ben1 = 0.65*earning 		if country == "SK" & year == 2013 & ml_eli == 1
replace ml_ben1 = 1.5*889		if country == "SK" & year == 2013 & ml_eli == 1 ///
									& ml_ben1 >= (1.5*889)

replace ml_ben2 = ml_ben1 		if country == "SK" & year == 2013 & ml_eli == 1


foreach x in 1 2 {
    replace ml_dur`x' = 0 	if ml_eli == 0 & country == "SK" & year == 2013
	replace ml_ben`x' = 0 	if ml_eli == 0 & country == "SK" & year == 2013
}
