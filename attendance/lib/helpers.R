max_daily_absent <- function(current_day,
                             total_days=183,
                             enrollment,
                             current_ada,
                             target_ada) {
  
  w1 <- current_day/total_days # weight one
  w2 <- 1-w1 # weight two
  
  rate_needed <- (target_ada - (w1*current_ada))/w2
  rate_needed <- ifelse(rate_needed>1, NA, rate_needed)
  total_attending_needed <- ceiling(enrollment*rate_needed)
  max_absent <- enrollment - total_attending_needed
  
  out_df<-data.frame(current_ada, 
                     target_ada, 
                     rate_needed, 
                     enrollment, 
                     max_absent)
  
  # return
  out_df
  


}


create_mandrill_template <- function (rmd, css_file=NULL) {
  
  
  rmd_html <- gsub(".\\w+$", ".html", rmd)
  rmd_src <- gsub(".\\w+$", ".R", rmd)
  rmd_html_tmpl <- gsub(".\\w+$", ".html_template", rmd)
  
  
  message(paste("1. Knitting", rmd, "to", rmd_html))
  knitr::knit2html(rmd, 
                   quiet=TRUE,
                   options=c("use_xhtml","smartypants","mathjax","highlight_code"),
                   fragment.only=TRUE
  )
  
  
  
  message(paste("2. Purling", rmd, "to", rmd_src))
  knitr::purl(rmd)
  
  
  message(paste("3. Converting", rmd_html, "to Mandrill template", rmd_html_tmpl))
  tmpl_in <- readr::read_lines(rmd_html)
  
  tmpl_out <- gsub("figure/", "cid:", tmpl_in) #replace leading figure iwht cid: tag
  tmpl_out <- gsub(".png", "", tmpl_out) #remove trailing .png from figures 
  tmpl_out <- gsub('alt=.+"',
                   '', 
                   tmpl_out)
  
  message(paste("4. Saving template file to", rmd_html_tmpl))
  if(!missing(css_file)){
    write(css_file, file=rmd_html_tmpl)
    write(tmpl_out, file=rmd_html_tmpl, append = TRUE)
  } else {
    write(tmpl_out, file=rmd_html_tmpl)  
  }
  
  message(paste("5. Updating", rmd_src, "with figures"))
  figs<-paste("

   ## Collect figures ####
   
   figs<-list.files('figure/')
   figs<-paste0('figure/', figs)
   
              ")
  
  write(figs, file=rmd_src, append=TRUE)
  
}


plot_att_goals <- function (.data, 
                            begin_date, 
                            end_date,  
                            ... #other arguments to filter
                            ) {
  att_filtered<-.data %>%
    filter(ymd(date)>=ymd(begin_date),
           ymd(date)<=ymd(end_date)) %>%
    filter(...)
  
  ggplot(att_filtered, 
         aes(x=day_of_week, 
             y=sum_absent)) + 
    geom_bar(aes(y=max_absent, fill=fill, alpha=alpha, width=.97), stat="identity") +
    geom_segment(aes(xend=day_of_week, yend=0, y=sum_absent)) +
    geom_point() +
    geom_text(aes(y=max_absent, label=max_absent), hjust=1.2, vjust=1.1, color="gray90", size=3) +
    geom_text(data=att_filtered %>% filter(!is.na(sum_absent)),
              aes(y=sum_absent, label=sum_absent), hjust=-0.2, vjust=.5, size=3) +
    scale_fill_manual("", values = c("#439539", "#E27425", "gray", "#255694")) +
    scale_alpha_continuous("Precip. Intensity", range = c(.5,1)) +
    facet_grid(schoolname~week_of, space = "free_y", scale="free_y") +
    theme_bw() +
    theme(legend.position="bottom") +
    ylab("Students Absent") +
    xlab("Day of the Week")
}

