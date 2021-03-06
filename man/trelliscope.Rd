% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/trelliscope.R
\name{trelliscope}
\alias{trelliscope}
\title{Create a Trelliscope Display}
\usage{
trelliscope(x, name, group = "common", panel_col = NULL, desc = "",
  md_desc = "", path, height = 500, width = 500, auto_cog = FALSE,
  state = NULL, nrow = 1, ncol = 1, jsonp = TRUE,
  self_contained = FALSE, thumb = FALSE)
}
\arguments{
\item{x}{an object to create at trelliscope display for}

\item{name}{name of the display}

\item{group}{group that the display belongs to}

\item{panel_col}{optional string specifying the column to use for panels (if there are multiple plot columns in \code{x})}

\item{desc}{optional text description of the display}

\item{md_desc}{optional string of markdown that will be shown in the viewer for additional context about the display}

\item{path}{the base directory of the trelliscope application}

\item{height}{height in pixels of each panel}

\item{width}{width in pixels of each panel}

\item{auto_cog}{should auto cogs be computed (if possible)?}

\item{state}{the initial state the display will open in}

\item{nrow}{the number of rows of panels to display by default}

\item{ncol}{the number of columns of panels to display by default}

\item{jsonp}{should json for display object be jsonp (TRUE) or json (FALSE)?}

\item{self_contained}{should the Trelliscope display be a self-contained html document? (see note)}

\item{thumb}{should a thumbnail be created?}
}
\description{
Create a Trelliscope Display
}
\note{
Note that \code{self_contained} is severely limiting and should only be used in cases where you would either like your display to show up in the RStudio viewer pane, in an interactive R Markdown Notebook, or in a self-contained R Markdown html document.
}
\examples{
\donttest{
library(dplyr)
library(tidyr)
library(purrr)
library(rbokeh)
library(ggplot2)

# tidyverse + rbokeh
d <- mpg \%>\%
  group_by(manufacturer, class) \%>\%
  nest() \%>\%
  mutate(
    mean_city_mpg = map_dbl(data, ~ mean(.$cty)),
    panel = map_plot(data, ~
      figure(., xlab = "City mpg", ylab = "Highway mpg") \%>\%
        ly_points(cty, hwy))
  )

d \%>\% trelliscope(name = "city_vs_highway_mpg")

# if you want to use in RStudio Viewer or RMarkdown Notebook, use self_containedd
# (this will hopefully change, and you should avoid self_contained whenever possible)
d \%>\% trelliscope(name = "city_vs_highway_mpg", self_contained = TRUE)

# set default layout
d \%>\% trelliscope(name = "city_vs_highway_mpg", nrow = 2, ncol = 3)

# set the output path for where files will be stored
my_displays <- tempfile()
d \%>\% trelliscope(name = "city_vs_highway_mpg", path = my_displays)

# multiple displays can be added to the same path and all will be available in the viewer
d \%>\% trelliscope(name = "city_vs_highway_mpg2", path = my_displays)

# ordering the data frame will set default sort order of the display
d \%>\%
  arrange(-mean_city_mpg) \%>\%
  trelliscope(name = "city_vs_highway_mpg")

# tidyverse + ggplot2
mpg \%>\%
  group_by(manufacturer, class) \%>\%
  nest() \%>\%
  mutate(
    panel = map_plot(data, ~
      qplot(cty, hwy, data = .) + xlab("cty") + ylab("hwy") +
        xlim(7, 37) + ylim(9, 47) + theme_bw())) \%>\%
  trelliscope(name = "tidy_gg")

# computing additional cognostics
mpg_cog <- mpg \%>\%
  group_by(manufacturer, class) \%>\%
  nest() \%>\%
  mutate(
    cogs = map_cog(data, ~ data_frame(
      mean_city_mpg = mean(.$cty),
      mean_hwy_mpg = mean(.$hwy),
      most_common_drv = tail(names(table(.$drv)), 1)
    )),
    panel = map_plot(data, ~
      figure(., xlab = "City mpg", ylab = "Highway mpg",
        xlim = c(9, 47), ylim = c(7, 37)) \%>\%
        ly_points(cty, hwy,
          hover = list(year, model))
    )
  )

mpg_cog \%>\%
  trelliscope(name = "city_vs_highway_mpg", nrow = 1, ncol = 2)

# computing additional cognostics explicitly using cog()
# so we can specify descriptions, etc.
mpg_cog2 <- mpg \%>\%
  group_by(manufacturer, class) \%>\%
  nest() \%>\%
  mutate(
    cogs = map_cog(data, ~ data_frame(
      mean_city_mpg = cog(mean(.$cty), desc = "Mean city mpg"),
      mean_hwy_mpg = cog(mean(.$hwy), desc = "Mean highway mpg"),
      most_common_drv = cog(tail(names(table(.$drv)), 1), desc = "Most common drive type")
    )),
    panel = map_plot(data, ~
      figure(., xlab = "City mpg", ylab = "Highway mpg",
        xlim = c(9, 47), ylim = c(7, 37)) \%>\%
        ly_points(cty, hwy,
          hover = list(year, model))
    )
  )

mpg_cog2 \%>\%
  trelliscope(name = "city_vs_highway_mpg", nrow = 1, ncol = 2)
}
}
