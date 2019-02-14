
<!-- README.md is generated from README.Rmd. Please edit that file -->
[![Build Status](https://travis-ci.org/jrosen48/tidyLPA.svg?branch=master)](https://travis-ci.org/jrosen48/tidyLPA) [![DOI](http://joss.theoj.org/papers/10.21105/joss.00978/status.svg)](https://doi.org/10.21105/joss.00978)

Update: Major (exciting - but breaking!) changes are introduced in the development (0.3.0) version of tidyLPA
-------------------------------------------------------------------------------------------------------------

Please note that in the development (the version on GitHub here; 1.0.0) version of **tidyLPA** introduces major (exciting - but breaking!) version. Please do not hesitate to reach out with any questions or issues that you encounter.

You can read about some of the major changes [here](https://jrosen48.github.io/tidyLPA/articles/introduction-to-major-changes.html).

Note that the version presently on CRAN (0.2.4) does not represent the new changes yet, though these changes will be made soon. Thus the old version can be downloaded from CRAN or can be downloaded with the following function:

``` r
devtools::install_github("jrosen48/tidyLPA", ref = "ab36357")
```

Background
----------

Latent Profile Analysis (LPA) is a statistical modeling approach for estimating distinct profiles, or groups, of variables. In the social sciences and in educational research, these profiles could represent, for example, how different youth experience dimensions of being engaged (i.e., cognitively, behaviorally, and affectively) at the same time.

tidyLPA provides the functionality to carry out LPA in R. In particular, tidyLPA provides functionality to specify different models that determine whether and how different parameters (i.e., means, variances, and covariances) are estimated and to specify (and compare solutions for) the number of profiles to estimate. The package is designed and documented to be easy to use, especially for beginners to LPA, but with fine-grained options available for estimating models and evaluating specific output as part of more complex analyses.

Installation
------------

You can install tidyLPA from CRAN with:

``` r
install.packages("tidyLPA")
```

You can also install the development version of tidyLPA from GitHub with:

``` r
install.packages("devtools")
devtools::install_github("jrosen48/tidyLPA")
```

Example
-------

### Mclust

Here is a brief example using the built-in `pisaUSA15` data set and variables for broad interest, enjoyment, and self-efficacy. Note that we first type the name of the data frame, followed by the unquoted names of the variables used to create the profiles. We also specify the number of profiles and the model. See `?estimate_profiles` for more details.

In these examples, we pass the results of one function to the next by *piping* (using the `%>%` operator, loaded from the `dplyr` package). We pass the data to a function that selects relevant variables, and then to `estimate_profiles`:

``` r
library(tidyLPA)
library(tidyverse)
#> Warning: package 'tibble' was built under R version 3.5.2
#> Warning: package 'purrr' was built under R version 3.5.2
#> Warning: package 'stringr' was built under R version 3.5.2
```

``` r
pisaUSA15[1:100, ] %>%
    select(broad_interest, enjoyment, self_efficacy) %>%
    single_imputation() %>%
    estimate_profiles(3)
#> tidyLPA analysis using mclust: 
#> 
#>  Model Classes AIC     BIC     Entropy prob_min prob_max n_min n_max
#>  1     3       639.310 675.783 0.791   0.901    0.956    0.030 0.630
#>  BLRT_p
#>  0.020
```

### Mplus

We can use Mplus simply by changing the package argument for `estimate_profiles()`:

``` r
pisaUSA15[1:100, ] %>%
    select(broad_interest, enjoyment, self_efficacy) %>%
    single_imputation() %>%
    estimate_profiles(3, package = "MplusAutomation")
#> tidyLPA analysis using mplus: 
#> 
#>  Model Classes AIC     BIC     Entropy prob_min prob_max n_min n_max
#>  1     3       642.354 678.826 0.812   0.874    0.944    0.030 0.650
#>  BLRT_p
#>  0.000
```

A simple summary of the analysis is printed to the console (and its posterior probability). The resulting object can be further passed down a pipeline to other functions, such as `plot`, `compare_solutions`, `get_data`, `get_fit`, etc. This is the "tidy" part, in that the function can be embedded in a tidy analysis pipeline.

If you have Mplus installed, you can call the version of this function that uses MPlus in the same way, by adding the argument `package = "MplusAutomation`.

We can plot the profiles by piping the output to `plot_profiles()`.

``` r
pisaUSA15[1:100, ] %>%
    select(broad_interest, enjoyment, self_efficacy) %>%
    single_imputation() %>%
    scale() %>%
    estimate_profiles(3, package = "MplusAutomation") %>% 
    plot_profiles()
```

![](man/figures/README-unnamed-chunk-7-1.png)

Model specification
-------------------

In addition to the number of profiles (specified with the `n_profiles` argument), the model can be specified in terms of whether and how the variable variances and covariances are estimated.

The models are specified by passing arguments to the `variance` and `covariance` arguments. The possible values for these arguments are:

-   `variances`: "equal" and "zero"
-   `covariances`: "varying", "equal", and "zero"

If no values are specified for these, then the variances are constrained to be equal across classes, and covariances are fixed to 0 (conditional independence of the indicators).

These arguments allow for four models to be specified:

-   Equal variances and covariances fixed to 0 (Model 1)
-   Varying variances and covariances fixed to 0 (Model 2)
-   Equal variances and equal covariances (Model 3)
-   Varying variances and varying covariances (Model 6)

Two additional models (Models 4 and 5) can be fit using MPlus. More information on the models can be found in the [vignette](https://jrosen48.github.io/tidyLPA/articles/Introduction_to_tidyLPA.html).

Here is an example of specifying a model with varying variances and covariances (Model 6; not run here):

``` r
pisaUSA15[1:100, ] %>%
    select(broad_interest, enjoyment, self_efficacy) %>%
    single_imputation() %>%
    estimate_profiles(3, 
                      variances = "varying",
                      covariances = "varying")
```

Comparing a wide range of solutions
-----------------------------------

The function `compare_solutions()` compares the fit of several estimated models, with varying numbers of profiles and model specifications:

``` r
pisaUSA15[1:100, ] %>%
    select(broad_interest, enjoyment, self_efficacy) %>%
    single_imputation() %>%
    estimate_profiles(1:3, 
                      variances = c("equal", "varying"),
                      covariances = c("zero", "varying")) %>%
    compare_solutions(statistics = c("AIC", "BIC"))
```

More information
----------------

To learn more:

-   Browse the tidyLPA [website](https://jrosen48.github.io/tidyLPA/) (especially check out the Reference page to see more about other functions)

-   *Read the Introduction to tidyLPA* [vignette](https://jrosen48.github.io/tidyLPA/articles/Introduction_to_tidyLPA.html), which has much more information on the models that can be specified with tidyLPA and on additional functionality

Contributing and Contact Information
------------------------------------

One of the easiest but also most important ways to contribute is to post a question or to provide feedback. Both positive *and* negative feedback is welcome and helpful. You can get in touch by . . .

-   Sending a message via <tidylpa@googlegroups.com> or view the [the tidyLPA group page](https://groups.google.com/forum/#!forum/tidylpa) (*preferred*)
-   Filing an issue on GitHub [here](https://github.com/jrosen48/tidyLPA)

Contributions are also welcome via by making pull requests (PR), e.g. through [this page on GitHub](https://github.com/jrosen48/tidyLPA/pulls). It may be easier if you first file an issue outlining what you will do in the PR. You can also reach out via the methods described above.

Please note that this project is released with a [Contributor Code of Conduct](CONDUCT.md). By participating in this project you agree to abide by its terms.
