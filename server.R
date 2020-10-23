function(input, output) {

# About the respondents
    output$respondents.gender <- renderPlot(
        gender.graph(tech.health)
    )
    
    output$respondents.age <- renderPlot(
        age.graph(tech.health)
    )
    
    output$respondents.country <- renderPlot(
        countries.graph(tech.health)
    )
    
    output$respondents.state <- renderPlot(
        states.graph(tech.health)
    )
    
# Graphs to determine how the tech community responds to mental health
    output$mental.past <- renderPlot(
        mentalPast(tech.health)
    )
    output$mental.current <- renderPlot(
        mentalCurrent(tech.health)
    )
    output$mental.diagnosed <- renderPlot(
        mentalDiagnosed(tech.health)
    )
    output$mental.treatment <- renderPlot(
        mentalTreatment(tech.health)
    )
    output$company.resources <- renderPlot(
        total.resources(tech.health)
    )
    
    output$mental.physical <- renderPlot(
        mental.vs.physical(tech.health)
    )
    output$USrespondents.mental <- renderPlot(
        mental.map(tech.health)
    )
    
# Generate graphs of selected survey question
    survey.question <- reactive({
        survey.question.selected(input$question)
    })
    
    output$survey <- renderPlot(
        ggplot(data = tech.health, aes(x = get(survey.question()))) + 
            geom_bar(aes(fill = get(survey.question())), position = "dodge") + 
            scale_fill_manual(name = "", values = c("#003366", "#339999", "#FF9966", "#99CC66","#FFCC99")) +
            xlab("") +
            ylab("Number of Respondents") +
            coord_cartesian(ylim = c(0, 1000), expand = FALSE) +
            theme_bw()
    )
    
# Generate graphs according to selected age group
    ageGroup.selection <- reactive({
        tech.health %>% 
            filter(., age_group == input$selected.ageGroup)
    })
    
    ageGroup.survey.question <- reactive({
        survey.question.selected(input$age.question)
    })
    
    output$age.group <- renderPlot(
        ageGroup.selection() %>% 
            ggplot(., aes(x = age_group)) +
            geom_bar(aes(fill = get(ageGroup.survey.question())), position = "dodge") + 
            scale_fill_manual(name = "", values = c("#003366", "#339999", "#FF9966", "#99CC66","#FFCC99")) +
            theme( axis.ticks=element_blank()) +
            xlab("Age Group") +
            ylab("Number of Respondents") +
            theme_bw()
    )
    
# Generate graphs according selected country
    countries.selection <- reactive({
        tech.health %>% 
            filter(., country ==  input$selected.country[1]  | country == input$selected.country[2] | country == input$selected.country[3] | country == input$selected.country[4] | country == input$selected.country[5])
    })
    
    countries.survey.question <- reactive({
        survey.question.selected(input$country.question)
    })

    output$countries <- renderPlot(
        countries.selection() %>%
            group_by_(., 'country', countries.survey.question()) %>%
            count() %>%
            group_by(country) %>%
            mutate(per= round(n/sum(n)*100,2)) %>%
            ggplot(., aes(x=country, y=per)) +
            geom_bar(aes(fill=get(countries.survey.question())), stat="identity") +
            scale_fill_manual(name = "", values = c("#003366", "#339999", "#FF9966", "#99CC66","#FFCC99")) +
            coord_cartesian(ylim = c(0, 100), expand = FALSE) +
            theme_bw() +
            xlab("") +
            ylab("Percent") +
            guides(fill=guide_legend(title=""))
    )
    
   # my_min <- 1
    my_max <- 6
    observe({
        if(length(input$selected.country) > my_max){
            updateCheckboxGroupInput(session, "selected.country", selected= tail(input$countries,my_max))
        }
        # if(length(input$selected.country) < my_min){
        #     updateCheckboxGroupInput(session, "selected.country", selected= "a1")
        # }
    })
    
# Generate graphs according to  selected company size
    company.size.selection <- reactive({
        tech.health %>% 
            filter(., no_employees == input$company.size) 
    })
    
    company.survey.question <- reactive({
        survey.question.selected(input$size.question)
    })
    
    output$company<- renderPlot(
        company.size.selection() %>% 
            ggplot(., aes(x = no_employees)) +
            geom_bar(aes(fill = get(company.survey.question())), position = "dodge") + 
            scale_fill_manual(name = "", values = c("#003366", "#339999", "#FF9966", "#99CC66","#FFCC99")) +
            theme( axis.ticks=element_blank()) +
            xlab("Company Size") +
            ylab("Number of Respondents") +
            theme_bw()
    )
}
