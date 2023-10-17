# Geological-Report-Similarity-Analysis
Develop a geology-focused system capable of interpreting table structures, extracting values, calculating similarity, and visualizing information through graphs, enabling data-driven analysis and decision-making.


## WAMEX Web Scraping Script
**Purpose:** Web_Scraping_Python.ipynb contains a script which is made to scrape Afile data from the WAMEX database. 
**Requirements:** 
1. A list of A file Numbers of interest stored in an excel doc such as the example WAMEX Results.xlsx
2. Python libraries [selenium, bs4, pandas, urllib, re, time, os]
3. Mozilla Firefox
4. Gecko Driver
   - To install go to https://github.com/mozilla/geckodriver/releases.
   - Download geckodriver-v0.33.0-win-aarch64.zip if on windows.
   - Copy Executable into a new Program File Called Gecko Driver.
   - Set file to Path Variable in System variables.

**To Run Script:**
1. Ensure all libraries are installed
2. Update firefox_path to the firefox executable
3. Update wd to the working directory containing the WAMEX A File spreadsheet

**Output:**
The script will output all A files and their extracted files in a folder within the working directory called WAMEX_DATA_EXTRACTED. Files are called by their A File Number



