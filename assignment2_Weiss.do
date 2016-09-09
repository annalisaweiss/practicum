capture log close                           // closes any logs, should they be open
log using "assignment2_Weiss.log", replace // open new log

// NAME: Assignment #2
// FILE: assignment2_Weiss.do
// AUTH: Anna Weiss
// INIT: 8 September 2016
// LAST: 8 September 2016

clear all                      // clear memory
set more off                   // turn off annoying "__more__" feature

// CONTENT...

insheet using "caschools.dta" 

label variable dist_cod "District Code"
label variable county "County Name"
label variable district "District Name"
label variable gr_span "Grade Span"
label variable enrl_tot "Total # of Students Enrolled"
label variable teachers "# of Teachers"
label variable calw_pct "% of Students Receiving Welfare" 
label variable meal_pct "% of Students Receiving Free and Reduced Lunch"
label variable computer "# of Computers"
label variable testscr "Average Test Score"
label variable comp_stu "Computers per Student"
label variable expn_stu "Expenditures per Student" 
label variable avginc "Average Income of Students' Families"
label variable el_pct "% of English Language Learners"
label variable read_scr "Average Reading Score"
label variable math_scr "Average Math Score"

//Create a categorical variable for district size, dividing districts by quartiles. 

egen enrl_tot_q = cut(enrl_tot), group(4)

recode enrl_tot_q (0 = 1 "First Quartile") ///
    (1 = 2 "2nd Quartile") ///
    (2 = 3 "3rd Quartile") ///
    (3 = 4 "4th Quartile"), gen(new_enrl_tot_q)	

tab new_enrl_tot_q	

//Create a variable name for this variable as well as value labels for each school size as follows:
//Small
//Medium-Small
//Medium-Large
//Large

label variable new_enrl_tot_q "District Size"

label define dist_size 1 "Small" 2 "Medium-Small" 3 "Medium-Large" 4 "Large"

label values new_enrl_tot_q dist_size

//Calculate the total number of students enrolled in each type of school district (small through large).

total enrl_tot if new_enrl_tot_q==1
total enrl_tot if new_enrl_tot_q==2
total enrl_tot if new_enrl_tot_q==3
total enrl_tot if new_enrl_tot_q==4


//Calculate the average reading score, math score, and welfare percent in each type of school district 
//(small through large).

summarize read_scr math_scr calw_pct if new_enrl_tot_q==1
summarize read_scr math_scr calw_pct if new_enrl_tot_q==2
summarize read_scr math_scr calw_pct if new_enrl_tot_q==3
summarize read_scr math_scr calw_pct if new_enrl_tot_q==4

//Create graphics for districts by size showing the distribution of reading scores and math scores.

histogram read_scr, by(new_enrl_tot_q)
histogram math_scr, by(new_enrl_tot_q)


//Create another graphic showing the relationship between expenditures per student and math scores by district 
//size.

graph  twoway scatter expn_st math_scr, by(new_enrl_tot_q) /*Scatterplot of young population as a function of older population */


// end file
log close                               // close log
exit                                    // exit script
