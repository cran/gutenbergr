% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/gutenberg_download.R
\name{gutenberg_download}
\alias{gutenberg_download}
\title{Download one or more works using a Project Gutenberg ID}
\usage{
gutenberg_download(
  gutenberg_id,
  mirror = NULL,
  strip = TRUE,
  meta_fields = character(),
  verbose = TRUE
)
}
\arguments{
\item{gutenberg_id}{A vector of Project Gutenberg IDs, or a data frame
containing a \code{gutenberg_id} column, such as from the results of
\code{\link[=gutenberg_works]{gutenberg_works()}}.}

\item{mirror}{A mirror URL to retrieve the books from. By default uses the
mirror from \code{\link[=gutenberg_get_mirror]{gutenberg_get_mirror()}}.}

\item{strip}{Whether to strip suspected headers and footers using
\code{\link[=gutenberg_strip]{gutenberg_strip()}}.}

\item{meta_fields}{Additional fields describing each book, such as \code{title}
and \code{author}, to add from \link{gutenberg_metadata}.}

\item{verbose}{Whether to show messages about the Project Gutenberg mirror
that was chosen}
}
\value{
A two column \code{tbl_df} (see \code{\link[tibble:tibble]{tibble::tibble()}}) with one row for each
line of the text or texts, with columns
\describe{
\item{gutenberg_id}{Integer column with the Project Gutenberg ID of
each text}
\item{text}{A character vector of lines of text}
}
}
\description{
Download one or more works by their Project Gutenberg IDs into a data frame
with one row per line per work. This can be used to download a single work of
interest or multiple at a time. You can look up the Gutenberg IDs of a work
using \code{\link[=gutenberg_works]{gutenberg_works()}} or the \link{gutenberg_metadata} dataset.
}
\examples{
\dontshow{if (interactive()) (if (getRversion() >= "3.4") withAutoprint else force)(\{ # examplesIf}
# download The Count of Monte Cristo
gutenberg_download(1184)

# download two books: Wuthering Heights and Jane Eyre
books <- gutenberg_download(c(768, 1260), meta_fields = "title")
books
dplyr::count(books, title)

# download all books from Jane Austen
austen <- gutenberg_works(author == "Austen, Jane") |>
  gutenberg_download(meta_fields = "title")
austen
dplyr::count(austen, title)
\dontshow{\}) # examplesIf}
}
