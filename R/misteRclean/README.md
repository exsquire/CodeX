# Description:
misteRclean is a pipeline for building and testing master datasets.

***

# Purpose: 
Large studies often incorporate data from various raw data files. The structure of these files are often different from one another based on the various output structures/protocols of different machines, pipelines, facilities, or individual collaborators. As of now, there is no clear nor elegant way to programatically clean, reformat, and merge said raw data.

In misteRclean, we suggest a pipeline-based approach where raw data files are assembled and processed by hand into analysis-specific CSVs with a common format and key.

As the CSVs are built, the researcher compiles a codebook, which is a data dictionary with additional columns that can be used to direct cleaning functions in R and link the master data back to specific raw files for future reference and QC. 

Finally, the CSVs are merged into a master file by a full outer join, keeping all unique columns and rows. This "processed_master" can be used as is or compared to an existing_master data set to find discrepancies in either the processed_master (raw data) or existing master. 

There are several benefits to this approach:

**Simplifies Data Format:** Transferring data from spreadsheets into .csv format removes hidden code, distracting formatting, and Date/Time system oddities, which are common in certain file types, such as .xlsx, and can have unforseen effects on your data when copying and pasting. 

**Improves Data Familiarity:** The old-fashioned method of building the CSVs and data dictionary by hand gives the researcher a chance to explore their dataset in digestible modules while serving as a first pass for outliers or errors in the raw data.

**Collaboration and QC:** Having a data dictionary, a directory of the raw data and processed data, and a column linking specific variables to their raw file sources at the end makes sharing your work and subsequent quality control steps more manageable. 

**Ease of Analysis:** Processed CSVs are assembled in a single object in R allowing for analysis within or across individual data files. Summary reports of missing samples, NAs, outliers, etc. can be easily generated.  

**Speed and completeness:** When comparing the processed_master to the existing_master, all cells can be checked against one another in a matter of seconds. Allowing for faster turn around of high confidence data and a more complete understanding of where errors in your data cleaning process may have occurred. 

***
