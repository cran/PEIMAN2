## ---- include = FALSE---------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----show data1,echo=FALSE, results='asis', booktabs = TRUE-------------------
knitr::kable( head(PEIMAN2::exmplData1$pl1), col.names = '', caption = '')
knitr::kable( head(PEIMAN2::exmplData1$pl2), col.names = '', caption = '')

## ----show data2,echo=FALSE, results='asis'------------------------------------
knitr::kable(PEIMAN2::exmplData2[1:6,], caption='beatAML dataset samples')

## -----------------------------------------------------------------------------
# Load PEIMAN2 package
library(PEIMAN2)

# Extract dataset and assign a variable name to it
pl1 <- exmplData1$pl1

# Run SEA on the list
enrich1 <- runEnrichment(protein = pl1, os.name = 'Homo sapiens (Human)')

## ----echo = FALSE-------------------------------------------------------------
knitr::kable( head(enrich1), format = 'html')

## -----------------------------------------------------------------------------
getTaxonomyName(x = exmplData1$pl1)

## -----------------------------------------------------------------------------
# Extract dataset and assign a variable name to it
pl2 <- exmplData1$pl2

# Run SEA on the list
enrich2 <- runEnrichment(protein = pl2, os.name = 'Homo sapiens (Human)')

## ----echo = FALSE-------------------------------------------------------------
knitr::kable( head(enrich2), format = 'html')

## ----fig.dim = c(8, 6)--------------------------------------------------------
plotEnrichment(x = enrich1, sig.level = 0.05)

## ----fig.dim = c(8,6)---------------------------------------------------------
plotEnrichment(x = enrich1, y = enrich2, sig.level = 0.05)

## -----------------------------------------------------------------------------
psea_res <- runPSEA(protein = exmplData2, os.name = 'Rattus norvegicus (Rat)', nperm = 1000)

## -----------------------------------------------------------------------------
knitr::kable(psea_res[[1]], format = 'html')

## ----fig.width=14, fig.height=12, fig.align='center'--------------------------
plotPSEA(x = psea_res)

## ----echo = FALSE, fig.width=12, fig.height=12--------------------------------
plotRunningScore(x = psea_res)

## -----------------------------------------------------------------------------
MS <- psea2mass(x = psea_res, sig.level = 0.05)
MS

