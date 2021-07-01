## Art Woods Thermal Project Shiny App ##
library("shiny")

#sourcing script for function calls
#source("C:/Users/Jonathan/Documents/GitHub/ThermalAspen/Jonathan Scripts/R/thermal.r")

#print(test)

# Define UI for miles per gallon app ----
ui <- pageWithSidebar(
  
  # App title ----
  headerPanel("Art Woods | Thermal Imagery | version 0.1"),
  
  # Sidebar panel for inputs ----
  sidebarPanel(
    fileInput("inputfolder", "Choose Thermal Imagery Input Folder"),
    fileInput("outputfolder", "Choose Thermal Imagery Output Folder")
  ),
  
  # Main panel for displaying outputs ----
  mainPanel()
)


server <- function(input, output) {
  output$contents <- renderTable({
    # input$file1 will be NULL initially. After the user selects
    # and uploads a file, it will be a data frame with 'name',
    # 'size', 'type', and 'datapath' columns. The 'datapath'
    # column will contain the local filenames where the data can
    # be found.
    inFile <- input$file1
    
    if (is.null(inFile))
      return(NULL)
    
    read.csv(inFile$datapath, header = input$header)
  })
}
# Define server logic to plot various variables against mpg ----
server <- function(input, output) {
  
  
  inputlist <- list.files(inputfolder)
  outputlist <- list.files(outputfolder)
  write.csv(inputlist)
  write.csv(outputlist)
}

shinyApp(ui, server)

