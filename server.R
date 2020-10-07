function(input, output) {

# About the respondents
    output$respondents.gender <- renderPlot(
        gender.graph(tech.health)
    )
    
    output$respondents.age <- renderPlot(
        ggplot(data = tech.health, aes(x = gender, y = age)) + 
            geom_boxplot() +
            scale_fill_manual(values = c("#003366", "#339999","#99CC66")) +
            coord_cartesian(ylim = c(0, 80)) +  
            theme_bw() +
            xlab("") +
            ylab("Age") +
            theme(legend.position = "none") +
            ggtitle(("Age Distribution"))
    )
    
    output$respondents.country <- renderPlot(
        tech.health %>% 
            group_by(., country) %>% 
            summarise(.,representation = n()) %>% 
            filter(., representation >= 30) %>% 
            ggplot(., aes(x=reorder(country, desc(-representation)), y=representation)) +
            geom_bar(fill='#3C72BD', stat='identity', colour='#3C72BD') + 
            theme_bw() +
            theme(legend.position = "none") +
            xlab("Country") +
            ylab("Number of Respondents") +
            ggtitle("Respondents from Each Country") 
            # theme_economist() + 
            # scale_fill_economist()
    )
    
    output$respondents.state <- renderPlot(
        tech.health %>% 
            filter(., country == "United States of America") %>% 
            group_by(., state) %>% 
            summarise(., no_surveyees = n()) %>% 
            filter(.,no_surveyees >= 30) %>% 
            ggplot(., aes(x=no_surveyees, y=reorder(state, desc(-no_surveyees)))) + 
            geom_bar(fill='#3C72BD', stat='identity', colour='#3C72BD') + 
            theme_bw() +
            theme(legend.position = "none") +
            xlab("Number of Respondents") +
            ylab("State") +
            #scale_fill_manual(name = "", values = c("#003366", "#339999","#99CC66", "#003366", "#339999","#99CC66", "#003366", "#339999","#99CC66")) +
            ggtitle("Respondents from Each State") 
            # theme_economist() + 
            # scale_fill_economist()
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
        # input$selected.country
        tech.health %>% 
            filter(., country ==  input$selected.country[1]  | country == input$selected.country[2] | country == input$selected.country[3] | country == input$selected.country[4] | country == input$selected.country[5])
    })
    
    countries.survey.question <- reactive({
        survey.question.selected(input$country.question)
    })


    # output$countries <- renderPlot(
    #     #compare.countries(tech.health, get(countries.selection()), get(countries.survey.question()))
    #     countries.selection() %>%
    #         group_by(., country, get(countries.survey.question())) %>%
    #         summarise(., n = n(), ncountry = max(ncountry)) %>%
    #         ungroup() %>% 
    #         # # group_by(country) %>%
    #         mutate(per= round(n/ncountry*100,1)) %>%
    #         ggplot(., aes(x=country, y=per)) +
    #         geom_bar(aes(fill=get(countries.survey.question())), stat = 'identity') +
    #         scale_fill_manual(name = "", values = c("#003366", "#339999", "#FF9966", "#99CC66","#FFCC99")) +
    #         #coord_cartesian(ylim = c(0, 100), expand = FALSE) +
    #         theme_bw() +
    #         xlab("") +
    #         #ylab("Percent") +
    #         guides(fill=guide_legend(title=""))
    # )
    
    output$countries <- renderPlot(
        #compare.countries(tech.health, get(countries.selection()), get(countries.survey.question()))
        countries.selection() %>%
            group_by(., country, get(countries.survey.question())) %>%
            #summarise(., n = n()) %>%
            #mutate(per= round(n/ncountry*100,1)) %>%
            ggplot(., aes(x=country)) +
            geom_bar(aes(fill=get(countries.survey.question()))) +
            scale_fill_manual(name = "", values = c("#003366", "#339999", "#FF9966", "#99CC66","#FFCC99")) +
            #coord_cartesian(ylim = c(0, 100), expand = FALSE) +
            theme_bw() +
            xlab("") +
            #ylab("Percent") +
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



