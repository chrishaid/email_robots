ordinate <- function(x) {
  
  require(toOrdinal)
  
  if(is.numeric(x)) {
    if(!is.integer(x)) x <- as.integer(x)
    if(x>0) toOrdinal::toOrdinal(x)
  } else {
    x
  }
}


get_graphs <- function(graph_list, school, subject, grade){
 
  require(purrr) 
  
  rx <- sprintf("%s\\.u\\d+\\.%s\\.%s", subject, school, grade) %>%
    tolower
  
  keep(graph_list, grepl(rx, tolower(names(graph_list))))
}


send_mandrill_mail <- function(mastery_long_plots_list,
                               mastery_grid_plots_list,
                               school,
                               subject,
                               grade,
                               content_list,
                               api_key,
                               recipient){
  
  summary_plot <- get_graphs(graph_list = mastery_long_plots_list, 
                             school = school, 
                             subject = subject,
                             grade = grade
                             )
  
  detail_plots <- get_graphs(graph_list = mastery_grid_plots,
                             school = school, 
                             subject = subject,
                             grade = grade
                             )
  
  
  file_ext <- names(summary_plot) %>% str_replace_all("\\.", "_")
  
  temp_dir <- getwd()
  
  png_temp <- paste0(temp_dir, "/figure/summary_plot.png")
  pdf_temp <- paste0(temp_dir, "/figure/illuminate_rollups_", file_ext, ".pdf")
  
  png(filename = png_temp, height=600)
    print(summary_plot)
  dev.off()
  
  
  n <- length(detail_plots)
  
  Cairo::CairoPDF(file = pdf_temp, height = 8.4, width=10.9, onefile = TRUE)
    print(summary_plot)
    lapply(detail_plots, print)
  dev.off()
  
  
  email_subject <- sprintf("Weekly Illuminate Rollup: %s %s %s",
                           toupper(subject),
                           toupper(school),
                           grade
                           )
  
  mandrill_send_template(api_key = api_key,
                         recipient = recipient,
                         subject = email_subject,
                         template_name = "illuminate-rollup",
                         sender="data@kippchicago.org",
                         content=content_list,
                         variables=NA,
                         images=list(png_temp),
                         attachments = pdf_temp
  )
 
}



