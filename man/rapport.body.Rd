\name{rapport.body}
\alias{rapport.body}
\alias{tpl.body}
\title{Template Body}
\usage{
rapport.body(fp, htag = get.tags("header.close"), ...)
}
\arguments{
  \item{fp}{a template file pointer (see
  \code{rapport:::rapport.read} for details)}

  \item{htag}{a string with closing body tag}

  \item{...}{additional arguments to be passed to
  \code{\link{grep}} function}
}
\value{
a character vector with template body contents
}
\description{
Returns contents of the template body.
}

