#POurpose Scrape for Adam


# libraries ---------------------------------------------------------------

library(dplyr)
library(tabulizer)
library(stringr)


# download data -----------------------------------------------------------

download.file("https://collegereadiness.collegeboard.org/pdf/sat-score-reporting-code-list.pdf",
                                  destfile = "sat_2017.pdf")

#download.file("https://collegereadiness.collegeboard.org/pdf/sat-domestic-code-list.pdf",
#              destfile = "sat_2017.pdf")
sat_scores <- "sat_2017.pdf"



columns <- list(col_one = c(1,1, 790, 137), col_2 = c(1,135, 790, 250), col_3 = c(1,255, 770, 360), 
                col_4 =c(1,355, 770, 475),
                last_one = c(1,475, 770, 600))

big_list <- c()
for(i in 2:22){
  tab <- extract_tables(sat_scores, page = c(i,i,i,i,i), area = columns, guess = FALSE, method = "character")
  
  collector <- c()
  for(j in 1:5){
    to_inspect <-gsub(tab[[j]], pattern = "\\n|\\t", replacement = " ")
    to_inspect_b <-gsub(to_inspect, pattern = "^[A-z]+", replacement = " ")
    to_inspect_c <-gsub(to_inspect_b, pattern = "^\\s+", replacement = "")
    message(paste0("Sheet", j ,"of", i, sep = " "))
    numbers <- t(str_extract_all(pattern = "[0-9]{4}", string = to_inspect_b, simplify = TRUE))
    #school <-t(str_extract_all(pattern = "[^0-9]+", string = to_inspect_c, simplify = TRUE))
    school <-str_trim(str_split(to_inspect_c, pattern = "[0-9]{4}")[[1]][-1])
    output_df <- cbind(numbers = numbers, school = school)%>% as_data_frame()
    names(output_df) <- c("number", "school")
    collector <- rbind(collector, output_df)
  }
  big_list[[i-1]] <- collector
}


total_out <- bind_rows(big_list)

total_out <- total_out %>% 
  mutate(number = as.numeric(number))

head(total_out)

library(readr)
write_csv(total_out, "colleges_with_college_board_number.csv")
