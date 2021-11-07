# Nombres y códigos
library(rio)
library(tidyverse)
library(skimr)

rm(list = ls())

chip = list()
anos = 2017:2020
names = list()

for (a in anos){
  for (file in list.files(paste0('./data/input/', a) , '.xls', full.names = T)){
    # Leo la celda con el nombre y el identificador
    id = import(file, col_names = F, range="A3:A3")
    
    # Guardo el nombre del municipio y el código por separado
    # El [[1]] es solo porque el output está como lista, por lo que extraigo el elemento
    id = str_split(id[[1]], " - ", 2)[[1]]
    # Guardo el resultado en una lista
    names[[id[1]]] = id[2]
    
    # Importo la base de datos
    df = import(file, col_names = T, skip = 9)
    
    # Miro cuantas veces aparece el mismo municiipio para el mismo año
    nombre = paste0(a, '_', id[1])
    ocurrencias_pasadas = length(grep(nombre, names(chip)))
    # Si es distinto de 0 cambio el nombre para no reemplazar los datos de antes
    if (ocurrencias_pasadas != 0){
      nombre = paste0(nombre, "_", ocurrencias_pasadas)
    }
    
    # Agrego df a chip. El nombre es el año y el código identificador
    chip[[nombre]] = df
  }
}


