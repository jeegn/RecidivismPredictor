## Only run examples in interactive R sessions
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
          plotOutput(outputId = "result")
        ),
        fluid = TRUE
      )
    ),
    server = function(input, output) {
      source_python('C:\\Users\\jeegn\\OneDrive - purdue.edu\\DURI\\RecidivismPredictor\\predictor.py')
      observe({
        if (input$race=="caucasian") {
          racevector <- c(1, 0, 0)
        } else if (input$race=="hispanic") {
          racevector <- c(0, 1, 0)
        } else if (input$race=="black") {
          racevector <- c(0, 0, 0)
        } else if (input$race=="other") {
          racevector <- c(0, 0, 1)
        }
        
        if (input$employmentStatus=="fulltime") {
          employmentvector <- c(1, 0, 0)
        } else if (input$employmentStatus=="parttime") {
          employmentvector <- c(0, 1, 0)
        } else if (input$employmentStatus=="unemployed") {
          employmentvector <- c(0, 0, 1)
        } else if (input$employmentStatus=="other") {
          employmentvector <- c(0, 0, 0)
        }
        
        if (input$highestEducationLevel=="somecollege") {
          educationvector <- c(0, 0, 1)
        } else if (input$highestEducationLevel=="highschooldiploma") {
          educationvector <- c(1, 0, 0)
        } else if (input$highestEducationLevel=="nohighschooldiploma") {
          educationvector <- c(0, 1, 0)
        } else if (input$employmentStatus=="other") {
          educationvector <- c(0, 0, 0)
        }
        
        if (input$licenseStatus=="suspended") {
          licensestatusvector <- c(0, 1)
        } else if (input$licenseStatus=="notsuspended") {
          licensestatusvector <- c(1, 0)
        } else if (input$licenseStatus=="other") {
          licensestatusvector <- c(0, 0)
        }
        req(input$numPreviousRecidivisms)
        req(input$age)
        req(input$timeInWorkRelease)
        req(input$timeInMonitoring)
        Predictor_Input = c(input$age, 
                            input$numPreviousRecidivisms, 
                            racevector, 
                            input$gender, 
                            input$registeredSexOffender, 
                            input$violentOffender,
                            input$gangMember,
                            input$homeless,
                            input$DNACollected,
                            employmentvector,
                            educationvector,
                            licensestatusvector,
                            input$timeInWorkRelease,
                            input$timeInMonitoring
        )

        output$result <- renderPlot({
          x <- as.numeric(predictor(paste(Predictor_Input, collapse=" ")))
          months <- c("3","6","9","12","15","18","21","24","27","30","33","36")
          b <-barplot(x, main = "Recidivism Probability upto 36 months",
                  xlab="Time in Months", ylab="Recidivism Probability",
                  names.arg=months, col="blue", ylim=c(0,1))
          text(x=b, y=x+0.1,labels=as.character(lapply(x,round,2)))
        })
      })
    }
  )
}