library(shiny) 
library(shinydashboard)
library(tidyverse)
library(dplyr)
library(lubridate)
library(ggplot2)
library(stringr)
library(scales)
library(RColorBrewer)
library(maps)
library(reshape2)


tech.health2016 <- read.csv("Tech_Mental_Health2016.csv")
#na.strings = c("", "NA")

# rename columns and select relevant columns
tech.health2016 <-
  tech.health2016 %>% select(.,
    self_employed = Are.you.self.employed.,
    no_employees = How.many.employees.does.your.company.or.organization.have.,
    tech_company = Is.your.employer.primarily.a.tech.company.organization.,
    tech_role = Is.your.primary.role.within.your.company.related.to.tech.IT.,
    mental_health_benefits = Does.your.employer.provide.mental.health.benefits.as.part.of.healthcare.coverage.,
    mental_discussed = Has.your.employer.ever.formally.discussed.mental.health..for.example..as.part.of.a.wellness.campaign.or.other.official.communication..,
    resources = Does.your.employer.offer.resources.to.learn.more.about.mental.health.concerns.and.options.for.seeking.help.,
    anonymity = Is.your.anonymity.protected.if.you.choose.to.take.advantage.of.mental.health.or.substance.abuse.treatment.resources.provided.by.your.employer.,
    leave = If.a.mental.health.issue.prompted.you.to.request.a.medical.leave.from.work..asking.for.that.leave.would.be.,
    mental_health_consequence = Do.you.think.that.discussing.a.mental.health.disorder.with.your.employer.would.have.negative.consequences.,
    physical_health_consequence = Do.you.think.that.discussing.a.physical.health.issue.with.your.employer.would.have.negative.consequences.,
    coworkers = Would.you.feel.comfortable.discussing.a.mental.health.disorder.with.your.coworkers.,
    supervisors = Would.you.feel.comfortable.discussing.a.mental.health.disorder.with.your.direct.supervisor.s..,
    mental_vs_physical = Do.you.feel.that.your.employer.takes.mental.health.as.seriously.as.physical.health.,
    physical_interview = Would.you.be.willing.to.bring.up.a.physical.health.issue.with.a.potential.employer.in.an.interview.,
    mental_interview = Would.you.bring.up.a.mental.health.issue.with.a.potential.employer.in.an.interview.,
    mental_hurt_career = Do.you.feel.that.being.identified.as.a.person.with.a.mental.health.issue.would.hurt.your.career.,
    mental_coworkers_view = Do.you.think.that.team.members.co.workers.would.view.you.more.negatively.if.they.knew.you.suffered.from.a.mental.health.issue.,
    share_family_friends = How.willing.would.you.be.to.share.with.friends.and.family.that.you.have.a.mental.illness.,
    family_history = Do.you.have.a.family.history.of.mental.illness.,
    mental_past = Have.you.had.a.mental.health.disorder.in.the.past.,
    mental_current = Do.you.currently.have.a.mental.health.disorder.,
    mental_diagnosed = Have.you.been.diagnosed.with.a.mental.health.condition.by.a.medical.professional.,
    sought_treatment = Have.you.ever.sought.treatment.for.a.mental.health.issue.from.a.mental.health.professional.,
    interfere_treated = If.you.have.a.mental.health.issue..do.you.feel.that.it.interferes.with.your.work.when.being.treated.effectively.,
    interfere_not_treated = If.you.have.a.mental.health.issue..do.you.feel.that.it.interferes.with.your.work.when.NOT.being.treated.effectively.,
    age = What.is.your.age.,
    gender = What.is.your.gender.,
    country = What.country.do.you.work.in.,
    state = What.US.state.or.territory.do.you.work.in.,
    work_position = Which.of.the.following.best.describes.your.work.position.,
    remote = Do.you.work.remotely.
  )

tech.health <- tech.health2016

# Filter age greater than or equal to 14 and less than or equal to 80
tech.health <- tech.health %>% filter(., age >= 14 & age <= 80 )


# Relabel gender for consistency
# Change first letter to upper in gender
tech.health$gender <- str_to_title(tech.health$gender)
tech.health <- tech.health %>%
  mutate(.,
         gender = case_when(
           gender == "Female" ~ "Female",
           gender == "F" ~ "Female",
           gender == "Cis Female" ~ "Female",
           gender == "Female Cis" ~ "Female",
           gender == "Women" ~ "Female",
           gender == "Male" ~ "Male",
           gender == "M" ~ "Male",
           gender == "Cis Male" ~ "Male",
           gender == "Male Cis" ~ "Male",
           gender == "Man" ~ "Male",
           TRUE ~ "Other"
         )
  )

# Convert blanks to "No Response"
tech.health <- tech.health %>% 
  mutate(.,
         mental_vs_physical = ifelse(mental_vs_physical=='', 'No Response', mental_vs_physical),
         mental_health_benefits = ifelse(mental_health_benefits=='', 'No Response', mental_health_benefits),
         mental_discussed = ifelse(mental_discussed=='', 'No Response', mental_discussed),
         resources = ifelse(resources =='', 'No Response', resources),
         anonymity = ifelse(anonymity=='', 'No Response', anonymity),
         mental_diagnosed = ifelse(mental_diagnosed=='', 'No Response', mental_diagnosed),      
         mental_past = ifelse(mental_past=='', 'No Response', mental_past),   
         mental_current = ifelse(mental_current=='', 'No Response', mental_current),
         mental_health_consequence = ifelse(mental_health_consequence=='', 'No Response', mental_health_consequence),
         physical_health_consequence = ifelse(physical_health_consequence=='', 'No Response', physical_health_consequence),
         coworkers = ifelse(coworkers=='', 'No Response', coworkers),
         supervisors = ifelse(supervisors=='', 'No Response', supervisors),
         no_employees = ifelse(no_employees=='', 'No Response', no_employees),
         age = ifelse(age=='', 'No Response', age))





# Convert 1's and 0's to "Yes" or "No"
tech.health <- tech.health %>%
  mutate(.,
         self_employed = case_when(
           self_employed == 1 ~ "Yes",
           self_employed == 0 ~ "No",
         ),
         tech_company = case_when(
           tech_company == 1 ~ "Yes",
           tech_company == 0 ~ "No",
         ),
         sought_treatment = case_when(
           sought_treatment == 1 ~ "Yes",
           sought_treatment == 0 ~ "No"
         )
  )

# Create new column to group age
tech.health <- tech.health %>% 
  mutate(., 
         age_group = case_when(
           (age < 24) ~ "24 or younger",
           (age >= 25 & age < 35) ~ "25-34",
           (age >= 35 & age < 45) ~ "35-44",
           (age >= 45 & age < 55) ~ "45-54",
           (age >= 55) ~ "55 or older"
  ))


grouped.df <- tech.health %>%
  group_by(country) %>% 
  summarise(ncountry = n()) %>% 
  ungroup()

tech.health <- tech.health %>% inner_join(grouped.df, by = 'country') 
print(head(tech.health))

# List of questions user can choose from 
question.choices = list(
  "Have you had a mental health disorder in the past?",
  "Do you currently have a mental health disorder?",
  "Have you been diagnosed with a mental health condition by a medical professional?",
  "Have you ever sought treatment for a mental health issue from a mental health professional?",
  "Do you think that discussing a mental health disorder with your employer would have negative consequences?",
  "Do you think that discussing a physical health issue with your employer would have negative consequences?",
  "Would you feel comfortable discussing a mental health disorder with your coworkers?",
  "Would you feel comfortable discussing a mental health disorder with your direct supervisor(s)?",
  "Would you bring up a mental health issue with a potential employer in an interview?",
  "Do you feel that being identified as a person with a mental health issue would hurt your career?",
  "Do you think that team members or co-workers would view you more negatively if they knew you suffered from a mental health issue?"
)

# Function to convert the user selected survey question to a column name
survey.question.selected <- function(any.input){
any.input = case_when(
  any.input == "Have you had a mental health disorder in the past?" ~ "mental_past",
  any.input == "Do you currently have a mental health disorder?" ~ "mental_current",
  any.input == "Have you been diagnosed with a mental health condition by a medical professional?" ~ "mental_diagnosed",
  any.input == "Have you ever sought treatment for a mental health issue from a mental health professional?" ~ "sought_treatment",
  any.input == "Do you think that discussing a mental health disorder with your employer would have negative consequences?" ~ "mental_health_consequence",
  any.input == "Do you think that discussing a physical health issue with your employer would have negative consequences?" ~ "physical_health_consequence",
  any.input == "Would you feel comfortable discussing a mental health disorder with your coworkers?" ~ "coworkers",
  any.input == "Would you feel comfortable discussing a mental health disorder with your direct supervisor(s)?" ~ "supervisors",
  any.input == "Would you bring up a mental health issue with a potential employer in an interview?" ~ "mental_interview",
  any.input == "Do you feel that being identified as a person with a mental health issue would hurt your career?" ~ "mental_hurt_career",
  any.input == "Do you think that team members or co-workers would view you more negatively if they knew you suffered from a mental health issue?" ~ "mental_coworkers_view"
)
}

# Create a donut chart of gender distribution of survey respondents
gender.graph <- function(df){
gender.df <- df %>% group_by(., gender) %>% count(.,)
gender.df$per <- round(gender.df$n/sum(gender.df$n),2)
gender.df$ymax <- cumsum(gender.df$per)
gender.df$ymin <- c(0, head(gender.df$ymax, n=-1))
gender.df$labelPosition <- (gender.df$ymax + gender.df$ymin) / 2
gender.df$label <- paste0(gender.df$gender, "\n", percent(gender.df$per))

final.gender.graph <- ggplot(data = gender.df, aes(ymax=ymax, ymin=ymin, xmax=4, xmin=3, fill = gender)) +
    geom_rect() +
    geom_text(x = 3.5, aes(y = labelPosition, label = label), size=4.5) +
    scale_fill_manual(values = c("#99CC66", "#339999", "#FF9966")) +
    coord_polar(theta = "y") +
    xlim(c(2,4)) +
    theme_void() +
    theme(legend.position = "none") +
    ggtitle("Gender of Survey Respondents")

return(final.gender.graph)
}


# Function to chart for mental health issues in the past
mentalPast <- function(df){
pie.chart <- df %>%
  group_by(., mental_past) %>%
  count() %>%
  ungroup() %>%
  mutate(per=`n`/sum(`n`)) %>%
  arrange(desc(per))
pie.chart$label <- percent(pie.chart$per)

ggplot(data=pie.chart) +
  geom_bar(aes(x="", y=per, fill=mental_past), stat="identity") +
  coord_polar("y", start=0)+
  scale_fill_manual(values = c("#99CC66", "#339999", "#FF9966")) +
  theme_void()+
  guides(fill=guide_legend(title="Response")) +
  geom_text(aes(x=1, y = cumsum(per) - per/2, label=label), size=5) +
  ggtitle("Have you had a mental health disorder in the past?")
}

# Function to chart for mental health issues currently
mentalCurrent <- function(df){
  pie.chart <- df %>%
    group_by(., mental_current) %>%
    count() %>%
    ungroup() %>%
    mutate(per=`n`/sum(`n`)) %>%
    arrange(desc(per))
  pie.chart$label <- percent(pie.chart$per)
  
  ggplot(data=pie.chart) +
    geom_bar(aes(x="", y=per, fill=mental_current), stat="identity") +
    coord_polar("y", start=0)+
    scale_fill_manual(values = c("#99CC66", "#339999", "#FF9966")) +
    theme_void()+
    guides(fill=guide_legend(title="Response")) +
    geom_text(aes(x=1, y = cumsum(per) - per/2, label=label), size=5) +
    ggtitle("Do you currently have a mental health disorder?")
}

# Function to chart for if they were diagnosed by a health professional
mentalDiagnosed <- function(df){
  pie.chart <- df %>%
    #filter(., sought_treatment == "Yes") %>% 
    group_by(., mental_diagnosed) %>%
    count() %>%
    ungroup() %>%
    mutate(per=round(`n`/sum(`n`),1)) %>%
    arrange(desc(per))
  pie.chart$label <- percent(pie.chart$per)
  
  ggplot(data=pie.chart) +
    geom_bar(aes(x="", y=per, fill=mental_diagnosed), stat="identity") +
    coord_polar("y", start=0)+
    scale_fill_manual(values = c("#99CC66", "#339999", "#FF9966")) +
    theme_void()+
    guides(fill=guide_legend(title="Response")) +
    geom_text(aes(x=1, y = cumsum(per) - per/2, label=label), size=5) +
    ggtitle("Have you been diagnosed with a mental health condition by a medical professional?")
}

# Function to chart for if they had sought treatment
mentalTreatment <- function(df){
  pie.chart <- df %>%
    group_by(., sought_treatment) %>%
    count() %>%
    ungroup() %>%
    mutate(per=`n`/sum(`n`)) %>%
    arrange(desc(per))
  pie.chart$label <- percent(pie.chart$per)
  
  ggplot(data=pie.chart) +
    geom_bar(aes(x="", y=per, fill=sought_treatment), stat="identity") +
    coord_polar("y", start=0)+
    scale_fill_manual(values = c("#99CC66", "#339999", "#FF9966")) +
    theme_void()+
    guides(fill=guide_legend(title="Response")) +
    geom_text(aes(x=1, y = cumsum(per) - per/2, label=label), size=5) +
    ggtitle("Have you ever sought treatment for a mental health issue from a mental health professional?")
}

# Creat a chart that evaluates if tech industry offer the nessary support
# Compare different resources for mental health
total.resources <- function(df){
  resources.summary <- tech.health %>% 
    summarise(., Benefits = sum(mental_health_benefits == "Yes")/nrow(tech.health)*100,
              Resources = sum(resources == "Yes")/nrow(tech.health)*100,
              Discussion = sum(mental_discussed == "Yes")/nrow(tech.health)*100,
              Anonymity = sum(anonymity == "Yes")/nrow(tech.health)*100
              
    ) 
  resources.summary <- as.data.frame(t(resources.summary))
  resources.summary<- resources.summary %>% rownames_to_column("mental.resources")
  resources.summary <- rename(resources.summary, percent.yes = "V1")
  resources.summary %>%  
    ggplot(., aes(x = mental.resources, y = percent.yes)) + 
    geom_bar(aes(fill = mental.resources), stat = "identity") + 
    scale_fill_manual(values = c("#003366", "#339999", "#FF9966", "#99CC66")) +
    ggtitle("Mental Health Support") +
    theme_bw() +
    xlab("") +
    ylab("Percent") +
    coord_cartesian(ylim = c(0, 100), expand = FALSE) +
    theme( axis.ticks=element_blank()) +
    theme(legend.position = "none")
}

# Function to chart for if they feel their employers take mental health as
# seriously as physical health
mental.vs.physical <- function(df){
  df %>% 
    group_by(., mental_vs_physical) %>%
    count() %>%
    ungroup() %>%
    mutate(per=`n`/sum(`n`)*100) %>%
    arrange(desc(per)) %>%
    ggplot(., aes(x = mental_vs_physical, y = per)) + 
    geom_bar(aes(fill = mental_vs_physical), position = "dodge", stat = 'identity') + 
    scale_fill_manual(values = c("#003366", "#339999", "#FF9966", "#99CC66","#FFCC99")) +
    theme_bw() +
    theme(legend.position = "none") +
    xlab("") +
    ylab("Percent") +
    coord_cartesian(ylim = c(0, 100), expand = FALSE) +
    ggtitle("Do you feel that your employer takes mental health as seriously as physical health?")
}

# Map of people in the U.S. diagnosed with mental health issues
mental.map <- function(df){
  map <- map_data('state')
  final.mental.map <- df %>% 
    filter(., country == "United States of America" & (mental_past == "Yes" | mental_current == "Yes" | mental_diagnosed == "Yes")) %>% 
    group_by(., state) %>% 
    summarise(., no_surveyees = n()) %>% 
    mutate(., state_lowcase = tolower(state)) %>% 
    ggplot(.,) +
    geom_map(map =map, aes(map_id=state_lowcase, fill=no_surveyees), color='gray') + expand_limits(x=map$long, y=map$lat) + scale_fill_continuous(high="red", low="white") +
    theme_bw() +
    theme(panel.grid.major = element_blank(),
          panel.background = element_blank(),
          axis.text=element_blank(), axis.ticks=element_blank(), axis.title=element_blank(), legend.position = c(0.90,0.25), legend.background=element_rect(fill="white", colour="white") ) + coord_map('mercator') +
    labs(title='Number of Respondents with Mental Health Illness in the U.S.') +
    guides(fill=guide_legend(title= "Respondents"))
  return(final.mental.map)
}



