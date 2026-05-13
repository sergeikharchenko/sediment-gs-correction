# main.R

# 1. Загрузка библиотек и функций -----------------------------------------
library(readxl)
library(writexl)
library(dplyr)
library(tidyr)

source("R/gs_functions.R") # Подгружаем наши функции

# 2. Настройки (Ввод данных пользователем) --------------------------------
file_gs   <- "data/setun_gs_new_No.xlsx"
file_chem <- "data/datatab.xlsx"

# Диапазоны диаметров для каждой фракции (в мм)
diameter_ranges <- list(
  c(0.1, 1), c(1, 5), c(5, 10), 
  c(10, 50), c(50, 250), c(250, 1000), c(1000, 2500)
)

# 3. Чтение и подготовка данных -------------------------------------------
gsdata     <- read_xlsx(file_gs, sheet = 1)
gsdata_tar <- read_xlsx(file_gs, sheet = 2)
sources    <- read_xlsx(file_chem)

# Перевод в интервальные проценты
gsdata[, -c(1:2)]     <- interval_percentages(gsdata[, -c(1:2)])
gsdata_tar[, -c(1:2)] <- interval_percentages(gsdata_tar[, -c(1:2)])

# 4. Расчет площади поверхности (Wsum) ------------------------------------
grain_cols <- colnames(gsdata)[-c(1:2)]
stopifnot(length(grain_cols) == length(diameter_ranges))

gsdata$Wsum <- apply(gsdata[, grain_cols], 1, function(v) {
  calculate_surface_area(as.numeric(v), diameter_ranges, geomean = TRUE)
})

gsdata_tar$Wsum <- apply(gsdata_tar[, grain_cols], 1, function(v) {
  calculate_surface_area(as.numeric(v), diameter_ranges, geomean = TRUE)
})

# 5. Нормировка (Wnorm) ---------------------------------------------------
meanW_sources <- mean(gsdata$Wsum, na.rm = TRUE)

gsdata$Wnorm     <- gsdata$Wsum / meanW_sources
gsdata_tar$Wnorm <- gsdata_tar$Wsum / meanW_sources

# 6. Применение поправки к химии ------------------------------------------
# Собираем Wnorm
w_tbl <- bind_rows(
  gsdata %>% select(No, Wsum, Wnorm) %>% mutate(No = as.character(No)),
  gsdata_tar %>% select(No, Wsum, Wnorm) %>% mutate(No = as.character(No))
)

sources$No <- as.character(sources$No)
sources_w <- left_join(sources, w_tbl, by = "No")

# Корректировка элементов
num_cols <- names(sources_w)[sapply(sources_w, is.numeric)]
elements_div <- setdiff(num_cols, c("Wsum", "Wnorm"))

sources_gc <- sources_w
Wnorm_new <- sources_gc$Wnorm
Wnorm_new[is.na(Wnorm_new)] <- 1 # Оставляем как есть, если нет гранулометрии

sources_gc[elements_div] <- sources_gc[elements_div] / Wnorm_new

# 7. Экспорт результатов --------------------------------------------------
write_xlsx(sources_w, "output/sources_Wsum_Wnorm.xlsx")
write_xlsx(sources_gc[, !names(sources_gc) %in% c("Wsum", "Wnorm")], "output/chem_corrected.xlsx")

cat("Готово! Результаты сохранены в папку output/")