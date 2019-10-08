setwd("/home/agricolamz/for_work/HSE/students/2019_m3_Kazakevich/data/")
library(tidyverse)

lev <- read_csv2("filtered_data_new.csv")

read_tsv("https://raw.githubusercontent.com/sverhees/master_villages/master/data/villages.csv") %>% 
  rename(eng_vil_name = Name) ->
  samira

# merge all multidagestan data --------------------------------------------
read_tsv("multidag_1885.tsv") %>% 
  filter(!str_detect(yid, "C0|Калаки")) %>% 
  mutate(yid = as.integer(yid)) %>% 
  bind_rows(read_tsv("multidag_1895.tsv") %>% 
              filter(!str_detect(yid, "C0|Калаки")) %>% 
              mutate(yid = as.integer(yid))) %>% 
  bind_rows(read_tsv("multidag_1926.tsv") %>% 
              filter(!str_detect(yid, "C0|Калаки")) %>% 
              mutate(yid = as.integer(yid))) %>% 
  bind_rows(read_tsv("multidag_2010.tsv") %>% 
              filter(!str_detect(yid, "C0|Калаки")) %>% 
              mutate(yid = as.integer(yid))) %>% 
  rename(koryakov_bd_id = yid) %>% 
  distinct() ->
  multidagestan
  


# merge with Lev's  and Samira's works ------------------------------------
lev %>% 
  select(koryakov_bd_id, eng_vil_name, rus_vil_name) %>% 
  full_join(multidagestan) %>% 
  rename(rus_vil_name_mdg = name) %>% 
  full_join(samira) %>% 
  write_csv("merged_all_census_and_samira.csv", na = "")
