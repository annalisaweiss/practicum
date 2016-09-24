capture log close                           // closes any logs, should they be open
log using "assignment4_Weiss.log", replace // open new log

// NAME: Assignment 4
// FILE: assignment4_Weiss.do
// AUTH: Anna Weiss
// INIT: September 23, 2016
// LAST: September 23, 2016

// NOTE: This do file uses the 2011-2012 SASS dataset and the 2012-2013 Principal Follow-Up Year dataset. 

clear all                      // clear memory
set more off                   // turn off annoying "__more__" feature

// CONTENT...

// For this asignment, I'd like you to make use of the datafile and do files that you generated as part of assignment 3.

global workdir `c(pwd)' 
global datadir "../data/"

global sass_zip "SASS_1999-00_TFS_2000-01_v1_0_Stata_Datasets.zip"
global sass_prin_dta "SASS_99_00_S2a_v1_0.dta"
global sass_prin_dtasave "pub_school_prin.dta"

cd "/Users/annaweiss/Documents/B_Practicum/data"
unzipfile $sass_zip, replace
cd "$workdir"

use "$datadir$sass_prin_dta", clear
 
// Using these, complete the following steps:

//1.  Subset the data on gender. Create one data file for males and one for females (hint: use keep if or drop if).

preserve
keep if A0227 == 1                      
save male, replace
restore

preserve
keep if A0227 == 2                      
save female, replace
restore

//2.  Merge the two datasets together, and tabulate the _merge variable. What are the results?

merge 1:1 CNTLNUM using male, gen(_merge_male)  

merge 1:1 CNTLNUM using female, gen(_merge_female)

tab _merge_male
tab _merge_female

//3.  Now split the dataset by variables. To do this you will need to either use the drop command or use the save 
	//command with a variable list. Make sure that in each dataset, you include the student id.
//4.  Add a new line to each dataset. Alter the id in the new observation so that the two files do not match.
	
preserve
keep CNTLNUM SCHLEVEL MINENR PRFMET         						// variable set: school variables
save schlvar, replace
global schlvar "schlvar.dta"
restore

use "$datadir$schlvar", clear				
preserve
local 8525 = _N+1													// adding a line to school variables set. 
set obs 8525
save schlvar2, replace
global schlvar2 "schlvar2.dta"
restore

use "$datadir$schlvar2", clear								
preserve
edit
set obs 8525
replace SCHLEVEL = 1 in 8525										// altering the value. 
save schlvar3, replace
global schlvar3 "schlvar3.dta"
restore

use "$datadir$sass_prin_dta", clear
preserve
keep CNTLNUM A0218 A0053 A0226 A0225 AGE_P RACETH_P                 // variable set: principal variables
save prinvar, replace
global prinvar "prinvar.dta"
restore

preserve
use "$datadir$prinvar", clear				
local 8525 = _N+1													// adding a line to principal variables set. 
set obs 8525
save prinvar2, replace
global prinvar2 "prinvar2.dta"
restore

use "$datadir$prinvar2", clear
preserve								
edit
set obs 8525
replace A0053 = 3 in 8525											// altering the value. 
save prinvar3, replace
global prinvar3 "prinvar3.dta"
restore

use "$datadir$sass_prin_dta", clear
preserve
keep CNTLNUM A0079 A0087 A0095 A0104 A0111 A0118 A0125				// variable set: influence variables
save infvar, replace
global infvar "infvar.dta"
restore

preserve
use "$datadir$infvar", clear				
local 8525 = _N+1													// adding a line to principal variables set. 
set obs 8525
save infvar2, replace
global infvar2 "infvar2.dta"
restore

use "$datadir$infvar2", clear
preserve								
edit
set obs 8525
replace A0104 = 5 in 8525											// altering the value. 
save infvar3, replace
global infvar3 "infvar3.dta"
restore


//5.  Repeat the merge command again, but this time create a result where the two additional (fake) observations are dropped. 
	//Do this using the merge command itself, not drop if or keep if.

merge 1:1 CNTLNUM using prinvar3, gen(_merge_a) 
merge 1:1 CNTLNUM using schlvar3, gen(_merge_b)

//6.  Repeat the merge, but this time only keep the observations in the master dataset.
use "$datadir$infvar3", clear
merge 1:1 CNTLNUM using prinvar3, gen (_merge_c)

//7.  Repeat the merge, but this time only keep the observations in the using dataset.

use "$datadir$prinvar3", clear
merge 1:1 CNTLNUM using infvar3, gen (_merge_d)						//I have 3 sets; will demonstrate with just 2.

// Submit your results in a do file per normal procedure. 
// Remember that since I don't have access to your small dataset, I need a do file that will cleanly create the dataset 
	// from the original data and then complete the operations above.


// end file
log close                               // close log
exit                                    // exit script
