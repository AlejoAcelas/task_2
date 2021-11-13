# Nombres y códigos
library(rio)
library(tidyverse)
library(skimr)

rm(list = ls())

chip = list()
anos = 2017:2020
names = list()

################
#   PUNTO 1    #
################

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

  

################
#   PUNTO 2    #PROPUESTA
################

rm(list=ls())
require(pacman)
p_load(rio,tidyverse)

# punto 1
paths = lapply(2017:2020 , function(x) list.files(paste0("./data/input/",x),full.names=T)) %>%
  unlist()

list_chip = list()
for (i in 1:length(paths)){
  list_chip[[i]] = import(file = paths[i])  
}

pago_educ = function(n,lista,tipo_rubro){
  lista_n = lista[[n]] 
  colnames(lista_n) = lista_n[7,]
  valor = lista_n %>% subset(NOMBRE==tipo_rubro) %>% select(`PAGOS(Pesos)`)
  return(valor)  
}

pago_educ = function(n,lista,tipo_rubro){
  
  # crear df
  df = data.frame(valor=NA,cod_dane=NA,periodo=NA)  
  lista_n = lista[[n]] 
  
  # extraer codigo dane
  df$cod_dane = colnames(lista_n)[1]
  
  # extraer periodo
  df$periodo = lista_n[2,1]
  
  # extraer el valor
  colnames(lista_n) = lista_n[7,]
  df$valor = lista_n %>% subset(NOMBRE==tipo_rubro) %>% select(`PAGOS(Pesos)`)
  
  return(df)  
}

pago_educ(n = 10 , lista = list_chip , tipo_rubro = "EDUCACIÓN")





pago_educacion = function(df){
  pago = df %>% filter(CODIGO == "A.1") %>% select("PAGOS(Pesos)")
  pago = gsub(",", ".", pago)
  print(pago)
  return(pago %>% as.double())
}

################
#   PUNTO 3    #PROPUESTA
################

pagos = lapply(chip, pago_educacion)

# Hay un outlier
Pagos_Educacion = unlist(pagos)
hist(Pagos_Educacion)


