# ============================================================
# STEP 5: REGRESI DATA PANEL - ANALISIS EKONOMI JAWA TENGAH
# ============================================================

if (!require("plm"))       install.packages("plm")
if (!require("lmtest"))    install.packages("lmtest")
if (!require("sandwich"))  install.packages("sandwich")
if (!require("stargazer")) install.packages("stargazer")

library(tidyverse)
library(plm)
library(lmtest)
library(sandwich)
library(stargazer)

PATH     <- "D:/PROJECT INTERN/FILE PROJECT/"
df_final <- read_csv(paste0(PATH, "df_final_panel.csv"),
                     show_col_types = FALSE)

# ============================================================
# 5.1 Persiapan Data Panel
# ============================================================

df_panel <- df_final |>
  drop_na() |>                          # Hapus baris NA
  arrange(kabupaten_kota, tahun)

# Deklarasi sebagai data panel
pdata <- pdata.frame(df_panel,
                     index = c("kabupaten_kota", "tahun"))

cat("===== INFO DATA PANEL =====\n")
cat("Jumlah observasi :", nrow(pdata), "\n")
cat("Jumlah individu  :", length(unique(pdata$kabupaten_kota)), "\n")
cat("Jumlah periode   :", length(unique(pdata$tahun)), "\n\n")

# ============================================================
# 5.2 Model 1: Pooled OLS
# ============================================================

model_ols <- plm(kemiskinan_pct ~ ipm + tpt + pdrb,
                 data   = pdata,
                 model  = "pooling")

cat("===== POOLED OLS =====\n")
print(summary(model_ols))

# ============================================================
# 5.3 Model 2: Fixed Effect Model (FEM)
# ============================================================

model_fem <- plm(kemiskinan_pct ~ ipm + tpt + pdrb,
                 data   = pdata,
                 model  = "within",
                 effect = "twoways")   # Fixed effect individu + waktu

cat("\n===== FIXED EFFECT MODEL =====\n")
print(summary(model_fem))

# ============================================================
# 5.4 Model 3: Random Effect Model (REM)
# ============================================================

model_rem <- plm(kemiskinan_pct ~ ipm + tpt + pdrb,
                 data   = pdata,
                 model  = "random")

cat("\n===== RANDOM EFFECT MODEL =====\n")
print(summary(model_rem))

# ============================================================
# 5.5 Uji Pemilihan Model
# ============================================================

cat("\n===== UJI CHOW (Pooled OLS vs FEM) =====\n")
uji_chow <- pFtest(model_fem, model_ols)
print(uji_chow)
cat("Kesimpulan:", ifelse(uji_chow$p.value < 0.05,
                          "✔ Tolak H0 → FEM lebih baik dari Pooled OLS",
                          "✔ Gagal Tolak H0 → Pooled OLS lebih baik"), "\n")

cat("\n===== UJI BREUSCH-PAGAN (Pooled OLS vs REM) =====\n")
uji_bp <- plmtest(model_ols, type = "bp")
print(uji_bp)
cat("Kesimpulan:", ifelse(uji_bp$p.value < 0.05,
                          "✔ Tolak H0 → REM lebih baik dari Pooled OLS",
                          "✔ Gagal Tolak H0 → Pooled OLS lebih baik"), "\n")

cat("\n===== UJI HAUSMAN (FEM vs REM) =====\n")
uji_hausman <- phtest(model_fem, model_rem)
print(uji_hausman)
cat("Kesimpulan:", ifelse(uji_hausman$p.value < 0.05,
                          "✔ Tolak H0 → FEM lebih baik (gunakan FEM)",
                          "✔ Gagal Tolak H0 → REM lebih baik (gunakan REM)"), "\n")

# ============================================================
# 5.6 Model Terbaik - Uji Asumsi Klasik
# ============================================================

# Tentukan model terbaik otomatis
model_terbaik <- if (uji_hausman$p.value < 0.05) model_fem else model_rem
nama_model    <- if (uji_hausman$p.value < 0.05) "Fixed Effect" else "Random Effect"

cat("\n===== MODEL TERBAIK:", nama_model, "=====\n")
print(summary(model_terbaik))

# Uji Heteroskedastisitas
cat("\n===== UJI HETEROSKEDASTISITAS (Breusch-Pagan) =====\n")
uji_hetero <- bptest(model_terbaik)
print(uji_hetero)
cat("Kesimpulan:", ifelse(uji_hetero$p.value < 0.05,
                          "⚠ Ada heteroskedastisitas → gunakan robust SE",
                          "✔ Tidak ada heteroskedastisitas"), "\n")

# Uji Autokorelasi
cat("\n===== UJI AUTOKORELASI (Wooldridge) =====\n")
uji_auto <- pbgtest(model_terbaik)
print(uji_auto)
cat("Kesimpulan:", ifelse(uji_auto$p.value < 0.05,
                          "⚠ Ada autokorelasi",
                          "✔ Tidak ada autokorelasi"), "\n")

# ============================================================
# 5.7 Tabel Perbandingan Model (Stargazer)
# ============================================================

stargazer(model_ols, model_fem, model_rem,
          type          = "text",
          title         = "Perbandingan Model Regresi Data Panel",
          column.labels = c("Pooled OLS", "Fixed Effect", "Random Effect"),
          dep.var.labels = "Kemiskinan (%)",
          covariate.labels = c("IPM", "TPT (%)", "PDRB (%)"),
          out           = paste0(PATH, "tabel_regresi.txt"))

cat("\n✅ Analisis regresi selesai! Cek folder:", PATH, "\n")