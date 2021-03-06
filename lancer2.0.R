library(rvest)
library(dplyr)

#WEBSCRAPING
link <- "https://lista.mercadolivre.com.br/lancer-evolution#D[A:lancer%20evolution]"
page <- read_html(link)

nome_carros <- page %>% html_nodes(".ui-search-item__title") %>% html_text()
pre�o <- page %>% html_nodes(".ui-search-item__group__element .price-tag-fraction") %>% html_text()
ano <- page %>% html_nodes(".ui-search-card-attributes__attribute:nth-child(1)") %>% html_text()
km <- page %>% html_nodes(".ui-search-card-attributes__attribute+ .ui-search-card-attributes__attribute") %>% html_text()

#CRIANDO DATAFRAME
df_carro <- data.frame(nome_carros, pre�o, ano, km)
cat("Foram encontrados", length(df_carro$nome_carros),"carros\n")



#CRIANDO CILINDRADAS E MODELO USANDO OS DADOS DE NOMES:
library(stringr)

#CILINDRADAS
df_carro$cilindradas <- str_extract(df_carro$nome_carros, "[0-9]\\.[0-9]")
df_carro$cilindradas <- as.factor(df_carro$cilindradas)
df_carro$nome_carros <- str_remove(df_carro$nome_carros, "[0-9]\\.[0-9]")

#MODELO
df_carro$modelo <- str_extract(df_carro$nome_carros, "John Easton")

for (i in 1:length(df_carro$modelo)){
  if (is.na(df_carro$modelo[i] == TRUE)){
    df_carro$modelo[i] <- "Padr�o"
  }
}

df_carro$nome_carros <- str_remove(df_carro$nome_carros, "John Easton")


#ARRUMANDO VALORES:
#KM
df_carro$km <- str_remove(df_carro$km, "[:alpha:]")
df_carro$km <- str_remove(df_carro$km, "[:alpha:]")
df_carro$km <- str_remove(df_carro$km, "[:punct:]")

#PRE�O
df_carro$pre�o <- str_remove(df_carro$pre�o, "[:punct:]")



#ARRUMANDO TIPO DAS VARIAVEIS:
#KM
df_carro$km <- as.numeric(df_carro$km)

#PRE�O
df_carro$pre�o <- as.numeric(df_carro$pre�o)



#MOSTRANDO RESULTADOS:
#PRE�O
menor_pre�o <- min(df_carro$pre�o)
cat("O menor pre�o � -> R$",menor_pre�o,"\n")
#KM
menor_km <- min(df_carro$km)
cat("A menor quilometragem � ->", menor_km, "KM\n")




#SALVANDO RESULTADOS EM EXCEL
library(xlsx)
write.xlsx(df_carro, file = "LancerMercadoLivre.xlsx")
getwd()



#HISTOGRAMA
hist(df_carro$pre�o)