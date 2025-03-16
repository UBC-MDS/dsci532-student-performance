packages <- c("dplyr", "ggplot2", "tidyr", "shiny")

install_if_missing <- function(pkg) {
  if (!requireNamespace(pkg, quietly = TRUE)) {
    install.packages(pkg, dependencies = TRUE)
  }
}

invisible(sapply(packages, install_if_missing))