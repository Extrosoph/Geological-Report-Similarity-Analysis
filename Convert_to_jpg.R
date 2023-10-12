library(magick)

setwd('C:/Users/nick2/Desktop/Capstone Code/Nick Annotating Files')


# ... [earlier parts of your code]

# Loop through each subfolder
for (subfolder in subfolders) {
  
  # Change working directory to the current subfolder
  setwd(file.path(main_dir, subfolder))
  
  # Get the PDF files in the current subfolder
  pdf_files <- list.files(pattern = "\\.pdf$", recursive = FALSE, full.names = TRUE)
  
  # Check if there's any PDF files in the subfolder
  if(length(pdf_files) > 0) {
    # Loop through each PDF in the current subfolder
    for (pdf_file in pdf_files) {
      
      # Extract images from PDF and save as bitmap (by default as PNG)
      bitmap_files <- pdf_convert(pdf_file, dpi = 300)
      
      # Each bitmap corresponds to a page in the PDF
      for (i in 1:length(bitmap_files)) {
        
        # Read the bitmap file using magick
        img <- image_read(bitmap_files[i])
        
        # Define the jpg file name based on the subfolder name and page number
        jpg_file_name <- paste0(subfolder, "_", i, ".jpg")
        
        # Write image to JPG using magick
        image_write(img, path = jpg_file_name, format = "jpg")
        
        # Optionally, you can delete the bitmap file to clean up
        file.remove(bitmap_files[i])
      }
    }
  }
  
  # Change back to the main directory after processing the current subfolder
  setwd(main_dir)
}

print("Conversion complete!")

