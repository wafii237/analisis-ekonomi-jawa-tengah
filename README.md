# 📊 Analisis Ekonomi Jawa Tengah 2020-2024

## 📌 Deskripsi Project
Analisis data panel indikator ekonomi Kabupaten/Kota di Provinsi Jawa Tengah 
periode 2020–2024 menggunakan R. Project ini mencakup data wrangling, 
exploratory data analysis, visualisasi, analisis korelasi, dan regresi data panel.

## 📂 Struktur File
| File | Deskripsi |
|------|-----------|
| `DATA_WRANGLING.R` | Pembersihan & transformasi data (wide → long format) |
| `EDA.R` | Exploratory Data Analysis & statistik deskriptif |
| `VISUALISASI.R` | Visualisasi data menggunakan ggplot2 |
| `KORELASI.R` | Analisis korelasi Pearson & corrplot |
| `05_regresi.R` | Regresi data panel (Pooled OLS, FEM, REM) |
| `06_laporan.qmd` | Laporan HTML menggunakan Quarto |

## 📈 Variabel yang Dianalisis
- **Kemiskinan** : Persentase penduduk miskin (%)
- **IPM** : Indeks Pembangunan Manusia
- **TPT** : Tingkat Pengangguran Terbuka (%)
- **PDRB** : Laju Pertumbuhan Ekonomi (%)

## 🔧 Tools & Package
- **R & RStudio**
- `tidyverse` `ggplot2` `corrplot` `GGally` `plm` `stargazer` `kableExtra` `Quarto`

## 📋 Metodologi
1. **Data Wrangling** → Transformasi wide ke long format, cleaning data
2. **EDA** → Statistik deskriptif, tren per tahun, ranking kabupaten
3. **Visualisasi** → Line chart, bar chart, scatter plot, heatmap
4. **Korelasi** → Matriks korelasi Pearson
5. **Regresi Data Panel** → Pooled OLS, Fixed Effect, Random Effect + Uji Hausman

## 📊 Hasil Laporan
🔗 **RPubs**: [Lihat Laporan Lengkap](https://rpubs.com/Wafifaeruz/analisis-ekonomi-jateng)

## 📌 Kesimpulan
- IPM berpengaruh **negatif signifikan** terhadap kemiskinan
- TPT berpengaruh **positif signifikan** terhadap kemiskinan  
- Model terbaik: **Fixed Effect Model** berdasarkan Uji Hausman

## 👤 Author
**Wafi** - Mahasiswa Statistika
```

4. Klik **Commit changes**

---

### STEP 4 — Lihat Hasilnya
Repository kamu sekarang punya URL seperti:
```
https://github.com/username/analisis-ekonomi-jawa-tengah
