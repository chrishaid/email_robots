send_mandrill_mail <- function(mastery_long_plots_list,
                               content_list,
                               api_key,
                               recipient){
  


  
  file_ext <- names(summary_plot) %>% str_replace_all("\\.", "_")
  
  temp_dir <- getwd()
  
  png_temp <- paste0(temp_dir, "/figure/summary_plot.png")

  png(filename = png_temp, height=600)
  print(summary_plot)
  dev.off()

  
  
  email_subject <- sprintf("Weekly Kickboard Data for %s",
                           today()
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