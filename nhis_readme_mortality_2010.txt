


NATIONAL HEALTH INTERVIEW SURVEY (NHIS) Public-use Linked Mortality Files
                          SURVEY YEARS 1986-2004					    

		            Updated December 11, 2013
 
                       PUBLIC USE DATA RELEASE

* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *


WARNING - DATA USE RESTRICTIONS! Read Carefully Before Use

The Public Health Service Act (Section 308 (d)) provides that 
the data collected by the National Center for Health Statistics 
(NCHS), Centers for Disease Control and Prevention (CDC), may be 
used only for the purpose of health statistical reporting and
analysis.

Any effort to determine the identity of any reported case is 
prohibited by this law.

NCHS does all it can to assure that the identity of data 
subjects cannot be disclosed.  All direct identifiers, as
well as any characteristics that might lead to identification,
are either omitted from the data files or perturbed to prevent 
re-identification.  Any intentional identification or disclosure
of a person or establishment violates the assurances of 
confidentiality given to the providers of the information.
Therefore, users will:

       1. Use the data in these data files for statistical 
          reporting and analysis only.

       2. Make no use of the identity of any person or 
          establishment discovered inadvertently and advise the 
          Director, NCHS, of any such discovery (301-458-4500).

       3. Not link these data files with individually 
          identifiable data from other NCHS or non-NCHS data 
          files.

By using these data, you signify your agreement to comply with 
the above-stated statutorily based requirements.



- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

INTRODUCTION

NCHS conducted an updated linkage of the National Health Interview 
Survey (NHIS) to death certificate data found in the National Death 
Index (NDI).  Linkage of the NHIS survey participants with the NDI 
provides the opportunity to conduct studies designed to investigate
the association of a variety of health factors with mortality, using
the richness of the NHIS questionnaires. NCHS recommends that 
researchers use these new linked mortality files as they supersede
all prior data releases of the NHIS Public-use Linked Mortality files.
NCHS used a different linkage methodology for this NHIS-NDI linkage
than previous NHIS-NDI linkages.

DATA FILE DESCRIPTION

The NHIS Public-use Linked Mortality Files include the NHIS survey 
years 1986 to 2004 with mortality follow-up through December 31, 2006.
Mortality information is based upon the results from a probabilistic 
match between NHIS and NDI death certificate records.  All NHIS
participants are included on the Public-use Linked Mortality Files. 
Each NHIS survey year (1986-2004) is available on a separate data file,
with a consistent file format for all years. 

MORTALITY LINKAGE METHODOLOGY DOCUMENTATION

NCHS employed a matching methodology for the NHIS Linked Mortality
Files that was similar, but not identical, to the standard methodology
offered by the NDI. The matching methodology document contains detailed 
information regarding the methodology utilized for the linkage. Users
are urged to carefully read this document to gain a better understanding
of the matching methodology employed to link NHIS records to death
records in the NDI. The matching methodology document can be found at 
this web site:
http://www.cdc.gov/nchs/data/datalinkage/matching_methodology_nhis_final_2010.pdf


NHIS PUBLIC-USE LINKED MORTALITY FILE SAMPLE PROGRAMS

There are two sample programs provided to assist researchers when reading
in the NHIS Public-use Linked Mortality ASCII files.

The first sample program provides data input statements. By using the 
ASCII data file (.DAT file) as input to the program, other types of
data files (e.g. SAS, SPSS) can be created. The NHIS sample ASCII
input statement program that reads in the NHIS 1990 Public-use Linked
Mortality File can be found at this web site:

ftp://ftp.cdc.gov/pub/Health_Statistics/NCHS/datalinkage/linked_mortality/nhis_sample_ascii_pgm_2010.sas

The second sample program provides researchers using STATA with code to read
in the data file and run their analyses using the STATA software. The 
NHIS sample STATA program that readS in the NHIS 1990 Public-use
Linked Mortality File can be found at this web site:

ftp://ftp.cdc.gov/pub/Health_Statistics/NCHS/datalinkage/linked_mortality/nhis_sample_stata_ascii_pgm_2010.do

NOTE TO STATA USERS: If STATA users click on the "Sample STATA Program" link,
STATA may attempt to automatically run the program, resulting in an error message.
To avoid getting an error message, we suggest STATA users save the program by right
clicking on the link "Sample STATA Program" and select the "Save Target As" option.

FILE NAME	                     FILE DESCRIPTION		               FORMAT  (KB)

NHIS86_MORT_PUBLIC_USE.ASCII         NHIS 1986 Linked Mortality File           ASCII   
NHIS87_MORT_PUBLIC_USE.ASCII         NHIS 1987 Linked Mortality File           ASCII   
NHIS88_MORT_PUBLIC_USE.ASCII         NHIS 1988 Linked Mortality File           ASCII    
NHIS89_MORT_PUBLIC_USE.ASCII         NHIS 1989 Linked Mortality File           ASCII   
NHIS90_MORT_PUBLIC_USE.ASCII         NHIS 1990 Linked Mortality File           ASCII   
NHIS91_MORT_PUBLIC_USE.ASCII         NHIS 1991 Linked Mortality File           ASCII   
NHIS92_MORT_PUBLIC_USE.ASCII	     NHIS 1992 Linked Mortality File           ASCII   
*nhis92_mod_mort_public_use.ASCII    NHIS 1992 Modified Linked Mortality File  ASCII   		      
NHIS93_MORT_PUBLIC_USE.ASCII         NHIS 1993 Linked Mortality File           ASCII   
NHIS94_MORT_PUBLIC_USE.ASCII         NHIS 1994 Linked Mortality File           ASCII   
NHIS95_MORT_PUBLIC_USE.ASCII         NHIS 1995 Linked Mortality File           ASCII   
NHIS96_MORT_PUBLIC_USE.ASCII	     NHIS 1996 Linked Mortality File           ASCII   
NHIS97_MORT_PUBLIC_USE.ASCII         NHIS 1997 Linked Mortality File           ASCII   
NHIS98_MORT_PUBLIC_USE.ASCII         NHIS 1998 Linked Mortality File           ASCII   
NHIS99_MORT_PUBLIC_USE.ASCII         NHIS 1999 Linked Mortality File           ASCII   
NHIS00_MORT_PUBLIC_USE.ASCII         NHIS 2000 Linked Mortality File           ASCII   
NHIS01_MORT_PUBLIC_USE.ASCII         NHIS 2001 Linked Mortality File           ASCII   
NHIS02_MORT_PUBLIC_USE.ASCII         NHIS 2002 Linked Mortality File           ASCII   
NHIS03_MORT_PUBLIC_USE.ASCII         NHIS 2003 Linked Mortality File           ASCII   
NHIS04_MORT_PUBLIC_USE.ASCII         NHIS 2004 Linked Mortality File           ASCII   



*In 1992, the NHIS included an oversample of Hispanics by re-interviewing
the 1991 households that were identified as containing people of Hispanic
heritage. Records for the oversample of Hispanic persons (those also 
sampled in 1991) have been deleted from the NHIS 1992 Modified Linked 
Mortality File and the weights of the remaining sample have been revised 
accordingly. These are the only changes to these files.  These revised
files have been created primarily for those who need to combine 1991
and 1992 data files for analytic purposes. 


NHIS PUBLIC-USE LINKED MORTALITY FILE DOCUMENTATION

There is a data file layout (also called data dictionary) associated with 
the NHIS Public-use Linked Mortality Data Files. The data file layout is 
the same for NHIS 1986-2004 and is in PDF format that can be viewed with 
Adobe Acrobat software. The Adobe Acrobat Reader Software can be downloaded
from the Adobe Acrobat Web site at:

http://www.adobe.com/prodindex/acrobat/readstep.html

The data file layout can be found at this web site:
http://www.cdc.gov/nchs/data/datalinkage/nhis_file_layout_public_2010.pdf


NHIS PUBLIC-USE LINKED MORTALITY FILES' RECORD SEQUENCE

All records on the NHIS Public-use Linked Mortality Files have been 
sorted by the NHIS person level PUBLICID. Detailed instructions are
provided showing the construction of the NHIS PUBLICID at this web site:
http://www.cdc.gov/nchs/data/datalinkage/nhis_file_layout_public_2010.pdf

MERGING THE NHIS PUBLIC-USE LINKED MORTALITY FILES TO OTHER PUBLIC-USE NHIS FILES

To merge data from the NHIS Public-use Linked Mortality Files to the person
level public-use NHIS files, the PUBLICID variable provided on the Linked 
Mortality Files should be used. User should review the Detailed Notes for 
Selected Variables in the file layout to construct the PUBLICID at the web site:
http://www.cdc.gov/nchs/data/datalinkage/nhis_file_layout_public_2010.pdf

For users who prefer to include the NHIS family serial number in the NHIS
public-use Id number, an additional public-use Id, PUBLICID_2, has been
included on the Public-use NHIS Linked Mortality Files.  PUBLICID_2 is
only available on the NHIS 1997-2003 Linked Mortality Files. Refer to
the detailed notes for the creation of the NHIS public-use Id
number, PUBLICID, for NHIS survey years 1986-1996. Both PUBLICID and 
PUBLICID_2 provide unique person-level Id numbers. 

http://www.cdc.gov/nchs/data/datalinkage/nhis_file_layout_public_2010.pdf

Users who want to combine across multiple NHIS survey years, should: 

1. Review the NHIS 1992 readme file (link below) regarding use of the 
modified 1992 NHIS public-use files to remove the Hispanic oversample
when combining the NHIS years 1991 and 1992.  
ftp://ftp.cdc.gov/pub/Health_Statistics/NCHS/Program_Code/NHIS/1992/readmenh.txt

2. Use the new eligibility-adjusted sample weights. Users should refer to the 
Analytic Guidelines document for notes on the variables WGT_NEW and SA_WGT_NEW
at the web site: 
http://www.cdc.gov/nchs/data/datalinkage/nhis_mort_analytic_guidelines.pdf

3. Refer to the detailed notes in the file layout on the public-use ID 
construction when merging the NHIS 1986-2004 public-use survey files to the 
NHIS 1986-2004 Public-use Linked Mortality Files at the web site:
http://www.cdc.gov/nchs/data/datalinkage/nhis_file_layout_public_2010.pdf



CONTACT INFORMATION

Updates about new data releases, publications, or errors will be 
sent to members of the NHIS Listserv.  To join, visit the  
website at:

http://www.cdc.gov/nchs/about/major/nhis/nhislist.htm

For additional information on NHIS data linkage products, please visit the
NCHS data linkage web page at:

http://www.cdc.gov/nchs/data_access/data_linkage_activities.htm


For additional information on NHIS data products:

   Phone   : 301-458-4901
   FAX     : 301-458-4035
   E-mail  : nhislist@cdc.gov
   Internet: http://www.cdc.gov/nchs/nhis.htm


For additional information on other NCHS data products:

   Phone   : 800-CDC-INFO 
   E-mail  : nchsquery@cdc.gov
   Internet: http://www.cdc.gov/nchs


Although the NHIS Public-use Linked Mortality Files were 
carefully edited, errors may be detected. Please e-mail the NCHS 
Data Linkage Staff at datalinkage@cdc.gov if any errors are detected
in the NHIS Public-use Linked Mortality File(s) data or documentation. 

STATEMENT OF AUTHENTICITY

This material has been cleared for public distribution by 
CDC/ATSDR and will be authentic if obtained directly from 
ftp://ftp.cdc.gov/pub/Health_Statistics/NCHS/.  CDC/ATSDR takes 
all effort to assure the authenticity of electronically 
distributed documents.  However, in all instances where the 
electronic and official agency record differ, the authenticity 
of the official agency record is controlling.


GUIDELINES FOR CITATION OF THE 1986-2004 NHIS PUBLIC-USE LINKED MORTALITY DATA

With the goal of mutual benefit, the National Center for Health 
Statistics (NCHS) requests that recipients of data files cooperate
in certain actions related to their use.  Any published material 
derived from the data should acknowledge NCHS as the original source.
The suggested citation to appear at the bottom of all published 
tables is as follows:

Source: National Center for Health Statistics 

When cited in a bibliography, the citation should read:

National Center for Health Statistics. Office of Analysis and
Epidemiology, Public-use National Health Interview Survey Linked
Mortality Files, 2010.  Hyattsville, Maryland. (Available at 
the following address: 
http://www.cdc.gov/nchs/data_access/data_linkage/mortality/nhis_linkage.htm)

The published material should also include a disclaimer that credits
any analyses, interpretations, or conclusions reached to the author
(recipient of the data file) and not to NCHS, which is responsible
only for the initial data.  Consumers who wish to publish a technical
description of the data should make an effort to insure that the 
description is not inconsistent with that published by NCHS.





 

 