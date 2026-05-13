# R/gs_functions.R

#' Функция для вычисления интервальных процентов из кумулятивных
interval_percentages <- function(data) {
  n_cols <- ncol(data)
  interval_data <- data.frame(matrix(ncol = n_cols, nrow = nrow(data)))
  colnames(interval_data) <- colnames(data)
  
  for (i in 1:nrow(data)) {
    interval_data[i, 1] <- data[i, 1]
    for (j in 2:n_cols) {
      interval_data[i, j] <- data[i, j] - data[i, j - 1]
    }
  }
  return(interval_data)
}

#' Функция для расчета суммарной площади поверхности (Формулы 1-6)
calculate_surface_area <- function(volume_fractions, diameter_ranges, geomean = TRUE) {
  if (length(volume_fractions) != length(diameter_ranges)) {
    stop("Длина векторов volume_fractions и diameter_ranges должна быть одинаковой.")
  }
  
  surface_area_fractions <- numeric(length(volume_fractions))
  
  for (i in 1:length(volume_fractions)) {
    volume_fraction <- volume_fractions[i]
    diameter_range <- diameter_ranges[[i]]
    
    # 1. Средний диаметр
    if (geomean) {
      mean_diameter <- sqrt(diameter_range[1] * diameter_range[2])
    } else {
      mean_diameter <- mean(c(diameter_range[1], diameter_range[2]))
    }
    
    # 2-4. Объем, количество и площадь одной частицы
    particle_volume <- (pi/6) * mean_diameter^3
    number_of_particles <- volume_fraction / particle_volume
    particle_surface_area <- 4 * pi * (mean_diameter/2)^2
    
    # 5. Площадь фракции
    surface_area_fractions[i] <- particle_surface_area * number_of_particles
  }
  
  # 6. Суммарная площадь
  return(sum(surface_area_fractions))
}