capture log close                           // closes any logs, should they be open
log using "assignment3_Weiss.log", replace // open new log

// NAME: Assignment 3
// FILE: assignment3_Weiss.do>
// AUTH: Anna Weiss
// INIT: 2016.09.14
// LAST: 2016.09.18

clear all                      // clear memory
set more off                   // turn off annoying "__more__" feature

//With the dataset, complete the following steps:
//1. Using your research question from the first assignment, describe briefly 10 variables that you think might be 
	//relevant to this study. 
   
	//First, I should clarify that I have decided to change my research question and will resubmit a different proposal in the next week.  
	//Now, it is this: 
		//Which areas of perceived influence (i.e., budget decisions, school discipline, etc.) 
		//correlate most strongly with a principal’s intent to stay?
	//I believe the answer to this research question has major policy implications for large districts attempting to differentiate and target
	//their principal supports.  Are there particular areas which suggest that principals would rather be granted more responsibility?
	//Are there areas which principals feel comfortable leaving up to a central office to own entirely?  These are some of the questions I
	//hope to explore in this study.  
	
	//I will be using the Schools and Staffing Survey (SASS).  I will also only be focusing on principals in public schools, mainly because the factors which
	//influence a private school principal's perceived influence can vary significantly from school to school and are less likely to be directly impacted by 
	//policy decisions.  I will also only be focusing on full-time principals, as I am operating under the assumption that part-time principals will naturally
	//have less influence over decisions.  
	
	//12 variables which I think might be relevant to this study:
		//1. Principals who left their school by the time of the follow-up study (this includes transfers within the district, as most 
			//of the research indicates that any principal turnover has negative effects for student achievement at the school; 
			//therefore, this is the most important variable to measure.)  
		//2. The areas in which principals feel they exercise more or less influence (i.e., school discipline, student achievement, budget decisions, etc.) 
		//3. Whether or not someone is a new hire (research tells us that newly hired principals are most likely to leave their schools within five years)
		//4. Whether a principal leads an elementary, middle, or high school (middle and high school principals are more likely to leave than elementary) 
		//5. The difference between principal and teacher salary (some have suggested that principals step down from the role in exchange for fewer hours worked)
		//6. Percent of students receiving free and reduced lunch at the school (a commonly used measure for the poverty level at the school; principals of 
			//high-poverty schools are more likely to leave than principals of low-poverty schools)
		//7. Percent of minority students at the school (principals at high-minority schools are more likely to leave than schools which are predominantly white)
		//8. Percent of low-achieving students (this is another factor which pushes principals to leave)
		//9. Level of education, i.e., master's or bachelor's degree (research shows that principals who have obtained a master's degree are less likely to leave)
		//10. Prior experience in the district (if a principal has spent time in the district previously in another role, they are more likely to stay)
		//11. Age (the older the principal, the more likely they are to stay)
		//12. Race (black and Hispanic principals are more likely to leave than white principals)

   
//2. Using the dataset that you’d like to work with, find indicators to match the variables you’re looking for. 

		//1. Principals who left their school by the time of the follow-up study:
			//A0218 - Req to replace principal
		//2. The areas in which principals feel they exercise more or less influence (i.e., school discipline, student achievement, budget decisions, etc.) 
			//A0076-A0129 
		//3. Whether or not someone is a new hire 
			//A0053 - Yrs princpl this sch 
		//4. Whether a principal leads an elementary, middle, or high school 
			//SCHLEVEL - School Level
		//5. The difference between principal and teacher salary 
			//A0226 - Principal Salary
			//D0508 - Highest Teacher Salary in district.  
		//6. Percent of students receiving free and reduced lunch at the school 
			//NSLELG - Perc stu eligible for lunch prog-dist
		//7. Percent of minority students at the school 
			//MINENR - Perc minority students
		//8. Percent of low-achieving students 
			//PRFMET - Whether sch perf goals were met
		//9. Level of education, i.e., master's or bachelor's degree 
			//A0225 - Highest degree earned
		//10. Prior experience in the district 
			//This was not measured in the survey.  
		//11. Age 
			//AGE_P - Age of principal
		//12. Race 
			//RACETH_P - Principal race/ethnicity
		//Will be excluding NSLELG and D0508, as they are in diff. datasets.  Not sure how to merge.

//3. Generate code to subset your chosen variables from the full dataset. 
			
global workdir `c(pwd)' 
global datadir "../data/"

global sass_zip "SASS_1999-00_TFS_2000-01_v1_0_Stata_Datasets.zip"
global sass_prin_dta "SASS_99_00_S2a_v1_0.dta"
global sass_prin_dtasave "pub_school_prin.dta"

cd "/Users/annaweiss/Documents/B_Practicum/data"
unzipfile $sass_zip, replace
cd "$workdir"

#delimit ;

use  
 A0053
 A0079
 A0087
 A0095
 A0104
 A0111
 A0118
 A0125
 A0218
 A0225
 A0226
 SCHLEVEL
 PRFMET
 AGE_P
 RACETH_P
 MINENR
using "$datadir$sass_prin_dta";

#delimit cr

renvars *, lower

//save $datadir$sass_dist_dta, replace
save "$datadir$sass_prin_dta", replace

//4. Describe the data you’ve selected. 
use "$datadir$sass_prin_dta"
describe a0053
describe a0079
describe a0087
describe a0095
describe a0104
describe a0111
describe a0118
describe a0125
describe a0218
describe a0225
describe a0226
describe schlevel
describe prfmet
describe age_p
describe raceth_p
describe minenr


//5. Include the following information in your description of each continuous indicator: 
	//Mean 
	//Standard error of the mean 
	//Median 
	//Number missing 
	
sum a0053 a0079 a0087 a0095 a0104 a0111 a0118 a0125 age_p minenr a0226,detail 
	
//For categorical indicators, I need a tabulation across the levels of the indicator, including a category for 
	//missing data.
	
tab a0218 
tab raceth_p
tab prfmet
tab schlevel
tab a0225

//NB: Skip weights, etc, and focus on your variables of interest.

//For this assignment, you should submit a do file that subsets the variables you want from the full dataset 
//(saving optional) generates the proper descriptive statistics


// end file
log close                               // close log
exit                                    // exit script
