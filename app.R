# ============================================================
# PROJECT 2: DASHBOARD EKONOMI JAWA TENGAH
# ============================================================

library(shiny)
library(shinydashboard)
library(tidyverse)
library(plotly)
library(DT)

# Load data
df <- read_csv("df_final_panel.csv", show_col_types = FALSE)

# ============================================================
# UI
# ============================================================
ui <- dashboardPage(
  skin = "blue",
  
  dashboardHeader(
    title = "Ekonomi Jawa Tengah"
  ),
  
  dashboardSidebar(
    sidebarMenu(
      menuItem("Overview",      tabName = "overview",  icon = icon("chart-line")),
      menuItem("Perbandingan",  tabName = "compare",   icon = icon("chart-bar")),
      menuItem("Korelasi",      tabName = "korelasi",  icon = icon("circle-dot")),
      menuItem("Data",          tabName = "data",      icon = icon("table"))
    ),
    
    hr(),
    
    # Filter Tahun
    sliderInput("tahun", "Pilih Tahun:",
                min = 2020, max = 2024,
                value = c(2020, 2024), step = 1,
                sep = ""),
    
    # Filter Kabupaten
    pickerInput_placeholder <- selectInput(
      "kabupaten", "Pilih Kabupaten/Kota:",
      choices  = c("Semua", sort(unique(df$kabupaten_kota))),
      selected = "Semua",
      multiple = FALSE
    )
  ),
  
  dashboardBody(
    tabItems(
      
      # ── TAB 1: OVERVIEW ──────────────────────────────────
      tabItem(tabName = "overview",
              
              # Value Boxes
              fluidRow(
                valueBoxOutput("box_kemiskinan", width = 3),
                valueBoxOutput("box_ipm",        width = 3),
                valueBoxOutput("box_tpt",        width = 3),
                valueBoxOutput("box_pdrb",       width = 3)
              ),
              
              # Line Chart Tren
              fluidRow(
                box(title = "Tren Indikator per Tahun", 
                    status = "primary", solidHeader = TRUE, width = 12,
                    plotlyOutput("plot_tren", height = 400))
              )
      ),
      
      # ── TAB 2: PERBANDINGAN ──────────────────────────────
      tabItem(tabName = "compare",
              fluidRow(
                box(title = "Pilih Indikator", status = "warning",
                    solidHeader = TRUE, width = 12,
                    selectInput("indikator", "Indikator:",
                                choices = c("kemiskinan_pct", "ipm", "tpt", "pdrb"),
                                selected = "kemiskinan_pct"))
              ),
              fluidRow(
                box(title = "Top 10 Kabupaten/Kota",
                    status = "primary", solidHeader = TRUE, width = 12,
                    plotlyOutput("plot_bar", height = 450))
              )
      ),
      
      # ── TAB 3: KORELASI ──────────────────────────────────
      tabItem(tabName = "korelasi",
              fluidRow(
                box(title = "Pilih Variabel", status = "warning",
                    solidHeader = TRUE, width = 12,
                    column(6, selectInput("var_x", "Sumbu X:",
                                          choices = c("kemiskinan_pct", "ipm", "tpt", "pdrb"),
                                          selected = "ipm")),
                    column(6, selectInput("var_y", "Sumbu Y:",
                                          choices = c("kemiskinan_pct", "ipm", "tpt", "pdrb"),
                                          selected = "kemiskinan_pct"))
                )
              ),
              fluidRow(
                box(title = "Scatter Plot",
                    status = "primary", solidHeader = TRUE, width = 12,
                    plotlyOutput("plot_scatter", height = 450))
              )
      ),
      
      # ── TAB 4: DATA ──────────────────────────────────────
      tabItem(tabName = "data",
              fluidRow(
                box(title = "Tabel Data Panel",
                    status = "primary", solidHeader = TRUE, width = 12,
                    DTOutput("tabel_data"))
              )
      )
    )
  )
)

# ============================================================
# SERVER
# ============================================================
server <- function(input, output, session) {
  
  # Data reaktif berdasarkan filter
  df_filtered <- reactive({
    d <- df |> filter(tahun >= input$tahun[1],
                      tahun <= input$tahun[2])
    if (input$kabupaten != "Semua") {
      d <- d |> filter(kabupaten_kota == input$kabupaten)
    }
    d
  })
  
  # ── VALUE BOXES ────────────────────────────────────────
  output$box_kemiskinan <- renderValueBox({
    val <- round(mean(df_filtered()$kemiskinan_pct, na.rm=TRUE), 2)
    valueBox(paste0(val, "%"), "Rata-rata Kemiskinan",
             icon = icon("people-group"), color = "red")
  })
  
  output$box_ipm <- renderValueBox({
    val <- round(mean(df_filtered()$ipm, na.rm=TRUE), 2)
    valueBox(val, "Rata-rata IPM",
             icon = icon("graduation-cap"), color = "blue")
  })
  
  output$box_tpt <- renderValueBox({
    val <- round(mean(df_filtered()$tpt, na.rm=TRUE), 2)
    valueBox(paste0(val, "%"), "Rata-rata TPT",
             icon = icon("briefcase"), color = "yellow")
  })
  
  output$box_pdrb <- renderValueBox({
    val <- round(mean(df_filtered()$pdrb, na.rm=TRUE), 2)
    valueBox(paste0(val, "%"), "Rata-rata PDRB",
             icon = icon("chart-line"), color = "green")
  })
  
  # ── TREN LINE CHART ────────────────────────────────────
  output$plot_tren <- renderPlotly({
    df_tren <- df_filtered() |>
      group_by(tahun) |>
      summarise(
        Kemiskinan = mean(kemiskinan_pct, na.rm=TRUE),
        IPM        = mean(ipm,            na.rm=TRUE),
        TPT        = mean(tpt,            na.rm=TRUE),
        PDRB       = mean(pdrb,           na.rm=TRUE)
      ) |>
      pivot_longer(-tahun, names_to="Indikator", values_to="Nilai")
    
    p <- ggplot(df_tren, aes(x=tahun, y=Nilai,
                             color=Indikator, group=Indikator)) +
      geom_line(linewidth=1.2) +
      geom_point(size=3) +
      facet_wrap(~Indikator, scales="free_y") +
      scale_x_continuous(breaks=2020:2024) +
      labs(x="Tahun", y="Nilai") +
      theme_classic() +
      theme(legend.position="none")
    
    ggplotly(p)
  })
  
  # ── BAR CHART ──────────────────────────────────────────
  output$plot_bar <- renderPlotly({
    indikator <- input$indikator
    
    df_bar <- df_filtered() |>
      group_by(kabupaten_kota) |>
      summarise(nilai = mean(.data[[indikator]], na.rm=TRUE)) |>
      arrange(desc(nilai)) |>
      head(10)
    
    p <- ggplot(df_bar, aes(x=reorder(kabupaten_kota, nilai),
                            y=nilai, fill=nilai)) +
      geom_col(show.legend=FALSE) +
      geom_text(aes(label=round(nilai,1)), hjust=-0.2, size=3) +
      scale_fill_gradient(low="#a8edea", high="#1a6b8a") +
      coord_flip() +
      labs(x=NULL, y=indikator) +
      theme_classic()
    
    ggplotly(p)
  })
  
  # ── SCATTER PLOT ───────────────────────────────────────
  output$plot_scatter <- renderPlotly({
    p <- ggplot(df_filtered(),
                aes(x=.data[[input$var_x]],
                    y=.data[[input$var_y]],
                    text=kabupaten_kota)) +
      geom_point(aes(color=factor(tahun)), alpha=0.7, size=2.5) +
      geom_smooth(method="lm", se=TRUE, color="black",
                  linewidth=0.8, linetype="dashed") +
      scale_color_brewer(palette="Set1", name="Tahun") +
      labs(x=input$var_x, y=input$var_y) +
      theme_classic()
    
    ggplotly(p, tooltip=c("text", "x", "y"))
  })
  
  # ── TABEL DATA ─────────────────────────────────────────
  output$tabel_data <- renderDT({
    datatable(df_filtered(),
              options = list(pageLength=10, scrollX=TRUE),
              colnames = c("Kabupaten/Kota", "Tahun",
                           "Kemiskinan (%)", "IPM",
                           "TPT (%)", "PDRB (%)"))
  })
}

# ============================================================
# RUN APP
# ============================================================
shinyApp(ui = ui, server = server)