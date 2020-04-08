
# Bibliotecas
library(exiftoolr)
library(exifr)
library(dplyr)
library(sp)
library(rgdal)


#Carregando arquivos
fotos = choose.files()

#adquirindo as coordenadas
dat = read_exif(fotos)
tabela_coordenadas = data.frame(Nome_arquivo = dat$FileName, latitude = dat$GPSLatitude, longitude= dat$GPSLongitude, altitude = dat$GPSAltitude)
tabela_coordenadas = na.omit(tabela_coordenadas)
# modificando a forma de escrita das coordenadas
#tabela_coordenadas$lat_degree= char2dms()
#tabela_coordenadas$long_degree= char2dms()


# transformando em arquivo ponto para o qgis e em kml
pontos_kml = tabela_coordenadas
coordinates(pontos_kml) <- c("longitude", "latitude")
proj4string(pontos_kml) <- CRS("+init=epsg:4326") #nao sei o que eh isso, no help diz que e pra contornar problemas.
pontos_kml= spTransform(pontos_kml, CRS("+proj=longlat +datum=WGS84"))
writeOGR(pontos_kml, dsn= choose.files(caption = "Crie o arquivo de saida dos pontos. nao esquecer de adicionar a terminacao .kml"), driver="KML",layer = "pontos_kml")
write.table(choose.files(caption = "Crie o arquivo de saida em tabela. Nao esqueca de adicionar a terminacao .txt"))

