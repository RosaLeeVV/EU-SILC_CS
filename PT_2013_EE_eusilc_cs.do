/* PT_2013_EE_eusilc_cs */

* ESTONIA - 2013

* ELIGIBILITY
/*	-> employed (coded) fathers with permanent contract (MISSOC 01/07/2013; not coded) */ 

replace pt_eli = 1 		if country == "EE" & year == 2013 & gender == 2 ///
						& econ_status == 1
replace pt_eli = 0 		if pt_eli == . & country == "EE" & year == 2013


* DURATION (weeks)
/*	-> 10 woring days */

replace pt_dur = 10/5 	if country == "EE" & year == 2013 & pt_eli == 1


* BENEFIT (monthly)
/*	-> 100% of earning
	-> ceiling: 3x the average gross monthly salary (MISSOC 2013)
	-> average gross monthly salary, 2013: €949 (Source: Statistics Estonia, 

	https://www.stat.ee/en/find-statistics/statistics-theme/work-life/wages-and-salaries-and-labour-costs/average-monthly-gross-wages-and-salaries
	accessed 24/03/2021		*/
	
replace pt_ben1 = earning 	if country == "EE" & year == 2013 & pt_eli == 1
							
							
replace pt_ben1 = ((3*949) * (pt_dur/4.3)) + (earning * ((4.3-pt_dur)/4.3)) ///
							if country == "EE" & year == 2013 & pt_eli == 1 ///
							& pt_ben1 >= 3*949

replace pt_ben2 = pt_ben1 	if country == "EE" & year == 2013 & pt_eli == 1


foreach x in 1 2 {
	replace pt_ben`x' = 0 	if pt_eli == 0 & country == "EE" & year == 2013
}

replace pt_dur = 0 if pt_eli == 0 & country == "EE" & year == 2013
