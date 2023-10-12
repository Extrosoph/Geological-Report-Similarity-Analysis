## TITLE: WAMEX WEB SCRAPING SCRIPT
## PURPOSE: GIVEN A SET OF 'A' FILE NUMBERS THIS SCRIPT WILL DOWNLOAD AND STORE REPORTS IN THE LOCAL DIRECTORY
## DATE: 23/08/2023
## AUTHOR: NICK HILL
## INFO: THIS SCRIPT REQUIRES YOU TO HAVE RSELENIUM SETUP ON YOUR COMPUTER
## FOR HOW TO SETUP SEE: https://www.bing.com/videos/riverview/relatedvideo?&q=HOW+TO+SETUP+R+SELENIUM+2023&&mid=DBD4AE1ED6DA5268FAE3DBD4AE1ED6DA5268FAE3&&FORM=VRDGAR

# Import Libraries

library(RCurl)
library(readxl)
library(tidyverse)
library(RSelenium)
library(wdman)
library(netstat)
library(rvest)
library(dplyr)

# Set working Directory

setwd('C:/Users/nick2/Desktop/Capstone Code/All Files')

# Read in Excel File Containing all the links to the reports 

df <- read_excel("WAMEX Results.xlsx", sheet = "WAMEX Results")

# Contains the urls of each 'A' number. Alternatively use https://geodocs.dmirs.wa.gov.au/Web/documentlist/10/Report_Ref/A#### <- replace with A number 
urls <- df$Contents

# Contains 'A' Number
names <- df$ANumber

# Create R Selenium Driver and Connection (Firefox is used in this instance)

selenium_object <- selenium(retcommand = T, check = F)

remote_driver <- rsDriver(browser='firefox',
                          verbose=FALSE,
                          port = free_port())

remDr <- remote_driver$client
remDr$open()

# Start a counter for the filenames

file_count <- 1  

# File find and Download Function - This finds, downloads and saves the files in the working directory.

download_and_save <- function(df, file_extension, folder_path){
  # Check if the dataframe is empty
  if (nrow(df) == 0) {
    print("No valid links found.")
    return() # Exit the function
  }
  
  for(i in 1:nrow(df)){
    file_name <- as.character(df[i, 1])
    url <- as.character(df[i, 2])
    
    # Check if url is character(0) or NA
    if(is.na(url) || url == "") {
      print(paste("File name not found for", file_name))
      next
    }
    
    # Create the full path for the output file
    output_path <- file.path(folder_path, paste0(file_name, '.', file_extension))
    binary_data <- tryCatch({
      httr::GET(url, httr::write_disk(output_path, overwrite = TRUE))
      TRUE
    }, error=function(e) FALSE)
    
    if(binary_data){
      print(paste("File downloaded to", output_path))
    } else {
      print(paste("Failed to download", file_name))
    }
  }
}


# Main Process loop
for(i in 1:length(urls)) {
  # Create subfolder for each ANumber
  folder_name <- as.character(names[i])
  folder_path <- file.path(getwd(), folder_name)
  if(!dir.exists(folder_path)){
    dir.create(folder_path)
  }
  
  test <- urls[i]
  remDr$navigate(test)
  
  # Give some time for the website to load its content
  Sys.sleep(15)  # Adjust this time as necessary
  
  # Extract the rendered HTML
  rendered_html <- remDr$getPageSource()[[1]]
  parsed_html <- read_html(rendered_html)
  
  # Extract text from <tr> elements - These contain elements relating to the size of the file
  tr_data <- parsed_html %>% 
    html_nodes("tr") %>%
    purrr::map_df(~tibble(
      tr_text = html_text(.x)
    ))
  
  tr_data <- as.data.frame(tr_data)
  tr_data <- tr_data[2:nrow(tr_data),]
  
  # Not all files have sizes. This code replaces those rows without with an NA value for size. 
  sizes <- sub('.*?([0-9.]+ (KB|MB|GB|BYTES)).*', '\\1', toupper(tr_data))
  sizes[!grepl("(KB|MB|GB|BYTES)", sizes)] <- NA
  tr_data <- trimws(sizes)
  
  # Extract links from <a> elements - This contains information about the download link and the title of the file.
  links_data <- parsed_html %>% 
    html_nodes("a") %>%
    purrr::map_df(~tibble(
      link_text = html_text(.x),
      link_url = html_attr(.x, "href")
    ))
  
  
  links_df <- as.data.frame(links_data)
  links_df <- links_df[which(grepl('http',links_df$link_url)),]
  

  # Join the Size data to the dataframe
  links_df$Size <- tr_data
  
  
  # Separates the size and units into seperate columns. For example '12.3mb' becomes '12','mb'
  links_df <- links_df %>%
    mutate(unit = str_extract(Size, "[A-Za-z]+"),
           value = as.numeric(str_extract(Size, "[0-9]+(\\.[0-9]+)?")))
  
  selected_df <- links_df[which((toupper(links_df$unit) == 'KB') | 
                              (toupper(links_df$unit) == 'MB' & links_df$value < 30) | (toupper(links_df$unit) == 'BYTES')) ,]
  
  
  # We are looking to identify all .pdf, .docx and .zip files. Can adjust this to meet requirements. 
  pdf_urls <- as.data.frame(selected_df [which(grepl('\\.PDF', toupper(selected_df$link_text))), 1:2])
  doc_urls <- as.data.frame(selected_df [which(grepl('\\.DOCX', toupper(selected_df$link_text))), 1:2])
  zip_urls <- as.data.frame(selected_df [which(grepl('\\.ZIP', toupper(selected_df$link_text))), 1:2])
  
  # Download PDF and ZIP files - Performs function action on urls.
  download_and_save(pdf_urls, 'pdf', folder_path)
  download_and_save(doc_urls, 'docx', folder_path)
  download_and_save(zip_urls, 'zip', folder_path)
}

# Close the Server 
remDr$close()
remote_driver$server$stop()

# Files will be saved in local directory.
