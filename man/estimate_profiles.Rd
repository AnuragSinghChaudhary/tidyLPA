% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/estimate-profiles.R
\name{estimate_profiles}
\alias{estimate_profiles}
\title{Estimate latent profiles}
\usage{
estimate_profiles(
  df,
  n_profiles,
  models = NULL,
  variances = "equal",
  covariances = "zero",
  package = "mclust",
  select_vars = NULL,
  ...
)
}
\arguments{
\item{df}{data.frame of numeric data; continuous indicators are required for
mixture modeling.}

\item{n_profiles}{Integer vector of the number of profiles (or mixture
components) to be estimated.}

\item{models}{Integer vector. Set to \code{NULL} by default, and models are
constructed from the \code{variances} and \code{covariances} arguments. See
\code{Details} for the six models available in tidyLPA.}

\item{variances}{Character vector. Specifies which variance components to
estimate. Defaults to "equal" (constrain variances across profiles); the
other option is "varying" (estimate variances freely across profiles). Each
element of this vector refers to one of the models you wish to run.}

\item{covariances}{Character vector. Specifies which covariance components to
estimate. Defaults to "zero" (do not estimate covariances; this corresponds
to an assumption of conditional independence of the indicators); other
options are "equal" (estimate covariances between items, constrained across
profiles), and "varying" (free covariances across profiles).}

\item{package}{Character. Which package to use; 'mclust' or
'MplusAutomation' (requires Mplus to be installed). Default: 'mclust'.}

\item{select_vars}{Character. Optional vector of variable names in \code{df},
to be used for model estimation. Defaults to \code{NULL}, which means all
variables in \code{df} are used.}

\item{...}{Additional arguments are passed to the estimating function; i.e.,
\code{\link[mclust]{Mclust}}, or \code{\link[MplusAutomation]{mplusModeler}}.}
}
\value{
A list of class 'tidyLPA'.
}
\description{
Estimates latent profiles (finite mixture models) using the open
source package \code{\link[mclust:Mclust]{mclust}}, or the commercial program
Mplus (using the R-interface of
\code{\link[MplusAutomation:mplusModeler]{MplusAutomation}}).
}
\details{
Six models are currently available in tidyLPA, corresponding to the
most common requirements. These are:
\enumerate{
\item Equal variances and covariances fixed to 0
\item Varying variances and covariances fixed to 0
\item Equal variances and equal covariances
\item Varying variances and equal covariances (not able to be fit w/ mclust)
\item Equal variances and varying covariances (not able to be fit w/ mclust)
\item Varying variances and varying covariances
}

Two interfaces are available to estimate these models; specify their numbers
in the \code{models} argument (e.g., \code{models = 1}, or
\code{models = c(1, 2, 3)}), or specify the variances/covariances to be
estimated (e.g.,: \code{variances = c("equal", "varying"), covariances =
c("zero", "equal")}). Note that when mclust is used, \code{models =
c(1, 2, 3, 6)} are the only models available.
}
\examples{

iris_sample <- iris[c(1:4, 51:54, 101:104), ] # to make example run more quickly

# Example 1:
iris_sample \%>\%
  subset(select = c("Sepal.Length", "Sepal.Width",
    "Petal.Length")) \%>\%
  estimate_profiles(3)

\donttest{
# Example 2:
iris \%>\%
  subset(select = c("Sepal.Length", "Sepal.Width",
    "Petal.Length")) \%>\%
  estimate_profiles(n_profiles = 1:4, models = 1:3)

# Example 3:
iris_sample \%>\%
  subset(select = c("Sepal.Length", "Sepal.Width",
    "Petal.Length")) \%>\%
  estimate_profiles(n_profiles = 1:4, variances = c("equal", "varying"),
                    covariances = c("zero", "zero"))
}

}
