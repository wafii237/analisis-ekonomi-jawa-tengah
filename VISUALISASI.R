# ============================================================
# STEP 3: VISUALISASI - ANALISIS EKONOMI JAWA TENGAH
# ============================================================

library(tidyverse)

PATH     <- "D:/PROJECT INTERN/FILE PROJECT/"
df_final <- read_csv(paste0(PATH, "df_final_panel.csv"),
                     show_col_types = FALSE)

# Tema custom konsisten untuk semua grafik
tema <- theme_classic() +
  theme(
    plot.title    = element_text(face = "bold", size = 13),
    plot.subtitle = element_text(color = "grey40", size = 10),
    axis.title    = element_text(size = 10),
    legend.position = "bottom"
  )

# ============================================================
# GRAFIK 1: LINE CHART - Tren Rata-rata Per Tahun
# ============================================================

df_tren <- df_final |>
  group_by(tahun) |>
  summarise(
    Kemiskinan = mean(kemiskinan_pct, na.rm = TRUE),
    IPM        = mean(ipm,            na.rm = TRUE),
    TPT        = mean(tpt,            na.rm = TRUE),
    PDRB       = mean(pdrb,           na.rm = TRUE)
  ) |>
  pivot_longer(-tahun, names_to = "Indikator", values_to = "Nilai")

ggplot(df_tren, aes(x = tahun, y = Nilai, color = Indikator)) +
  geom_line(linewidth = 1.2) +
  geom_point(size = 3) +
  facet_wrap(~Indikator, scales = "free_y") +
  scale_x_continuous(breaks = 2020:2024) +
  labs(
    title    = "Tren Indikator Ekonomi Jawa Tengah (2020-2024)",
    subtitle = "Rata-rata seluruh Kabupaten/Kota",
    x = "Tahun", y = "Nilai"
  ) +
  tema +
  theme(legend.position = "none")

ggsave(paste0(PATH, "plot1_tren.png"), width = 10, height = 6, dpi = 150)
cat("✔ Plot 1 tersimpan!\n")

# ============================================================
# GRAFIK 2: BAR CHART - Top 10 Kabupaten Termiskin & Terkaya
# ============================================================

# Top 10 Termiskin
df_miskin <- df_final |>
  group_by(kabupaten_kota) |>
  summarise(avg_kemiskinan = mean(kemiskinan_pct, na.rm = TRUE)) |>
  arrange(desc(avg_kemiskinan)) |>
  head(10)

ggplot(df_miskin, aes(x = reorder(kabupaten_kota, avg_kemiskinan),
                      y = avg_kemiskinan, fill = avg_kemiskinan)) +
  geom_col(show.legend = FALSE) +
  geom_text(aes(label = round(avg_kemiskinan, 1)),
            hjust = -0.2, size = 3.5) +
  scale_fill_gradient(low = "#f7c59f", high = "#e84545") +
  coord_flip() +
  labs(
    title    = "Top 10 Kabupaten/Kota Tingkat Kemiskinan Tertinggi",
    subtitle = "Rata-rata 2020-2024 (%)",
    x = NULL, y = "Kemiskinan (%)"
  ) +
  tema

ggsave(paste0(PATH, "plot2_kemiskinan.png"), width = 10, height = 6, dpi = 150)
cat("✔ Plot 2 tersimpan!\n")

# Top 10 IPM Tertinggi
df_ipm_top <- df_final |>
  group_by(kabupaten_kota) |>
  summarise(avg_ipm = mean(ipm, na.rm = TRUE)) |>
  arrange(desc(avg_ipm)) |>
  head(10)

ggplot(df_ipm_top, aes(x = reorder(kabupaten_kota, avg_ipm),
                       y = avg_ipm, fill = avg_ipm)) +
  geom_col(show.legend = FALSE) +
  geom_text(aes(label = round(avg_ipm, 1)),
            hjust = -0.2, size = 3.5) +
  scale_fill_gradient(low = "#a8edea", high = "#1a6b8a") +
  coord_flip() +
  labs(
    title    = "Top 10 Kabupaten/Kota IPM Tertinggi",
    subtitle = "Rata-rata 2020-2024",
    x = NULL, y = "IPM"
  ) +
  tema

ggsave(paste0(PATH, "plot3_ipm.png"), width = 10, height = 6, dpi = 150)
cat("✔ Plot 3 tersimpan!\n")

# ============================================================
# GRAFIK 3: SCATTER PLOT - Hubungan Antar Variabel
# ============================================================

# IPM vs Kemiskinan
ggplot(df_final, aes(x = ipm, y = kemiskinan_pct, color = factor(tahun))) +
  geom_point(alpha = 0.7, size = 2.5) +
  geom_smooth(method = "lm", se = TRUE, color = "black",
              linewidth = 0.8, linetype = "dashed") +
  scale_color_brewer(palette = "Set1", name = "Tahun") +
  labs(
    title    = "Hubungan IPM dan Tingkat Kemiskinan",
    subtitle = "Kabupaten/Kota Jawa Tengah 2020-2024",
    x = "IPM", y = "Kemiskinan (%)"
  ) +
  tema

ggsave(paste0(PATH, "plot4_scatter_ipm_miskin.png"), width = 8, height = 6, dpi = 150)
cat("✔ Plot 4 tersimpan!\n")

# PDRB vs TPT
ggplot(df_final, aes(x = pdrb, y = tpt, color = factor(tahun))) +
  geom_point(alpha = 0.7, size = 2.5) +
  geom_smooth(method = "lm", se = TRUE, color = "black",
              linewidth = 0.8, linetype = "dashed") +
  scale_color_brewer(palette = "Set2", name = "Tahun") +
  labs(
    title    = "Hubungan PDRB dan Tingkat Pengangguran (TPT)",
    subtitle = "Kabupaten/Kota Jawa Tengah 2020-2024",
    x = "PDRB (Laju Pertumbuhan %)", y = "TPT (%)"
  ) +
  tema

ggsave(paste0(PATH, "plot5_scatter_pdrb_tpt.png"), width = 8, height = 6, dpi = 150)
cat("✔ Plot 5 tersimpan!\n")

# ============================================================
# GRAFIK 4: HEATMAP - Semua Variabel per Kabupaten & Tahun
# ============================================================

# Heatmap Kemiskinan
df_heat <- df_final |>
  group_by(kabupaten_kota) |>
  mutate(avg_miskin = mean(kemiskinan_pct, na.rm = TRUE)) |>
  ungroup() |>
  arrange(desc(avg_miskin))

top20 <- df_heat |>
  distinct(kabupaten_kota, avg_miskin) |>
  arrange(desc(avg_miskin)) |>
  head(20) |>
  pull(kabupaten_kota)

df_heat |>
  filter(kabupaten_kota %in% top20) |>
  mutate(kabupaten_kota = factor(kabupaten_kota, levels = rev(top20))) |>
  ggplot(aes(x = factor(tahun), y = kabupaten_kota,
             fill = kemiskinan_pct)) +
  geom_tile(color = "white", linewidth = 0.5) +
  geom_text(aes(label = round(kemiskinan_pct, 1)),
            size = 3, color = "black") +
  scale_fill_gradient(low = "#fff7bc", high = "#d73027",
                      name = "Kemiskinan (%)") +
  labs(
    title    = "Heatmap Tingkat Kemiskinan",
    subtitle = "Top 20 Kabupaten/Kota Jawa Tengah 2020-2024",
    x = "Tahun", y = NULL
  ) +
  tema +
  theme(legend.position = "right")

ggsave(paste0(PATH, "plot6_heatmap.png"), width = 10, height = 8, dpi = 150)
cat("✔ Plot 6 tersimpan!\n")

cat("\n✅ Semua visualisasi selesai! Cek folder:", PATH, "\n")

