# Version R 4.1.1
# Elaborado por: Angelica Alvarez(201921780), Sebastian Marin (201814126) y Alejandro Acelas (201819695)


if(!require(pacman)) install.packages("pacman") ; require(pacman)
p_load(rio, tidyverse, skimr)
rm(list = ls())

################
#   PUNTO 1    #
################

# punto 1
paths = lapply(2017:2020 , function(x) list.files(paste0("./data/input/",x),full.names=T)) %>%
  unlist()

chip = list()
for (i in 1:length(paths)){
  chip[[i]] = import(file = paths[i])  
}


################
#   PUNTO 2    #
################

pago_educ = function(lista_n,tipo_rubro){
  
  # crear df
  df = data.frame(valor=NA,cod_dane=NA,periodo=NA)  
  
  # extraer codigo dane
  df$cod_dane = colnames(lista_n)[1]
  
  # extraer periodo
  df$periodo = lista_n[2,1]
  
  # extraer el valor
  colnames(lista_n) = lista_n[7,]
  df$valor = lista_n %>% subset(NOMBRE==tipo_rubro) %>% select(`PAGOS(Pesos)`)
  
  return(df)  
}


################
#   PUNTO 3    #
################

pagos = lapply(chip, pago_educ, tipo_rubro="EDUCACIÓN")






