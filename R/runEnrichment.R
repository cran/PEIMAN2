#' Run singular enrichment analysis (SEA) for a given list of protein
#'
#' @description This function takes proteins with their UniProt accession code,
#'   runs singular enrichment (SEA) analysis, and returns enrichment results.
#'
#' @param protein A character vector with protein UniProt accession codes.
#' @param os.name A character vector of length one with exact taxonomy name of
#'   species. If you do not know the the exact taxonomy name of species you are
#'   working with, please read \code{\link{getTaxonomyName}}.
#' @param blist The background list will be substituted with the complete set of
#'   UniProt reviewed proteins to facilitate the analysis with a background
#'   list. The default value is NULL. Alternatively, if a vector of UniProt
#'   Accession Codes is provided, it will serve as the background list for the
#'   enrichment analysis.
#' @param p.adj.method The adjustment method to correct for multiple testing.
#'   The default value is 'BH'. Run/see \code{\link[stats]{p.adjust.methods}} to
#'   get a list of possible methods.
#'
#' @return The result is a dataframe with the following columns:
#' - PTM: Post-translational modification (PTM) keyword
#' - FreqinUniprot: The total number of proteins in UniProt with this PTM.
#' - FreqinList: The total number of proteins in the given list with this PTM.
#' - Sample: Number of proteins in the given list.
#' - Population: Total number of proteins in the current version of PEIMAN database with this PTM.
#' - pvalue: The p-value obtained from hypergeometric test (enrichment analysis).
#' - corrected pvalue: Adjusted p-value to correct for multiple testing.
#' - AC: Uniprot accession code (AC) of proteins with each PTM.
#'
#' @export
#'
#' @examples
#' enrich1 <- runEnrichment(protein = exmplData1$pl1, os.name = 'Homo sapiens (Human)')
runEnrichment = function(protein, os.name, blist = NULL, p.adj.method = 'BH'){

  #####################################
  # Step 1: Check the input arguments #
  #####################################

  stopifnot( class(p.adj.method)== 'character' )

  stopifnot( p.adj.method %in% c('holm', 'hochberg', 'hommel', 'bonferroni', 'BH', 'BY', 'fdr', 'none') )


  if( !is.vector(protein) | !is.character(protein) ){
    stop('protein muse be a character vector.')
  }


  if( sum(protein %in% peiman_database$AC) == 0 ){
    stop('None of the input proteins are in current version of PEIMAN databse. \n Updating to the latest version of package might help.')
  }


  if( !is.null(blist) ){
     if( !is.vector(blist) | !is.character(blist) ){
       stop('blist must be a character vector.')
     }
  }


  # Set the flag variable to TRUE if there is any duplicated protein in the list
  flag_duplicate <- ifelse( any( duplicated(protein) ), TRUE, FALSE)

  if( flag_duplicate ){
    protein <- protein[!duplicated(protein)]
    message('Duplicate proteins found in the list and were automatically removed.')
  }

  # Filter to proteins for os.name and check the result
  if( nrow( peiman_database %>% filter(OS == os.name) %>% filter( AC %in% protein ) ) == 0 ){
     msg <- 'None of the proteins found in the current version of database or the OS name is wrong?'
     msg <- paste0(msg, ' You can call getTaxonomyName function in PEIMAN2 package to get the exact name of OS.' )
     msg <- paste0(msg, '  Or look up the name in https://www.uniprot.org/')
     stop(msg)
  }


  ##############################################################################
  # Step2. Call peiman function to run singular enrichment analysis (SEA)
  ##############################################################################

  if( is.null(blist) ){
    res <- peiman(pro = protein, os = os.name, background = NULL, am = p.adj.method)
  }else{
    res <- peiman(pro = protein, os = os.name, background = blist, am = p.adj.method)
  }

  if( length(res[[2]]) ){
    message('We did not find the following proteins in the current version of database:')
    message( as.character(res[[2]]) )
    message('(Therefore they were excluded from final analysis.)')
  }

  return(res[[1]])

}
