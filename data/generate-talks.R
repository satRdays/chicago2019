# Run me to generate all talk descriptions in data/projects
# Input data: data export from Sessionize, see "Export" button, then take 
# "Accepted Speakers" tab from that Excel Sheet export

library(tidyverse)
library(janitor)
library(glue)

speakers <- read_csv("data/speakers-export.csv")
speakers <- speakers %>%
  clean_names() %>%
  mutate(id = str_pad(row_number(), 2, pad = "0"),
         name = paste(first_name, last_name),
         headshot_name = paste(first_name, last_name, sep = "_"),
         link = case_when(!is.na(blog) ~ blog,
                          is.na(blog) & !is.na(twitter) ~ twitter,
                          is.na(blog) & is.na(twitter) ~ linked_in))

speakers <- speakers %>% 
  mutate(yaml_description = 
            glue("modalID: {id}
            title: {name}
            subtitle: {tag_line}
            date: 1970-01-01
            startsAt: 00:00
            endsAt: 00:01
            img: roundicons.png
            preview: {headshot_name}.jpg
            client: {tag_line}
            clientLink: {link}
            category: Speaker
            description: {bio}
            talk: true"))

for (i in 1:nrow(speakers)) {
  yaml_description <- speakers[["yaml_description"]][i]
  write(yaml_description, file = paste0("data/projects/Talk", speakers[["id"]][i], ".yaml"))
}
      