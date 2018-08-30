/******************************************************************************************************************
SOI TABLES PARENT FILE

INSTRUCTIONS

a. Update this do file for a country/ round:
        -Update directories
        -Call in dataset (Run CCRX_HHQFQDoFile3_Analysis Prep on publically-released dataset) 
        -Set macros
        -Recode country-specific issues
b. Run .do file OtherTables
        -Produces `CCRX'_SOITable_ResponseRates.dta ****************************
        -Produces `CCRX'_SOITable_SampleError.dta ******************************
c. Run .do file vargen: 
        -Generates variables needed for analysis
        -Produces `CCRX'_SOIPrep_HHQFQ_vargen.dta ******************************
d. Run .do file countryspecific: 
        -Set country-specific Categories for School and Region Groupings -- Regions must be numbers in data (twice) 
        -Produces `CCRX'_SOIPrep_HHQFQ_countryspecific.dta *********************
e. Run .do file formatting: 
        -Formats data into wide version and order variables
        -Produces `CCRX'_SOITable_HHQFQ_SOI.dta ****************************

******************************************************************************************************************/
* Section A. Call in data set & set macros
*      Notes for macros:
*        • DRC country global shoud be either DRC_Kinshasa OR DRC_KongoCentral
*        • Niger
*            - Even numbered rounds: 1) Country global is Niger_National; 2) Country global is Niger_Niamey (need to change country specfic coding)
*            - Even numbered rounds: 1) Need to select correct wealthtertile_* renaming (either rename wealthtertile_National wealth; or rename wealthtertile_Niamey wealth)
*            - Odd numbered rounds: Country global is Niger_Niamey
*        • Nigeria
*            – Round 1 & Round 2: Country global should be either Nigeria_Lagos or Nigeria_Kaduna
*            - Round 3: 1) One SOI per state, and one for National.  Country global should be Nigeria_`state'; 2) Country global is Nigeria_National
******************************************************************************************************************

clear
clear all
set more off

*Directory
global dofiles         "/Users/ealarson/Dropbox (Gates Institute)/9 Data Management - Non-Francophone/Nigeria/PMADataManagement_Nigeria/Round3/SOI_Tables/DoFiles"
global datadir         "/Users/ealarson/Dropbox (Gates Institute)/9 Data Management - Non-Francophone/Nigeria/PMADataManagement_Nigeria/Round3/SOI_Tables"
global csv_results     "$datadir/csv_results"
cd "$datadir"

*Dataset
local analysisdatadir "/Users/ealarson/Dropbox (Gates Institute)/9 Data Management - Non-Francophone/Nigeria/PMANG_Datasets/Round3/Analysis"
local analysisdata   "NGR3_HHQFQ_AnalysisData_28Aug2018"

*Macros for .do files subsequent .do files
local othertables      "CCRX_HHQFQDoFile4b_SOITables_OtherTables_v3_BL.do"
local vargen           "CCRX_HHQFQDoFile4c_SOITables_VarGen_v3_BL.do"
local countryspecific  "CCRX_HHQFQDoFile4d_SOITables_CountrySpecific_v3_BL.do"
global format            "CCRX_HHQFQDoFile4c1_SOITables_Format_v1_SAS.do"

*Date Macro
local today=c(current_date)
local c_today= "`today'"
global today=subinstr("`c_today'", " ", "",.)

*Round Specific Macros
global country "Nigeria_National"
global round "Round 3"
global date "2017-05"
global CCRX "NER4_National"

local CCRX $CCRX

/*Nigeria Only
local state "Kaduna"
global CCRX `CCRX'_`state'
local CCRX $CCRX
*/

use "`analysisdatadir'/`analysisdata'", clear

*Country Specific Recoding //NOT COMPLETE (especially Niger and Nigeria)
if country=="BF" {
    if round==1 | round==2 | round==3 | round==4 {
        recode wealth 2=3 3=5
        }
    }
    
if country=="CD" {
    if province==1 {
        if round==1 {
            gen ur=1
            gen region=1
            gen tsinceb=70
            }
        if round==2 {
            gen ur=1
            gen region=1
            *recode school 0=0 1=1 2 4=2 3 5 6=3 -99=-99
            *label define schoolcdr11 0 "Never attended" 1 "Primary" 2 "Secondary" 3 "Superior" -99 "-99", replace
            }
        if round==3 {
            *gen ur==1
            gen region=1
            }
        if round==4 {
            gen region=1
            label def region_list 1 "Kinshasa"
            label val region region_list
            }
        if round==5 {
            gen region=1
            label def region_list 1 "Kinshasa"
            label val region region_list
            }
        }
    if province==2 {
        if round==4 | round==5 {
            gen region=2
            label def region_list 2 "Kongo Central"
            label val region region_list
            }
        }
    }

if country=="Ethiopia" | country=="ET" {
    if round==1 | round==2 | round==3 | round==4 {
        drop region
        rename regionnum region
        gen region_soi=region
        recode region_soi 10=1 3=2 4=3 7=4 1=5 2=6 5=6 6=6 8=6 9=6 11=6
        label define region_soi_list 1 addis 2 amhara 3 oromiya 4 snnp 5 tigray 6 other
        labe val region_soi region_soi_list
        drop region
        rename region_soi region
        }
    }
    
if country=="GH" {
    if round==2 {
        rename fees_6months fees_12months
        }
    if round==5 {
        recode current_method_recode 11=9 32=10
        }
    }

if country=="ID" {
    if round==1 {
        drop wealthquintile_SS wealthquintile_MK
        recode school 5=4
        }
    }
    
if country=="India_Rajasthan" {
    if round==1 | round==2 {
        gen region=1
        }
    }
    
if country=="KE" {
    }

if country=="NE" {
    if round==1 {
        recode wealthtertile 1=1 2=3 3=5 
        }
    if round==2 {
        drop region
        label drop region_list
        gen region=.
            replace region=1 if strata=="niamey"
            replace region=2 if strata=="other urban"
            replace region=3 if strata=="rural"
            label define region_list 1 "Niamey" 2 "Other Urban" 3 "Rural"
            label val region region_list
            */
        /*Generate region variable
        keep if level1=="niamey"
        gen region=1
        */
        recode wealthtertile 1=1 2=3 3=5 
        }
    if round==3 {
        recode wealthtertile 1=1 2=3 3=5 
        rename level1 region
        }
    if round==4 {
        rename wealthtertile_National wealth
        *rename wealthtertile_Niamey wealth
        }
    }

if country=="Nigeria" {
    rename Cluster_ID EA_ID
    if round==1 | round==2 {
        if state==1 {
            rename wealthquintile_Lagos wealth 
            tostring wealth, replace force
            gen region=1
            }
        if state==2 {
            rename wealthquintile_Kaduna wealth
            tostring wealth, replace force
            gen region=1
            }
        }
    if round==3 {
        *if `state'=="Kaduna" {
        *    keep if state==1
        *    }
        *if `state'=="Lagos" {
        *    keep if state==2
        *    }
        *if `state'=="Taraba" {
        *    keep if state==3
        *    }
        *if `state'=="Kano" {
        *    keep if state==4
        *    }
        *if `state'=="Rivers" {
        *    keep if state==5
        *    }
        *if `state'=="Nasarawa" {
        *    keep if state==6
        *    }
        *if `state'=="Anambra" {
        *    keep if state==7
        *    }
        *gen region==1
        *drop HHweight FQweight wealthquintile
        *rename HHweight_`state' HHweight
        *rename FQweight_`state' FQweight
        *rename wealthquintile_`state' wealth
        
        rename HHweight_National HHweight
        rename FQweight_National FQweight
        rename wealthquintile_National wealth
        rename state region
        }
    }
    
if country=="UG" {
    if round==1 {
        recode school 2=1 3=2 4=2 5=3 6=4
        label define schooll 0 Never 1 Primary 2 Secondary 3 Technical_Vocational 4 University, replace
        }
    if round==2 | round==3 | round==4 {
        recode school 2=1 3=2 4=2 5=3 6=4
        }
    if round==5 {
        recode school 2=1 3=2 4=2 5=3 6=4
        *rename DHSregionnum region
        }
    }

save "$datadir/`analysisdata'_v2.dta", replace
/******************************************************************************************************************
Run .do files
******************************************************************************************************************/

*Do file b
do "$dofiles/`othertables'"

*Do file c
use "$datadir/`analysisdata'_v2.dta", clear
do "$dofiles/`vargen'"

*Do file d
use "$datadir/`CCRX'_SOIPrep_HHQFQ_vargen.dta"
do "$dofiles/`countryspecific'"

*Export
use "$datadir/`CCRX'_SOITable_HHQFQ_SOI.dta", clear
export delimited using "$csv_results/`CCRX'_HHQFQ_SOITable_$today", replace


