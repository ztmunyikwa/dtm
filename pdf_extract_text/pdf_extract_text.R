# install.packages("dplyr")
# install.packages("pdftools")
# install.packages("jsonlite")

library(dplyr)
library(pdftools)
library(jsonlite)

pdf_extract_text_file <- function(filename) {
  # filename <- filenames[1]

  ## remove ".pdf"
  name <- substr(filename, 1, nchar(filename)-4)


  ## read pdf and extract text
  path <- paste0("pdf/", name, ".pdf")
  pdf <- pdf_text(path)
  # cat(pdf[1])


  ## to txt
  path <- paste0("txt/", name, ".txt")
  fileConn <- file(path)
  writeLines(pdf, fileConn)
  close(fileConn)


  ## to json (separated by pages)
  pdf <- as.list(pdf)
  names(pdf) <- seq_along(pdf)

  # jsonlite::write_json(pdf, path)
  jsn <- jsonlite::toJSON(pdf)
  path <- paste0("json/", name, ".json")
  fileConn <- file(path)
  writeLines(jsn, fileConn)
  close(fileConn)

  print(name)
}

pdf_extract_text <- function() {
  if (!dir.exists("pdf")) stop("Need 'pdf' subfolder")
  if (!dir.exists("txt")) stop("Need 'txt' subfolder")
  if (!dir.exists("json")) stop("Need 'json' subfolder")
  filenames <- list.files("pdf/")
  filenames %>% lapply(pdf_extract_text_file) %>% unlist
}

setwd(".../pdf_extract_text")  # update this
pdf_extract_text()
