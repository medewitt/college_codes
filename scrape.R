#POurpose Scrape for Adam


# libraries ---------------------------------------------------------------

library(dplyr)
library(tabulizer)


# download data -----------------------------------------------------------

download.file("https://collegereadiness.collegeboard.org/pdf/sat-score-reporting-code-list.pdf",
                                  destfile = "sat_2017.pdf")

download.file("https://collegereadiness.collegeboard.org/pdf/sat-domestic-code-list.pdf",
              destfile = "sat_2017.pdf")
sat_scores <- "sat_2017.pdf"

#Get pages 19-28

tab <- extract_tables(sat_scores, page = 4)

a<-tab[1] %>% as.data.frame()
locate_areas(sat_scores))
get_page_dims(sat_scores, pages = 2)
