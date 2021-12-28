library(reticulate)
library(shiny)
if (interactive()) {
  
  # basic example
  shinyApp(
    ui = fluidPage(
      sidebarLayout(
        sidebarPanel(
          titlePanel("Select Characteristics"),
          numericInput("age", "Age:", 30, min = 1, max = 100),
          numericInput("numPreviousRecidivisms", "Number of Previous Recidivisms:", 0, min = 0, max = 100),
          selectInput("race", "Race:",
                      c("Caucasian" = "caucasian",
                        "Hispanic" = "hispanic",
                        "Black" = "black",
                        "Other" = "other")),
          selectInput("gender", "Gender:",
                      c("Male" = "1",
                        "Female" = "0"
                      )
          ),
          selectInput("registeredSexOffender", "Registered Sex Offender:",
                      c("Yes" = "1",
                        "No" = "0"
                      )
          ),
          selectInput("violentOffender", "Violent Offender:",
                      c("Yes" = "1",
                        "No" = "0"
                      )
          ),
          selectInput("gangMember", "Gang Member:",
                      c("Yes" = "1",
                        "No" = "0"
                      )
          ),
          selectInput("homeless", "Homeless:",
                      c("Yes" = "1",
                        "No" = "0"
                      )
          ),
          selectInput("DNACollected", "DNA Collected",
                      c("Yes" = "1",
                        "No" = "0"
                      )
          ),
          selectInput("employmentStatus", "Employment Status",
                      c("Full Time" = "fulltime",
                        "Part Time" = "parttime",
                        "Unemployed" = "unemployed",
                        "Other" = "other"
                      )
          ),
          selectInput("highestEducationLevel", "Highest Education Level",
                      c("Some College" = "somecollege",
                        "High School Diploma" = "highschooldiploma",
                        "No High School Diploma" = "nohighschooldiploma",
                        "Other" = "other"
                      ),
          ),
          selectInput("licenseStatus", "License Status",
                      c("Suspended" = "suspended",
                        "Not Suspended" = "notsuspended",
                        "Other" = "other"
                      )
          ),
          numericInput("timeInWorkRelease", "Time In Work Release:", 10, min = 1, max = 100),
          numericInput("timeInMonitoring", "Time In Monitoring:", 10, min = 1, max = 100),
          width = 3
        ),
        mainPanel(
          titlePanel("Results"),
          textOutput("headers"),
          textOutput("result")
        ),
        fluid = TRUE
      )
    ),
    server = function(input, output) {
      
    }
  )
}