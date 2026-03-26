# ==================================================
# LOAD LIBRARY
# ==================================================
if (!require("tidyverse")) install.packages("tidyverse")
if (!require("glue"))      install.packages("glue")

library(tidyverse)
library(glue)          # ← Wajib di-load eksplisit!

# ============================================================
# DATA WRANGLING - ANALISIS EKONOMI JAWA TENGAH (2020-2024)
# ============================================================

library(tidyverse)

PATH <- "D:/PROJECT INTERN/FILE PROJECT/"

read_and_pivot <- function(filename, value_name) {
  filepath <- paste0(PATH, filename)
  
  # Baca 5 baris pertama untuk deteksi otomatis
  all_rows <- read_csv(filepath, col_names = FALSE,
                       show_col_types = FALSE, n_max = 5)
  
  # Cari baris mana yang mengandung tahun (2020-2024)
  baris_tahun <- NA
  for (i in 1:nrow(all_rows)) {
    row_i <- as.character(all_rows[i, ])
    if (any(str_detect(row_i, "^202[0-9]$"), na.rm = TRUE)) {
      baris_tahun <- i
      break
    }
  }
  
  cat(filename, "-> Tahun ditemukan di baris ke:", baris_tahun, "\n")
  
  # Ambil posisi & nilai kolom tahun dari baris yang ditemukan
  header_row   <- as.character(all_rows[baris_tahun, ])
  tahun_cols   <- which(str_detect(header_row, "^202[0-9]$"))
  tahun_values <- header_row[tahun_cols]
  
  cat(filename, "-> Kolom tahun di posisi:", tahun_cols, "\n")
  cat(filename, "-> Nilai tahun:", tahun_values, "\n\n")
  
  # Baca data asli (skip sampai baris setelah baris tahun)
  df_raw <- read_csv(filepath,
                     skip           = baris_tahun,
                     col_names      = FALSE,
                     show_col_types = FALSE) |>
    filter(!is.na(X1), str_squish(as.character(X1)) != "")
  
  # Pilih kolom kabupaten + kolom tahun, beri nama
  df_long <- df_raw |>
    select(1, all_of(tahun_cols)) |>
    setNames(c("kabupaten_kota", tahun_values)) |>
    mutate(across(-1, as.character)) |>
    pivot_longer(cols      = -kabupaten_kota,
                 names_to  = "tahun",
                 values_to = value_name) |>
    mutate(
      tahun          = as.integer(tahun),
      kabupaten_kota = str_squish(str_to_upper(kabupaten_kota)),
      !!value_name  := suppressWarnings(as.numeric(
        str_replace_all(
          str_remove_all(get(value_name), "\\.(?=\\d{3})"),
          ",", ".")))
    ) |>
    filter(!is.na(tahun), !is.na(kabupaten_kota))
  
  message(paste0("✔ ", filename, " BERHASIL: ", nrow(df_long),
                 " baris | Tahun: ",
                 paste(sort(unique(df_long$tahun)), collapse = ", ")))
  return(df_long)
}

# ============================================================
# LANGKAH 4: Baca semua file
# ============================================================
df_kemiskinan <- read_and_pivot("KEMISKINAN.csv", "kemiskinan_pct")
df_ipm        <- read_and_pivot("IPM.csv",        "ipm")
df_tpt        <- read_and_pivot("TPT.csv",        "tpt")
df_pdrb       <- read_and_pivot("PDRB.csv",       "pdrb")

# ============================================================
# LANGKAH 5: Gabungkan jadi df_final
# ============================================================
df_final <- df_kemiskinan |>
  full_join(df_ipm,  by = c("kabupaten_kota", "tahun")) |>
  full_join(df_tpt,  by = c("kabupaten_kota", "tahun")) |>
  full_join(df_pdrb, by = c("kabupaten_kota", "tahun")) |>
  arrange(kabupaten_kota, tahun)

# ============================================================
# LANGKAH 6: Validasi
# ============================================================
glimpse(df_final)
cat("\nNA total :", sum(is.na(df_final)), "\n")
cat("Kab/Kota :", n_distinct(df_final$kabupaten_kota), "\n")
cat("Tahun    :", sort(unique(df_final$tahun)), "\n")
print(head(df_final, 10))

# ============================================================
# LANGKAH 7: Simpan
# ============================================================
write_csv(df_final, paste0(PATH, "df_final_panel.csv"))
cat("\n✔ File df_final_panel.csv tersimpan di", PATH, "\n")

# Hapus baris Provinsi Jawa Tengah (hanya simpan kabupaten/kota)
df_final <- df_final |>
  filter(!str_detect(kabupaten_kota, "PROVINSI"))

# Cek hasilnya
cat("Jumlah baris sekarang:", nrow(df_final), "\n")
cat("Kab/Kota:", n_distinct(df_final$kabupaten_kota), "\n")
print(head(df_final, 5))

# Simpan ulang
write_csv(df_final, paste0(PATH, "df_final_panel.csv"))
cat("✔ File tersimpan!\n")



df_final <- df_final |>
  filter(!str_detect(kabupaten_kota, "CATATAN"))

# Cek hasilnya
cat("Jumlah baris sekarang:", nrow(df_final), "\n")
cat("Kab/Kota:", n_distinct(df_final$kabupaten_kota), "\n")
print(tail(df_final, 5))  # Cek bagian bawah tabel

# Simpan ulang
write_csv(df_final, paste0(PATH, "df_final_panel.csv"))
cat("✔ File tersimpan!\n")