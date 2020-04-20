# FUROSEMIDE
# PREDNISONE

library("openfda")
#* @get /outcomes
#* @param drug:character Drug name
newGetOutcomes <- function(drug){
  myresults <- fda_query("/drug/event.json") %>%
    fda_filter("patient.drug.openfda.generic_name.exact", drug) %>%
    fda_filter("patient.drug.drugindication.exact", "%22SYSTEMIC+LUPUS+ERYTHEMATOSUS%22") %>%
    fda_count("patient.reaction.reactionmeddrapt.exact") %>%
    fda_limit(10) %>%
    fda_exec()
  return(myresults)
}

