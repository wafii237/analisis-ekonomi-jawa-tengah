# ============================================================
# STEP 2: EXPLORATORY DATA ANALYSIS (EDA)
# ============================================================

library(tidyverse)

# --- 2.1 Ringkasan Statistik Deskriptif ---
cat("===== STATISTIK DESKRIPTIF =====\n")
df_final |>
  select(kemiskinan_pct, ipm, tpt, pdrb) |>
  summary() |>
  print()

# --- 2.2 Cek Missing Values per Kolom ---
cat("\n===== MISSING VALUES =====\n")
df_final |>
  summarise(across(everything(), ~sum(is.na(.)))) |>
  print()

# --- 2.3 Jumlah Kabupaten/Kota per Tahun ---
cat("\n===== OBSERVASI PER TAHUN =====\n")
df_final |>
  group_by(tahun) |>
  summarise(n_kabkota = n()) |>
  print()

# --- 2.4 Rata-rata tiap variabel per tahun ---
cat("\n===== RATA-RATA PER TAHUN =====\n")
df_final |>
  group_by(tahun) |>
  summarise(
    avg_kemiskinan = round(mean(kemiskinan_pct, na.rm = TRUE), 2),
    avg_ipm        = round(mean(ipm,            na.rm = TRUE), 2),
    avg_tpt        = round(mean(tpt,            na.rm = TRUE), 2),
    avg_pdrb       = round(mean(pdrb,           na.rm = TRUE), 2)
  ) |>
  print()

# --- 2.5 Top 5 Kabupaten Termiskin (rata-rata 2020-2024) ---
cat("\n===== TOP 5 TERMISKIN =====\n")
df_final |>
  group_by(kabupaten_kota) |>
  summarise(avg_kemiskinan = round(mean(kemiskinan_pct, na.rm = TRUE), 2)) |>
  arrange(desc(avg_kemiskinan)) |>
  head(5) |>
  print()

# --- 2.6 Top 5 IPM Tertinggi ---
cat("\n===== TOP 5 IPM TERTINGGI =====\n")
df_final |>
  group_by(kabupaten_kota) |>
  summarise(avg_ipm = round(mean(ipm, na.rm = TRUE), 2)) |>
  arrange(desc(avg_ipm)) |>
  head(5) |>
  print()