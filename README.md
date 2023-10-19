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
- The script will output all A files and their extracted files in a folder within the working directory called WAMEX_DATA_EXTRACTED.
- Files are called by their A File Number


## Convert To Jpg Script
**Purpose:** Convert_to_jpg.ipynb is built to convert the pdf documents to .jpg files which can then be fed into the table transformer model.
**Requirements:**
1. Python Libraries [shutil, pdf2image, os]
2. WAMEX Web Scraping Script has been run and files are stored in WAMEX_DATA_EXTRACTED

**To Run Script:**
1. Update main_dir to the WAMEX_DATA_EXTRACTED file created from the WAMEX Web Scraping Script.

**Output:**
- This script will convert all pdf documents into jpg files.
- Once converted it will store all the non jpg files in a folder called Original_files.
- jpg files are names in the following format AFile_DocumentNum_PageNum for example Afile '111' Document 1 and Page 1 will be called 111_1_1.jpg.

## Table Transformer Script

**Purpose:** table_transformer.ipynb is located in the file _Capstone Project - Table Text Extraction_ and performs the table detection and extraction of text table information from the WAMEX database. This script operates off the back of the  Web_Scraping_Python.ipynb and Convert_to_jpg.ipynb to extract the tables from the images generated. 

**Requirements:**
- Python Libraries
1. Standard Libraries [csv, json, os, re, shutil, pandas, numpy]
2. Analysis Libraries [sklearn.metrics]
3. Visulisation Libraries [matplotlib, seaborn]
4. Image Processing and OCR [PIL, cv2, pytesseract]
5. Transformers and Huggingface_hub [huggingface_hub, transformers]
6. Pytorch [torch]
- Pytesseract OCR

### Setup 

**Enviroment Setup:**
1. Create a new enviroment (use whichever method you like; conda, anaconda, venv...)
2. In command Prompt cd into the Geological-Report-Similarity-Analysis directory
3. Run pip install -r requirements.txt
4. This will take time to install all nessecary libraries. 

**Pytesseract Setup:**
1. The Pytesseract Executable is available at https://github.com/UB-Mannheim/tesseract/wiki download the 64bit .exe if using windows.
2. Run the Tesseract Setup once downloaded this should be installed as C:\Program Files\Tesseract-OCR
3. Once this is Setup set a PATH enviroment variable to C:\Program Files\Tesseract-OCR. System -> About -> Advanced system settings -> Enviroment Variables -> System variables -> Path -> Edit -> New -> paste the location of the Tesseract folder.
4. In table_transformer.ipynb update TESSERACT_PATH to folder location r'C:/Program Files/Tesseract-OCR/tesseract'

**Paddle OCR Setup:**
1. If you have CUDA enabled GPU please use pip install paddlepaddle-gpu (This is used in the requirements Script)
2. If you do not have CUDA enabled GPU please use pip install paddlepaddle

### Table Detection

**To Run Script:**
- Ensure you have updated DATA_PATH to be the path to the repository
- Ensure you have run Web_Scraping_Python.ipynb and table_transformer.ipynb. This will generate the WAMEX DATA in a file called WAMEX_DATA_EXTRACTED

**Output:**
- The Table Detection Model scans each .jpg file and will extract tables in a Cropped Images Subfolder. These Subfolders are named by the Afile_DocNum_PageNum so for tables contained on Afile '111' Document 1 and Page 1 these will be contained within '111_1_1 Cropped Images'.
- Within these folders are the extracted table images and they are named by 111_1_1_table_0 for Afile_DocNum_PageNum_table_num.
- After detection and the images are extracted all .jpg files are placed in a folder called jpg_extracted for neatness.

### Table Extraction

**To Run Script:**
- Ensure you have run Table Detection and A File Folders contain the extracted Tables in Cropped Images Folders.

**Output:**
- The Table Extraction Model will run over each of the tables contained within the Cropped Images files.
- It will perform Table extraction and save these tables to csv in the A file folder.
- Tables are extracted to csv and are named as Afile_Doc_Page_table_Num. For example 111_1_1_table_0.csv for Afile '111' Document 1 and Page 1 Table 1


 


