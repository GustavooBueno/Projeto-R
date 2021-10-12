library(rvest)
library(dplyr)

#WEBSCRAPING
link <- "https://lista.mercadolivre.com.br/lancer-evolution#D[A:lancer%20evolution]"
page <- read_html(link)

nome_carros <- page %>% html_nodes(".ui-search-item__title") %>% html_text()
preço <- page %>% html_nodes(".ui-search-item__group__element .price-tag-fraction") %>% html_text()
ano <- page %>% html_nodes(".ui-search-card-attributes__attribute:nth-child(1)") %>% html_text()
km <- page %>% html_nodes(".ui-search-card-attributes__attribute+ .ui-search-card-attributes__attribute") %>% html_text()

#CRIANDO DATAFRAME
df_carro <- data.frame(nome_carros, preço, ano, km)
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
    df_carro$modelo[i] <- "Padrão"
  }
}

df_carro$nome_carros <- str_remove(df_carro$nome_carros, "John Easton")


#ARRUMANDO VALORES:
#KM
df_carro$km <- str_remove(df_carro$km, "[:alpha:]")
df_carro$km <- str_remove(df_carro$km, "[:alpha:]")
df_carro$km <- str_remove(df_carro$km, "[:punct:]")

#PREÇO
df_carro$preço <- str_remove(df_carro$preço, "[:punct:]")



#ARRUMANDO TIPO DAS VARIAVEIS:
#KM
df_carro$km <- as.numeric(df_carro$km)

#PREÇO
df_carro$preço <- as.numeric(df_carro$preço)



#MOSTRANDO RESULTADOS:
#PREÇO
menor_preço <- min(df_carro$preço)
cat("O menor preço é -> R$",menor_preço,"\n")
#KM
menor_km <- min(df_carro$km)
cat("A menor quilometragem é ->", menor_km, "KM\n")




#SALVANDO RESULTADOS EM EXCEL
library(xlsx)
write.xlsx(df_carro, file = "LancerMercadoLivre.xlsx")
getwd()



#HISTOGRAMA
hist(df_carro$preço)