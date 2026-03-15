## -----------------------------------------------------------------------------
knitr::opts_chunk$set(
  collapse = FALSE,
  comment = "#>",
  fig.width = 7,
  fig.height = 6,
  fig.path = "../man/figures/",
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
library(tidytext)
library(ggplot2)
library(tidyr)
library(stringr)

## -----------------------------------------------------------------------------
gutenberg_works(str_detect(title, "Persuasion"))

## -----------------------------------------------------------------------------
# persuasion <- gutenberg_download(105, meta_fields = "title")

## -----------------------------------------------------------------------------
# For vignette building, use sample data
persuasion <- gutenbergr::sample_books |>
  filter(gutenberg_id == 105) |>
  select(gutenberg_id, text, title)

## -----------------------------------------------------------------------------
persuasion

## -----------------------------------------------------------------------------
persuasion <- persuasion |>
  gutenberg_add_sections(
    pattern = "^Chapter [IVXLCDM]+",
    section_col = "chapter",
    format_fn = function(x) {
      x |>
        str_remove("^CHAPTER\\s+") |>
        str_remove("\\.$") |>
        as.roman() |>
        as.numeric()
    }
  )

# Preview the new structure
persuasion |>
  filter(!is.na(chapter)) |>
  head()

## -----------------------------------------------------------------------------
words <- persuasion |>
  unnest_tokens(word, text) |>
  anti_join(stop_words, by = "word")

## -----------------------------------------------------------------------------
word_counts <- words |>
  count(word, sort = TRUE)

word_counts

## -----------------------------------------------------------------------------
word_counts |>
  slice_max(n, n = 20) |>
  mutate(word = reorder(word, n)) |>
  ggplot(aes(x = n, y = word, fill = word)) +
  geom_col(show.legend = FALSE) +
  labs(
    title = expression(paste("Most Common Words in ", italic("Persuasion"))),
    x = "Frequency",
    y = NULL
  ) +
  theme_minimal()

## -----------------------------------------------------------------------------
# nrc_sentiments <- get_sentiments("nrc")
# 
# word_sentiments <- words |>
#   inner_join(nrc_sentiments, by = "word", relationship = "many-to-many") |>
#   count(sentiment, sort = TRUE)

## -----------------------------------------------------------------------------
# word_sentiments |>
#   mutate(sentiment = reorder(sentiment, n)) |>
#   ggplot(aes(x = n, y = sentiment, fill = sentiment)) +
#   geom_col(show.legend = FALSE) +
#   labs(
#     title = expression(paste(
#       "Sentiment Distribution in ",
#       italic("Persuasion")
#     )),
#     x = "Word Count",
#     y = NULL
#   ) +
#   theme_minimal()

## -----------------------------------------------------------------------------
# nrc_by_chapter <- words |>
#   inner_join(nrc_sentiments, by = "word", relationship = "many-to-many") |>
#   count(chapter, sentiment) |>
#   filter(!is.na(chapter))
# 
# nrc_by_chapter |>
#   filter(sentiment %in% c("joy", "sadness", "anger", "fear")) |>
#   ggplot(aes(x = chapter, y = n, fill = factor(sentiment))) +
#   geom_col(show.legend = FALSE) +
#   facet_wrap(~sentiment, ncol = 2, scales = "free_y") +
#   labs(
#     title = expression(paste("Sentiment by Chapter in ", italic("Persuasion"))),
#     x = "Chapter",
#     y = "Word Count"
#   ) +
#   theme_minimal() +
#   theme(
#     axis.text.x = element_text(angle = 45, hjust = 1),
#     strip.text = element_text(face = "bold")
#   )

## -----------------------------------------------------------------------------
# # Add a running index to preserve order and calculate bins
# words_with_index <- words |>
#   mutate(word_index = row_number()) |>
#   mutate(bin = (word_index - 1) %/% 500 + 1)
# 
# nrc_binned <- words_with_index |>
#   inner_join(nrc_sentiments, by = "word", relationship = "many-to-many") |>
#   count(bin, sentiment)
# 
# # Add labels for chapters
# chapter_breaks <- words |>
#   filter(!is.na(chapter)) |>
#   mutate(word_index = row_number()) |>
#   group_by(chapter) |>
#   slice_min(word_index, n = 1) |>
#   ungroup() |>
#   mutate(
#     bin = (word_index - 1) %/% 500 + 1
#   ) |>
#   filter(chapter %% 2 == 0)
# 
# nrc_binned |>
#   filter(sentiment %in% c("joy", "sadness", "anger", "fear")) |>
#   ggplot(aes(x = bin, y = n, color = sentiment)) +
#   geom_line(linewidth = 1, show.legend = FALSE) +
#   facet_wrap(~sentiment, ncol = 2, scales = "free_y") +
#   scale_x_continuous(
#     name = "Word Bin (500 words)",
#     sec.axis = sec_axis(
#       ~.,
#       breaks = chapter_breaks$bin,
#       labels = chapter_breaks$chapter,
#       name = "Chapter"
#     )
#   ) +
#   labs(
#     title = expression(paste(
#       "Sentiment Progression in ",
#       italic("Persuasion")
#     )),
#     subtitle = "NRC sentiments by word bin with chapter reference",
#     y = "Word Count"
#   ) +
#   theme_minimal()

## -----------------------------------------------------------------------------
chapter_words <- persuasion |>
  unnest_tokens(word, text) |>
  count(chapter, word, sort = TRUE) |>
  bind_tf_idf(word, chapter, n)

# Look at the most "important" words for chapters 10 through 13
chapter_words |>
  filter(chapter %in% 10:13) |>
  group_by(chapter) |>
  slice_max(tf_idf, n = 5) |>
  ungroup() |>
  mutate(word = reorder(word, tf_idf)) |>
  ggplot(aes(tf_idf, word, fill = factor(chapter))) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~chapter, scales = "free") +
  labs(
    title = "Highest TF-IDF words in Chapters 10-13",
    x = "TF-IDF",
    y = NULL
  ) +
  theme_minimal()

