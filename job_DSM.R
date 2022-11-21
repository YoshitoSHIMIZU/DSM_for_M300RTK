############################
#点群からテレインフォロー用のTIFFファイルを作製。
#WGS84に投影されたraster.tiffが生成
############################

#lasを指定した方が良いかも

library(lidR)
library(terra)

#データを出力するフォルダのパス。\は/に変える.
setwd() 　　#setwd("C:/Users/yoshi/Documents/temp") 

#処理するlasファイルのパス。\は/に変える.
file <- 　　#file <- "C:/Users/yoshi/Documents/temp/LAS.las"

#点群データの投影法をEPSGコードで入力.
crs <- 　　 #crs <- 6680
  
#DSMのメッシュサイズを指定
res <       #res <- 1　は1mメッシュ

#計算方法を定義
dsm_for_terrainfollow <- function(file, crs, res) {
  las <- readLAS(file, select = "xyz" )
  st_crs(las) <- crs
  dsm <- rasterize_canopy(las, res = 1, algorithm = p2r(na.fill = tin()))
  col <- height.colors(25)
  plot(dsm, col = col)
  dsm_wgs84 <- project(dsm, "EPSG:4326", method = "near")
  writeRaster(dsm_wgs84, "raster.tiff") 
}

#######

#実行
dsm_for_terrainfollow(file, crs, res)  

#######
  



  
#lasファイル読み込み。XYZだけ読み込み
las <- readLAS(file, select = "xyz" )

#点群の解析で使用したEPSGコードを入力
st_crs(las) <- 6680

#DSMの解像度を設定可能。res = 1は1メートルメッシュ。
#値無しのピクセルは（可能性は少ないが）、tinで補完。
dsm <- rasterize_canopy(las, res = 1, algorithm = p2r(na.fill = tin()))

#データ確認
col <- height.colors(25)
plot(dsm, col = col)

#WGS84へ再投影
dsm_wgs84 <- project(dsm, "EPSG:4326", method = "near")

#ファイルを出力。
writeRaster(dsm_wgs84, "raster_wgs84.tiff")  
#writeRaster(dsm_wgs84, "raster_wgs84.tiff")



terrainfollow(file, 6680, 1)
