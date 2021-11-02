# Nombres y códigos
library(rio)
library(tidyverse)
library(skimr)

chip = list()
anos = 2017:2020
names = list()
for (a in anos){
  i = 0
  for (file in list.files(paste0('./data/input/', a) , '.xls', full.names = T)){
    id = import(file, col_names = F, range="A3:A3")
    
    id = str_split(id[[1]], " - ", 2)[[1]]
    names[[id[1]]] = id[2]
    
    df = import(file, col_names = T, skip = 9)
    chip[[paste0(a, '_', id[1])]] = df
    i = i + 1
  }
}

df = chip[[1]]
skim(df)

a = import("./data/input/2020/21000540045K212410-1220201625674324667.xls", col_names = F, range="A3:A3")
t = a[[1]] %>% strsplit(" - ")
