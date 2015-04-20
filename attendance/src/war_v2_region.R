## ----knitr_opts, include=FALSE-------------------------------------------
require(knitr)
opts_chunk$set(echo=FALSE, 
               warning=FALSE,
               message=FALSE,
               cache=FALSE
               )


mandrill_content_hook<-function(before, options, envir){
  if(!before){

    #after chunk add these lines
    return(sprintf('<div mc:edit="%s">%s</div>', options$label, options$label))
    opts_chunk$set(results='show')
  }
}

knit_hooks$set(mandrill.content = mandrill_content_hook)


## ----load_packages-------------------------------------------------------
require(dplyr)
require(ggplot2)
require(lubridate)
require(tidyr)
require(readr)

source("../lib/helpers.R")

## ----create_time_stamp---------------------------------------------------

restart_time<-file.info('../data//Attendance.csv')$mtime

time_stamp<-lubridate::stamp("Attendance data as of Tuesday, September 14, 2001 at 4:41 pm")(restart_time)

## ----time_stamp, mandrill.content=TRUE, results='hide'-------------------
time_stamp

## ----load_and_munge_data-------------------------------------------------
attendance <- read_csv(file="../data/Attendance.csv",
                       col_types="iiciciiccccii")

names(attendance)<-tolower(names(attendance))

schoolintials <- c("KAP", "KAMS", "KCCP", "KBCP")

schools = data.frame(schoolid=c(78102, 7810, 400146, 400163),
                     schoolname=factor(schoolintials, levels=schoolintials),
                     ada_target=c(.95,.95,.95,.94)
                     )

att <- attendance %>% left_join(schools, by="schoolid") %>%
  mutate(present=1-absent,
         date=ymd_hms(calendardate),
         month=month(date,label = TRUE, abbr = TRUE),
         week_of=floor_date(date, unit="week"),
         week = (week_of - min(week_of))/dweeks(1) +1,
         day_of_week = wday(date,label = TRUE, abbr=TRUE)
         ) %>%
  filter(date!=mdy('01/09/2015')) # day removed by CPS due to cold tempuratures
          

att_by_day <- att %>%
  group_by(date, week, day_of_week, schoolname, ada_target) %>%
  summarize(
            sum_enrolled=sum(enrolled),
            sum_present = sum(present),
            sum_absent=sum_enrolled-sum_present,
            ada = sum_present/sum_enrolled) %>%
  group_by(schoolname) %>%
  mutate(deviation=ada-.96,
         cum_enrolled=order_by(date, cumsum(sum_enrolled)),
         cum_present=order_by(date, cumsum(sum_present)),
         ytd_ada = cum_present/cum_enrolled,
         day_in_sy = row_number(date))


ada_targets<-with(att_by_day, 
     max_daily_absent(current_day = day_in_sy, 
                      total_days = 188,
                      enrollment = sum_enrolled,
                      current_ada = ytd_ada, 
                      target_ada=ada_target
                        )
     )

att_by_day_w_targets<-cbind(att_by_day, ada_targets)

max_date <- max(att_by_day_w_targets$date)

remaining_sy<-data.frame(date=seq(today()+days(1),as.Date("2015-06-18"), by="day")) %>%
  mutate(day=wday(date)) %>%
  filter(day %in% c(2:6))

year_extended<-expand.grid(schoolid=schools$schoolid, date=remaining_sy$date, stringsAsFactors = FALSE) %>%
  left_join(schools, by="schoolid")

last_att_day_data<-filter(att_by_day_w_targets, date==max(date))

year_projected<-left_join(year_extended, last_att_day_data, by="schoolname") %>%
  select(-date.y, -ada_target.x) %>%
  rename(ada_target = ada_target.y,
         date=date.x) %>%
  mutate(date=ymd(date),
         week=week + week(floor_date(date, unit='week'))-min(week(date))+1,
         day_of_week = wday(date, label = TRUE, abbr = TRUE),
         sum_enrolled = NA,
         sum_presenet =NA,
         sum_absent = NA,
         ada=NA,
         deviation=NA,
         cum_enrolled=NA,
         cum_present=NA,
         ytd_ada=NA,
         enrollment=NA) %>%
  group_by(schoolname) %>%
  mutate(day_in_sy=day_in_sy+row_number(day_in_sy))
         
  
att_by_day_w_targets_projected  <-rbind_list(att_by_day_w_targets, year_projected) 



## ----weather-------------------------------------------------------------
keys<-as.data.frame(read.dcf("../config//keys.dcf"))


request_string<-sprintf(
  'https://api.forecast.io/forecast/%s/41.85834,-87.72178?extend=hourly',
  keys$forecastio_key
  )

forecast<-httr::GET(url = request_string)


forcast_8day<-httr::content(forecast)
forecast_dfs_list<-lapply(forcast_8day$hourly$data, as.data.frame)

forecast_df<-rbind_all(forecast_dfs_list) %>%
  mutate(date=ymd_hms(as.POSIXct(time, origin="1970-01-01")),
         hour=hour(date),
         date=ymd(strptime(ymd_hms(date), format="%Y-%m-%d")),
         temp=ifelse(apparentTemperature>90, "Very Hot", NA),
         temp=ifelse(apparentTemperature<15, "Very Cold", temp),
         precip=ifelse(precipType=="rain"&precipProbability>=.3, "Rain Likely", NA),
         precip=ifelse(precipType=="snow"&precipProbability>=.3, "Snow Likely", precip),
         precip=ifelse(precipType=="sleet"&precipProbability>=.3, "Wintry Mix Likely", precip)) %>%
  filter(hour==7) %>%
  select(date, temp, precip, precipIntensity)

att_by_day_w_targets_projected_weather<-left_join(att_by_day_w_targets_projected, 
                                                  forecast_df, 
                                                  by="date") %>%
  mutate(fill=ifelse(sum_absent>max_absent, "Missed", NA),
         fill=ifelse(sum_absent<=max_absent, "Made", fill),
         fill=ifelse(!is.na(precip), precip, fill),
         fill=ifelse(is.na(fill), "No Precip. Expected", fill),
         alpha=1,
         alpha=ifelse(!is.na(precip), precipIntensity, alpha),
         color=ifelse(!is.na(temp), temp, "Normal Temps"),
     week_of = floor_date(date, unit = "week") ,
     week_of = paste("Week of", 
                     month(week_of, label = TRUE, abbr = TRUE),
                     day(week_of)
                     )
     )

week_ofs <- att_by_day_w_targets_projected_weather %>%
  select(week_of, week) %>% unique
  
att_by_day_w_targets_projected_weather <- att_by_day_w_targets_projected_weather %>%
  mutate(week_of=factor(week_of, levels=week_ofs$week_of))


## ----ada_targets_plot_new, echo=FALSE, fig.width=11,fig.height=7.86------
two_weeks_ago<-floor_date(today(), unit="week") - weeks(4)
one_week_forward<-floor_date(today(), unit="week") + weeks(1)


plot_att_goals(att_by_day_w_targets_projected_weather, two_weeks_ago, one_week_forward)

## ----ada_targets_plot_KAP, echo=FALSE, fig.width=11,fig.height=4---------
plot_att_goals(att_by_day_w_targets_projected_weather, 
               two_weeks_ago, 
               one_week_forward,
               schoolname=="KAP")

## ----ada_targets_plot_KAMS, echo=FALSE, fig.width=11,fig.height=4--------
plot_att_goals(att_by_day_w_targets_projected_weather, 
               two_weeks_ago, 
               one_week_forward,
               schoolname=="KAMS")

## ----ada_targets_plot_KCCP, echo=FALSE, fig.width=11,fig.height=4--------
plot_att_goals(att_by_day_w_targets_projected_weather, 
               two_weeks_ago, 
               one_week_forward,
               schoolname=="KCCP")

## ----ada_targets_plot_KBCP, echo=FALSE, fig.width=11,fig.height=4--------
plot_att_goals(att_by_day_w_targets_projected_weather, 
               two_weeks_ago, 
               one_week_forward,
               schoolname=="KBCP")

## ----target_table_html, echo=FALSE, results='hide', mandrill.content=TRUE----

require(xtable)
target_table<-last_att_day_data %>%
  mutate(ytd_ada=round(ytd_ada*100,1),
         target_ada=round(target_ada*100,1),
         rate_needed=round(rate_needed*100,1)
         ) %>%
  select(School=schoolname, 
         "YTD ADA" = ytd_ada,
         "Target ADA" = target_ada,
         "ADA needed" = rate_needed,
         "Max Absent Daily" =max_absent)
  
  



target_table_html<-print(xtable(target_table, align=c("llrrrr")), 
                         type = "html", 
                         include.rownames = F,  
                         html.table.attributes="class='table table-bordered'",
                         print.results=FALSE)

kable(target_table)


## ----mandrill, eval=FALSE------------------------------------------------
## 
## email_data<-read.dcf("../config//email.dcf", all = TRUE) %>% as.data.frame
## rcpts<-strsplit(email_data$recipients, '\\s*,\\s*')[[1]]
## 
## mandrill_send_template(api_key = keys$mandrill_key,
##                        recipient = rcpts,
##                        subject = "Weekly Attendacne Report version 2",
##                        template_name = "war-test",
##                        sender="data@kippchicago.org",
##                        content=list(target_table=target_table_html),
##                        images=figs,
##                        css=TRUE
## )
## 
## 



   ## Collect figures ####
   
   figs<-list.files('figure/')
   figs<-paste0('figure/', figs)
   
              
