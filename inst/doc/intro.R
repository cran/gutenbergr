## -----------------------------------------------------------------------------
knitr::opts_chunk$set(
  collapse = FALSE,
  comment = "#>",
  fig.width = 7,
  fig.height = 6,
  warning = FALSE,
  message = FALSE
)

## -----------------------------------------------------------------------------
tryCatch(
  library(gutenbergr),
  error = function(e) {
    # Fallback for Windows check environments
    devtools::load_all("..")
  }
)

## -----------------------------------------------------------------------------
library(dplyr)
library(stringr)

## -----------------------------------------------------------------------------
gutenberg_metadata

## -----------------------------------------------------------------------------
gutenberg_metadata |>
  filter(title == "Persuasion")

## -----------------------------------------------------------------------------
gutenberg_works()

## -----------------------------------------------------------------------------
gutenberg_works(author == "Austen, Jane")

# Using regular expressions
gutenberg_works(str_detect(author, "Austen"))

# Multiple conditions
gutenberg_works(author == "Dickens, Charles", has_text == TRUE)

## -----------------------------------------------------------------------------
gutenberg_subjects

## -----------------------------------------------------------------------------
# Find detective stories
gutenberg_subjects |>
  filter(subject == "Detective and mystery stories")

# Find Sherlock Holmes stories
gutenberg_subjects |>
  filter(grepl("Holmes, Sherlock", subject))

## -----------------------------------------------------------------------------
# # Get IDs of detective stories
# detective_ids <- gutenberg_subjects |>
#   filter(subject == "Detective and mystery stories") |>
#   inner_join(gutenberg_works(), by = "gutenberg_id") |>
#   pull(gutenberg_id)
# 
# # Download a sample
# detective_stories <- gutenberg_download(
#   detective_ids[1:5],
#   meta_fields = c("title", "author")
# )

## -----------------------------------------------------------------------------
gutenberg_authors

## -----------------------------------------------------------------------------
# # Find works by 19th century authors
# nineteenth_century_gutenberg_authors <- gutenberg_authors |>
#   filter(birthdate >= 1800, birthdate < 1900) |>
#   inner_join(gutenberg_works(), by = "gutenberg_author_id")

## -----------------------------------------------------------------------------
# persuasion <- gutenberg_download(105, meta_fields = c("title", "author"))

## -----------------------------------------------------------------------------
persuasion <- filter(gutenbergr::sample_books, gutenberg_id == 105)

## -----------------------------------------------------------------------------
persuasion

## -----------------------------------------------------------------------------
# books <- gutenberg_download(c(105, 109))

## -----------------------------------------------------------------------------
books <- gutenbergr::sample_books

## -----------------------------------------------------------------------------
books

## -----------------------------------------------------------------------------
# books <- gutenberg_download(c(105, 109), meta_fields = c("title", "author"))

## -----------------------------------------------------------------------------
books |>
  count(title)

## -----------------------------------------------------------------------------
# # Download all of Aristotle's works with titles
# aristotle_books <- gutenberg_works(author == "Aristotle") |>
#   gutenberg_download(meta_fields = "title")

