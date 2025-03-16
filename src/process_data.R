library(dplyr)

input_file <- "data/raw/student_mat.csv"
output_file <- "data/processed/processed_student_mat.csv"

output_dir <- dirname(output_file)
if (!dir.exists(output_dir)) {
  dir.create(output_dir, recursive = TRUE)
}

df <- read.csv(input_file, sep = ";")

df <- df |> 
  mutate(sex = recode(sex, "F" = "Female", "M" = "Male"))

df <- df |> 
  mutate(PrevG = (G1 + G2) / 2)

df_processed <- df |> 
  select(school, sex, age, studytime, failures, PrevG, absences, G3)


write.csv(df_processed, output_file, row.names = FALSE)