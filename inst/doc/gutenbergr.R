## ----setup, include = FALSE---------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  message = FALSE,
  warning = FALSE
)

## ----packages-used------------------------------------------------------------
library(gutenbergr)
library(dplyr)
library(stringr)
library(tidytext)

## ----basics-------------------------------------------------------------------
gutenberg_metadata

## ----filter-------------------------------------------------------------------
gutenberg_metadata |>
  filter(title == "Persuasion")

## ----works--------------------------------------------------------------------
gutenberg_works()

## ----Austen-------------------------------------------------------------------
gutenberg_works(author == "Austen, Jane")

# or with a regular expression
gutenberg_works(str_detect(author, "Austen"))

## ----load 1 file, echo=FALSE--------------------------------------------------
persuasion <- dplyr::filter(gutenbergr::sample_books, gutenberg_id == 105)

## ----load 1 from web, eval = FALSE--------------------------------------------
# persuasion <- gutenberg_download(105)

## ----display persuasion-------------------------------------------------------
persuasion

## ----load 2 from file, echo=FALSE---------------------------------------------
books <- gutenbergr::sample_books

## ----load 2 from web, eval = FALSE--------------------------------------------
# books <- gutenberg_download(c(109, 105), meta_fields = c("title", "author"))

## ----display books------------------------------------------------------------
books

## ----count books--------------------------------------------------------------
books |>
  count(title)

## ----subjects-----------------------------------------------------------------
gutenberg_subjects

## ----filter subjects----------------------------------------------------------
gutenberg_subjects |>
  filter(subject == "Detective and mystery stories")

gutenberg_subjects |>
  filter(grepl("Holmes, Sherlock", subject))

## ----authors------------------------------------------------------------------
gutenberg_authors

## ----tidytext-----------------------------------------------------------------
words <- books |>
  unnest_tokens(word, text)

words

word_counts <- words |>
  anti_join(stop_words, by = "word") |>
  count(title, word, sort = TRUE)

word_counts

