\name{inputs-deprecated}
\alias{inputs-deprecated}
\title{Deprecated Input Definition}
\description{
As of version \code{0.5}, \code{rapport} relies on YAML
syntax to define inputs. The following sections describe
deprecated input definition syntax.
}
\details{
\strong{Input Specifications}

Apart from \emph{template metadata}, header also requires
specification for template \emph{inputs}. In most cases,
\emph{inputs} refer to variable names in provided dataset,
but some inputs have special meaning inside \code{rapport},
and some of them don't have anything to do with provided
dataset whatsoever. Most inputs can contain limit
specification, and some inputs can also have a default
value. At first we'll explain input specifications on the
fly, and in following sections we'll discuss each part in
thorough details. Let's start with a single dummy input
specification:

\code{*foo.bar | numeric[1,6] | Numeric variable | A set of
up to 6 numeric variables}

\strong{Required Inputs}

Asterisk sign (\code{*}) in front of an input name
indicates a mandatory input. So it is possible to omit
input (unless it's required, of course), but you may want
to use this feature carefully, as you may end up with ugly
output. If an input isn't mandatory,\code{NULL}is assigned
to provided input name, and the object is stored in
transient evaluation environment.

\strong{Input Name}

\emph{rapport} has its own naming conventions which are
compatible, but different from traditional \strong{R}
naming conventions. Input name ("foo.bar" in previous
example) must start with an alphabet letter, followed
either by other alphabet letters or numbers, separated with
\code{_} or \code{.}. For example, valid names are:
\code{foo.bar}, \code{f00_bar}, or \code{Fo0_bar.input}.
Input name length is limited on 30 characters by default.
At any time you can check your desired input name with
\code{check.name} function. Note that input names are
case-sensitive, just like \code{symbol}s in \strong{R}.

\strong{Input Type}

\emph{Input type} is specified in the second input block.
It is the most (read: "only") complex field in an input
specification. It consists of \emph{type specification},
\emph{limit specification} and sometimes a \emph{default
value specification}. Most input types are compatible with
eponymous \strong{R} modes: \emph{character},
\emph{complex}, \emph{logical}, \emph{numeric}, or
\strong{R} classes like \emph{factor}. Some are used as
"wildcards", like \emph{variable}, and some do not refer to
dataset variables at all: \emph{boolean}, \emph{number},
\emph{string} and \emph{option}. Here we'll discuss each
input type thoroughly. We will use term \emph{variable} to
denote a vector taken from a dataset (for more details see
documentation for \code{is.variable}). All inputs can be
divided into two groups, depending on whether they require
a dataset or not:

\itemize{ \item \strong{dataset inputs}: \itemize{ \item
\emph{character} - matches a character variable \item
\emph{complex} - matches a character variable \item
\emph{numeric} - matches a numeric variable \item
\emph{factor} - matches a factor variable (i.e. R object of
\code{factor} class) \item \emph{variable} - matches any
variable of previously defined types } \item
\strong{standalone inputs}: \itemize{ \item \emph{string} -
accepts an atomic character vector \item \emph{number} -
accepts an atomic numeric vector \item \emph{boolean} -
accepts a logical value \item \emph{option} - accepts a
comma-separated list of values, that are to be matched with
\code{\link{match.arg}}. The first value in a list is the
default one.  } }

Now we'll make a little digression and talk about
\strong{input limits}. You may have noticed some additional
stuff in type specification, e.g. \code{numeric[1,6]}. All
dataset inputs, as well as *string* and *numeric standalone
inputs* can contain \emph{limit specifications}. If you
want to bundle several variables from dataset or provide a
vector with several string/numeric values, you can apply
some rules within square brackets in \code{[a,b]} format,
where \code{[a,b]} stands for "from \code{a} to \code{b}
inputs", e.g. \code{[1,6]} means "from 1 to 6 inputs".
Limit specifications can be left out, but even in that case
implicit limit rules are applied - for variables, as well
as boolean and option inputs it's \code{[1,1]}, for strings
\code{[1,256]} and for number inputs \code{[-Inf,Inf]}.

\strong{Dataset inputs} will match one or more variables
from a dataset, and check its mode and/or class.
\code{variable} type is a bit different, since it matches
any kind of variable (not to confuse with \code{Any} type),
but it still refers to variable(s) from a provided dataset.
Dataset inputs cannot have default value, but can be
optional (just leave out \code{*} sign in front of input
name). Note that if you provide more than one variable name
in \code{rapport} function call, that input will be stored
as a \code{data.frame}, otherwise, it will be stored as a
\emph{variable} (atomic vector).

\strong{Standalone inputs} are a bit different since they
do not refer to any variables from a dataset. However, they
are more complex than *dataset inputs*, especially because
they can contain default values. \itemize{ \item
\strong{number} and \strong{string} inputs are defined with
\code{number} and \code{string} respectively. They can also
contain limit specifications, but the limits are treated in
a slightly different manner. \code{number[-2.58,3]} will
match any number within an interval from -2.58 to 3. If the
limit specification is ommited, an implicit ones are
assigned (\code{[-Inf,Inf]}. Limit specifications for
string inputs define the range of characters that provided
string can have, e.g. \code{string[1,6]} matches the string
with at least 1 and at most 6 characters. If ommited, limit
specifications for strings are implicitly set to
\code{[1,256]}. \emph{number} and \emph{string} inputs can
have \emph{default value}, which can be defined by placing
\code{=} after type/limit specification followed by default
value. For instance, \code{number[1,6]=3.14} sets value
\code{3.14} as default. Note that for number inputs an
additional check will be applied to ensure that provided
default number belongs to an interval defined in the limit
specification (\code{[1,6]=7} will throw an error). For
string inputs, the default value \code{string=foo} sets
"foo" as default string value (note that you don't have to
specify quotes unless they are the part of the default
string). Default value will be checked to ensure that its
length falls within the interval provided in the limit
specification.  \item \strong{boolean} inputs can contain
either \code{TRUE} or \code{FALSE} values. The specified
value is the default one. They cannot contain limit
specification, but implicitly the limits are set to
\code{[1,1]}.  \item \strong{option} inputs are nothing
more than a comma-separated list of strings. Even if you
specify numbers in a list, they will be coerced to strings
once the list is parsed. Values in \emph{option} list will
be placed in a character vector, and matched with
\code{match.arg} function. That means that you could only
choose one value from a list. Partial matches are allowed,
and the first value in \emph{option} list is the default
one. Just like in \code{boolean} inputs, limits are
implicitly set to \code{[1,1]}. }

\strong{Input Label and Description}

Third block in input definition is an input label. While
\emph{variable} can have its own label (see \code{label}),
you may want to use the one defined in input
specifications. At last, fourth block contains input
description, which should be a lengthy description of
current input. Note that all the fields in input
specification are mandatory. You can cheat, though, by
providing a non-space character (e.g. a dot) as an input
label and/or description, but please don't do that unless
you're testing the template. Labels and descriptions are
meant to be informative.
}

