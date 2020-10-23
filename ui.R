dashboardPage(
    dashboardHeader(title = "Mental Health in the Tech Industry", titleWidth = 275),
    
    dashboardSidebar(
        width = 275,
        sidebarMenu(
            menuItem('Introduction', tabName = 'intro'),
            menuItem('Respondents Demographics', tabName = 'respondents'),
            menuItem('Employer Support', tabName = 'employers'),
            menuItem('Survey Questions', tabName = 'survey'),
            menuItem('Survey Questions By Age', tabName = 'byage'),
            menuItem('Survey Questions By Countries', tabName = 'bycountry'),
            menuItem('Survey Questions By Company Size', tabName = 'bycompanysize')
        )),
    
    dashboardBody(tabItems(
        tabItem(
            tabName = 'intro',
            box(
                h1('Exploring Mental Health in Tech Industry', align = 'center'),
                background = 'blue',
                width = 25
            ),
            
            box(
                width = 25,
                p(
                    'Mental health disorders are one of the most burdensome health concerns in the United States. According
                to the CDC, 1 in 5 adults in the U.S. reported having mental illness in 2016. Mental disorders such
                as depression are linked to higher rates of disability and unemployment. In fact, "depression
                interferes with a person’s ability to complete physical job tasks about 20% of the time and reduces
                cognitive performance about 35% of the time." Globally, according to the WHO, about 264 million 
                people suffer from depression. WHO led a study on mental health in the workplace, and discovered that 
                depression and anxiety disorders cost the global economy one trillion U.S. dollars each year in lost
                productivity. There is a good chance that you may know someone affected with mental health disorders in the
                workplace. However, due to the stigma associated with mental health issues, individuals may choose to
                keep their personal challenges to themselves, and thus, they may not seek the help they need. The CDC and WHO
                encourage employers to promote mental health awareness and provide employees with support and resources such
                as low or no cost medical benefits for mental health counseling.',
                    style = 'font-size:16px'
                )
                
            ),
            box(
                width = 25,
                p(
                    'Considering that the tech industry is known to offer great employee benefits and support,
                I chose this dataset to analyze how well the tech industry deal with mental health issues in the workplace.',
                    style = 'font-size:16px'
                ),
                p(
                    'This app was designed to allow you to visualize and answer the following questions regarding mental
                  health in the tech industry: Do they talk openly about mental health in the workplace? Do they provide
                  resources about mental health? Do they provide medical benefits for mental health disorders?
                  Do they take mental health as seriously as physical health? And overall what is the sentiment with 
                  mental health in the workplace among the respondents.',
                    style = 'font-size:16px'
                ),
                p(
                    strong('Respondents Demographics: '),  'to explore the demographics of the survey respondents.',
                    style = 'font-size:16px'
                ),
                p(
                    strong('Employer Support: '), 'to visualize the overall support from employers including formal open discussion,
                    resources, anonymity, and medical benefits for mental health illnesses',
                    style = 'font-size:16px'
                ),
                p(
                    strong('Survey Questions, Survey Questions By Age, Survey Questions By Country, and Survey Questions By Company Size: '),
                    'are tabs that allow you to visualize the attitude towards mental health among the respondents grouped by their
                    age, their country of origin, and their company size.',
                    style = 'font-size:16px'
                )
                ),
            box(
                    width = 25,
                
                p(
                    'The data was obtained from Open Sourcing Mental Illness (OSMI) Mental Health in Tech Survey 2016',
                    style = 'font-size:16px'
                )
                )
            
        ), 
        # Begin Respondents tab
        tabItem(
            tabName = 'respondents',
            p(
                'The majority of respondents were male, between ages 25 to 40, and from the U.S.',
                style = 'font-size:16px'),
            fluidRow(
                splitLayout(style = "border: 1px solid silver:", 
                            plotOutput("respondents.gender"), 
                            plotOutput("respondents.age"))
            ),
            hr(),
            fluidRow(
                splitLayout(style = "border: 1px solid silver:", 
                plotOutput("respondents.country"),
                plotOutput("respondents.state")))
             ), # Close respondents tab
        
        tabItem(
            tabName = 'employers',
            p(
                '51% of the respondents said they have had mental health disorder in the past. 
                40% (at the time they completed the survey) said they currently have mental 
                health disorder, while nearly 23% said they were unsure if they have mental 
                health disorders.',
                style = 'font-size:16px'
            ),
            fluidRow(
                splitLayout(style = "border: 1px solid silver:", 
                            plotOutput("mental.past"), 
                            plotOutput("mental.current"))
                           ),
            hr(),
            p(
                '59% said they sought treatment from a mental health professional. And 50% was
                diagnosed with a mental health condition by a medical professional.',
                style = 'font-size:16px'),
            fluidRow(
                splitLayout(style = "border: 1px solid silver:", 
                            plotOutput("mental.treatment"),
                            plotOutput("mental.diagnosed")
                            )
            ),
            # fluidRow(column(8, plotOutput("USrespondents.mental"))
            # ),
             hr(),
            p('These were percentages of the respondents that knew for sure that they had some form of 
              support from their employers for mental health disorders, which were much lower than 
              I expected. And less than 25% thought that their employers take mental health as
              seriously as physical health. Considering the data was from a 2016 survey, I hope the 
              tech community had improve their numbers since.',
              style = 'font-size:16px'),
            
            fluidRow(
                splitLayout(style = "border: 1px solid silver:", 
                            plotOutput("company.resources"),
                            plotOutput("mental.physical")))

        ), # Close employers tabs
        
        
        # Begin survey question selection
        tabItem(
            tabName = 'survey',
            h2("Responses to Survey Questions"),
            selectInput(
                inputId = "question",
                label = h3("Select a question"),
                choices = question.choices
            ),
            #tags$head(tags$style(HTML(".selectize-input {height: 50px; width: 500px; font-size: 16px;}"))),
            hr(),
            fluidRow(column(8, plotOutput("survey")))
        ), # close tab "survey"
        
        # Begin age group selection
        tabItem(tabName = 'byage',
                h2("Survey Responses According to Age Range"),
                selectInput(
                    inputId = "selected.ageGroup",
                    label = h3("Select an age group"),
                    choices = list(
                        "24 or younger",
                        "25-34",
                        "35-44",
                        "45-54",
                        "55 or older"
                    ),
                    selected = "24 or younger"
                ),
                hr(),
                selectInput(
                    inputId = "age.question",
                    label = h3("Select a survey question"),
                    choices = question.choices
                ),
                hr(),
                fluidRow(column(8, plotOutput("age.group")))
        ), # close tab "byage"
        
        # Begin country selection
        tabItem(
            tabName = 'bycountry',
            h2("Survey Responses from Different Countries"),
            checkboxGroupInput(
                inputId = "selected.country",
                label = h3("Select the Countries You Would Like to Compare"),
                choices = list(
                    "Australia",
                    "Canada",
                    "Germany", 
                    "Netherlands",
                    "United Kingdom",
                    "United States of America"
                ),
               selected = c("United States of America", "Australia")
             ),
            hr(),
            selectInput(
                inputId = "country.question",
                label = h3("Select a survey question"),
                choices = question.choices
            ),
            hr(),
            fluidRow(column(8, plotOutput("countries")))
    ), # close tab "bycountry"
    
    # Begin company size selection
    tabItem(
        tabName = 'bycompanysize',
        h2("Survey Responses According to Company Size"),
        selectInput(
            inputId = "company.size",
            label = h3("Select a company size"),
            #choices = unique(tech.health$no_employees),
            choices = list("1-5", "6-25", "100-500", "500-1000", "More than 1000"),
            selected = "1-5"
        ),
        hr(),
        selectInput(
            inputId = "size.question",
            label = h3("Select a survey question"),
            choices = question.choices
        ),
        hr(),
        fluidRow(column(8, plotOutput("company")))
        ) # close "bycompanysize"
    
    ) # close tabItems
    ) # close dashboardBoday
) # closing dashBoardPage





    
  