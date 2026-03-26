# ============================================================
# STEP 4: ANALISIS KORELASI - ANALISIS EKONOMI JAWA TENGAH
# ============================================================

library(tidyverse)
library(corrplot)    # Visualisasi matriks korelasi
library(GGally)      # Scatter plot matrix

# Install jika belum ada
if (!require("corrplot")) install.packages("corrplot")
if (!require("GGally"))   install.packages("GGally")

library(corrplot)
library(GGally)

PATH     <- "D:/PROJECT INTERN/FILE PROJECT/"
df_final <- read_csv(paste0(PATH, "df_final_panel.csv"),
                     show_col_types = FALSE)

# ============================================================
# 4.1 Matriks Korelasi (Pearson)
# ============================================================

df_cor <- df_final |>
  select(kemiskinan_pct, ipm, tpt, pdrb) |>
  drop_na()

mat_cor <- cor(df_cor, method = "pearson")

cat("===== MATRIKS KORELASI =====\n")
print(round(mat_cor, 3))

# ============================================================
# 4.2 Visualisasi Corrplot
# ============================================================

png(paste0(PATH, "plot7_corrplot.png"), width = 800, height = 700)
corrplot(mat_cor,
         method   = "color",
         type     = "upper",
         addCoef.col = "black",
         tl.col   = "black",
         tl.srt   = 45,
         col      = colorRampPalette(c("#d73027", "white", "#1a6b8a"))(200),
         title    = "Matriks Korelasi Indikator Ekonomi Jawa Tengah",
         mar      = c(0, 0, 2, 0))
dev.off()
cat("✔ Plot corrplot tersimpan!\n")

# ============================================================
# 4.3 GGPairs - Scatter Plot Matrix Lengkap
# ============================================================

p_pairs <- ggpairs(
  df_cor,
  columnLabels = c("Kemiskinan (%)", "IPM", "TPT (%)", "PDRB (%)"),
  upper = list(continuous = wrap("cor", size = 4, color = "black")),
  lower = list(continuous = wrap("smooth", method = "lm",
                                 color = "#1a6b8a", alpha = 0.4)),
  diag  = list(continuous = wrap("densityDiag", fill = "#a8edea"))
) +
  labs(
    title    = "Scatter Plot Matrix Indikator Ekonomi Jawa Tengah",
    subtitle = "2020-2024"
  ) +
  theme_classic()

print(p_pairs)
ggsave(paste0(PATH, "plot8_ggpairs.png"),
       plot = p_pairs, width = 10, height = 8, dpi = 150)
cat("✔ Plot GGpairs tersimpan!\n")

# ============================================================
# 4.4 Interpretasi Otomatis
# ============================================================

cat("\n===== INTERPRETASI KORELASI =====\n")

interpretasi <- function(r, var1, var2) {
  kekuatan <- case_when(
    abs(r) >= 0.8 ~ "sangat kuat",
    abs(r) >= 0.6 ~ "kuat",
    abs(r) >= 0.4 ~ "sedang",
    abs(r) >= 0.2 ~ "lemah",
    TRUE           ~ "sangat lemah"
  )
  arah <- ifelse(r > 0, "positif", "negatif")
  cat(paste0("• ", var1, " & ", var2, ": r = ", round(r, 3),
             " → korelasi ", arah, " ", kekuatan, "\n"))
}

interpretasi(mat_cor["kemiskinan_pct", "ipm"],  "Kemiskinan", "IPM")
interpretasi(mat_cor["kemiskinan_pct", "tpt"],  "Kemiskinan", "TPT")
interpretasi(mat_cor["kemiskinan_pct", "pdrb"], "Kemiskinan", "PDRB")
interpretasi(mat_cor["ipm", "tpt"],             "IPM",        "TPT")
interpretasi(mat_cor["ipm", "pdrb"],            "IPM",        "PDRB")
interpretasi(mat_cor["tpt", "pdrb"],            "TPT",        "PDRB")

cat("\n✅ Analisis korelasi selesai! Cek folder:", PATH, "\n")


