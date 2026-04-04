# 📊 Analisis Ekonomi Jawa Tengah 2020-2024

## 📌 Deskripsi Project
Analisis data panel indikator ekonomi Kabupaten/Kota di Provinsi Jawa Tengah 
periode 2020–2024 menggunakan R dan Python. Project ini mencakup data wrangling, 
exploratory data analysis, visualisasi, analisis korelasi, regresi data panel, 
dashboard interaktif, SQL, dan machine learning.

## 📂 Struktur File
| File | Deskripsi |
|------|-----------|
| `DATA_WRANGLING.R` | Pembersihan & transformasi data (wide → long format) |
| `EDA.R` | Exploratory Data Analysis & statistik deskriptif |
| `VISUALISASI.R` | Visualisasi data menggunakan ggplot2 |
| `KORELASI.R` | Analisis korelasi Pearson & corrplot |
| `05_regresi.R` | Regresi data panel (Pooled OLS, FEM, REM) |
| `06_laporan.qmd` | Laporan HTML menggunakan Quarto |
| `app.R` | Dashboard interaktif menggunakan Shiny |
| `03_sql_python.ipynb` | Analisis SQL + Python |
| `04_machine_learning.ipynb` | Machine Learning dengan Python |

## 📈 Variabel yang Dianalisis
- **Kemiskinan** : Persentase penduduk miskin (%)
- **IPM** : Indeks Pembangunan Manusia
- **TPT** : Tingkat Pengangguran Terbuka (%)
- **PDRB** : Laju Pertumbuhan Ekonomi (%)

## 🔧 Tools & Package
- **R & RStudio**: tidyverse, ggplot2, corrplot, GGally, plm, stargazer, kableExtra, Shiny, Quarto
- **Python**: Pandas, Matplotlib, Seaborn, SQLAlchemy, Scikit-learn
- **Database**: SQLite
- **Platform**: RPubs, Shinyapps.io, GitHub

---

## 🗂️ Project 1 - Analisis Data Panel (R)
- Tools: R, tidyverse, ggplot2, plm, corrplot, Quarto
- Analisis lengkap meliputi data wrangling, EDA, visualisasi, korelasi, dan regresi data panel
- Model terbaik: **Fixed Effect Model** berdasarkan Uji Hausman
- **IPM** berpengaruh negatif signifikan terhadap kemiskinan
- **TPT** berpengaruh positif signifikan terhadap kemiskinan

## 📊 Project 2 - Dashboard Interaktif (R Shiny)
- Tools: R, Shiny, shinydashboard, plotly, DT
- Dashboard interaktif dengan filter tahun dan kabupaten/kota
- Fitur: Overview, Perbandingan, Korelasi, dan Tabel Data

## 🗄️ Project 3 - SQL + Python
- Tools: Python, SQLite, Pandas, Matplotlib
- Analisis data ekonomi Jawa Tengah menggunakan SQL query dan visualisasi Python

## 🤖 Project 4 - Machine Learning (Python)
- Tools: Python, Scikit-learn
- Model: Linear Regression & Random Forest
- Target: Prediksi tingkat kemiskinan
- Model terbaik: **Random Forest** (R² = 0.53)

---

## 📊 Hasil & Output

| Platform | Link |
|----------|------|
| 📄 Laporan RPubs | https://rpubs.com/Wafifaeruz/analisis-ekonomi-jateng |
| 📊 Dashboard Shiny | https://wafifaeruz.shinyapps.io/dashboard_ekonomi_jateng/ |

## 📌 Metodologi
1. **Data Wrangling** → Transformasi wide ke long format, cleaning data
2. **EDA** → Statistik deskriptif, tren per tahun, ranking kabupaten
3. **Visualisasi** → Line chart, bar chart, scatter plot, heatmap
4. **Korelasi** → Matriks korelasi Pearson
5. **Regresi Data Panel** → Pooled OLS, Fixed Effect, Random Effect + Uji Hausman
6. **Dashboard** → Shiny interaktif
7. **SQL + Python** → Query database & visualisasi
8. **Machine Learning** → Prediksi kemiskinan

## 👤 Author
**Wafi Faeruz** - Mahasiswa Statistika Terapan dan Komputasi
