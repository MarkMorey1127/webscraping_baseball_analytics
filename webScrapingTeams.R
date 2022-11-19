rm(list = ls())

#install.packages("XML")
#install.packages("RCurl")

library(rvest)
library(tidyverse)

#stats Urls
#https://www.baseball-reference.com/teams/TBR/2020.shtml
#https://www.baseball-reference.com/teams/BOS/2020.shtml
#https://www.baseball-reference.com/teams/NYY/2020.shtml
#https://www.baseball-reference.com/teams/TOR/2020.shtml"


#salary urls
#https://www.spotrac.com/mlb/tampa-bay-rays/payroll/2020/
#https://www.spotrac.com/mlb/boston-red-sox/payroll/2020/
#https://www.spotrac.com/mlb/new-york-yankees/payroll/2020/
#https://www.spotrac.com/mlb/toronto-blue-jays/payroll/2020

#grabbing the batting stats table

url2 = "https://www.baseball-reference.com/teams/BAL/2020.shtml"

baseball = url2 %>%
  read_html() %>%
  html_nodes(xpath = '//*[@id="team_batting"]') %>%
  html_table(fill = TRUE)


baseballData = baseball[[1]]

#removing asterisk from some players names
baseballData$Name = str_replace(baseballData$Name,"\\*",'')



#grabbing pitching stats table

pitching = url2 %>%
  read_html() %>%
  html_nodes(xpath = '//*[@id="team_pitching"]') %>%
  html_table(fill = TRUE)

pitching2 = pitching[[1]]

pitching2$Name = str_replace(pitching2$Name,"\\*",'')

pitching2$Pos[pitching2$Pos== ""] <- "NA"

pitching2$Pos = str_replace(pitching2$Pos,"NA",'RP')

#grabbing Salary Data

salaries = "https://www.spotrac.com/mlb/baltimore-orioles/payroll/2020/"

staffSalaries = salaries %>%
  read_html() %>%
  html_nodes(xpath = '//*[@id="main"]/div/div[4]/table[1]') %>%
  html_table(fill = TRUE)


salaryData = staffSalaries[[1]]
names(salaryData)[1] = "ActivePlayers" #changing first col for multipurpose use

playerNames1 = salaryData$ActivePlayers #grabbing players names

#removing extra name in the players names 
playerNames2 = playerNames1 %>% 
  str_replace_all("\t","") %>%
  str_replace_all("\n"," ") %>%
  str_split("  ") %>%
  unlist() %>%
  unlist() 

#grab every other index now that is has doubled for players names
salaryData$ActivePlayers = playerNames2[c(FALSE,TRUE)]

#Add in Team Name to each dataset
baseballData$Team = "BAL"
pitching2$Team = "BAL"
salaryData$team = "BAL"

#removing non player rows

#batterStats = subset(baseballData, grepl("Name",baseballData$Name) == FALSE) %>%
              #subset(baseballData, grepl("Team",baseballData$Name) == FALSE) %>%
              #subset(baseballData, grepl("Rank",baseballData$Name) == FALSE)


#pitchingSats = pitching2[grepl("Team",pitching2$Name,)==FALSE,] %>%
               #pitching2[grepl("Name",pitching2$Name,)==FALSE,] %>%
              # pitching2[grepl("Rank",pitching2$Name,)==FALSE,]

#subset(pitching2, grepl("Team",pitching2$Name,)==FALSE)
#subset(pitching2, grepl("Rank",pitching2$Name,)==FALSE)


#Exporting to text file for tableau
write.csv(baseballData, "C:/Users/morey/OneDrive/Documents/ism6419/Final Project/Data/BaltimoreBatters.csv")
write.csv(pitching2, "C:/Users/morey/OneDrive/Documents/ism6419/Final Project/Data/BaltimorePitchers.csv")
write.csv(salaryData, "C:/Users/morey/OneDrive/Documents/ism6419/Final Project/Data/BaltimoreSalary.csv")


