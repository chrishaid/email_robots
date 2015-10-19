---
title: "Daily Attendance Report"
author: "Chris Haid"
date: "2015-10-19"
output: html_document
---







*Attendance data as of Monday, October 19, 2015 at 12:00 PM*

# Weekly Attendance Report
<div mc:edit="time_stamp">time_stamp</div>

For more info go to [KIPP IDEA](idea.kippchicago.org).






### Region
![plot of chunk ada_targets_plot_all](figure/ada_targets_plot_all-1.png) 

### KAP
![plot of chunk ada_targets_plot_KAP](figure/ada_targets_plot_KAP-1.png) 

### KAMS
![plot of chunk ada_targets_plot_KAMS](figure/ada_targets_plot_KAMS-1.png) 

### KCCP
![plot of chunk ada_targets_plot_KCCP](figure/ada_targets_plot_KCCP-1.png) 

### KBCP
![plot of chunk ada_targets_plot_KBCP](figure/ada_targets_plot_KBCP-1.png) 
### KAS
![plot of chunk ada_targets_plot_KAS](figure/ada_targets_plot_KAS-1.png) 

### Summary Table 
<div mc:edit="target_table_html">target_table_html</div>





```r
time_stamp2<-paste0("<i>",time_stamp, "</i>")
   
subject <- lubridate::stamp("Daily Attendance Report for Tuesday, September 14, 2001")(today())

figs<-list.files('figure/')
figs<-paste0('figure/', figs)

email_data<-read.dcf("../config//email.dcf", all = TRUE) %>% as.data.frame

rcpts_region<-strsplit(email_data$region, '\\s*,\\s*')[[1]]
rcpts_kap<-strsplit(email_data$kap, '\\s*,\\s*')[[1]]
rcpts_kams<-strsplit(email_data$kams, '\\s*,\\s*')[[1]]
rcpts_kccp<-strsplit(email_data$kccp, '\\s*,\\s*')[[1]]
rcpts_kbcp<-strsplit(email_data$kbcp, '\\s*,\\s*')[[1]]



message("Mandrill mailing regiona team now")
mandrill_send_template(api_key = keys$mandrill_key,
                       recipient = rcpts_region,
                       subject = subject,
                       template_name = "war-regional-team",
                       sender="data@kippchicago.org",
                       content=list(time_stamp=time_stamp2,
                                    target_table=target_table_html),
                       images=figs[grepl("all", figs)],
                       css=TRUE
)
```

```
## [[1]]
## [[1]]$email
## [1] "chaid@kippchicago.org"
## 
## [[1]]$status
## [1] "sent"
## 
## [[1]]$`_id`
## [1] "f2d5dcfb62c64c058c5b072542c7e465"
## 
## [[1]]$reject_reason
## NULL
## 
## 
## [[2]]
## [[2]]$email
## [1] "agoble@kippchicago.org"
## 
## [[2]]$status
## [1] "sent"
## 
## [[2]]$`_id`
## [1] "10f731f465fa41bd92676a492b97580a"
## 
## [[2]]$reject_reason
## NULL
## 
## 
## [[3]]
## [[3]]$email
## [1] "msalmonowicz@kippchicago.org"
## 
## [[3]]$status
## [1] "sent"
## 
## [[3]]$`_id`
## [1] "0f778595219542f3b6fb344a5d5319af"
## 
## [[3]]$reject_reason
## NULL
## 
## 
## [[4]]
## [[4]]$email
## [1] "apouba@kippchicago.org"
## 
## [[4]]$status
## [1] "sent"
## 
## [[4]]$`_id`
## [1] "0309f1eb19d8411bbf6cf5193cdcf604"
## 
## [[4]]$reject_reason
## NULL
## 
## 
## [[5]]
## [[5]]$email
## [1] "nboardman@kippchicago.org"
## 
## [[5]]$status
## [1] "sent"
## 
## [[5]]$`_id`
## [1] "8bb6d8e8a07045618418bcad453c7ffe"
## 
## [[5]]$reject_reason
## NULL
```

```r
message("Mandrill mailing KAP team now")
mandrill_send_template(api_key = keys$mandrill_key,
                       recipient = rcpts_kap,
                       subject = subject,
                       template_name = "war-kap",
                       sender="data@kippchicago.org",
                       content=list(time_stamp=time_stamp2,
                                    target_table=target_table_html),
                       images=figs[grepl("KAP", figs)],
                       css=TRUE
)
```

```
## [[1]]
## [[1]]$email
## [1] "chaid@kippchicago.org"
## 
## [[1]]$status
## [1] "sent"
## 
## [[1]]$`_id`
## [1] "cecd8d08cf744dfe896822160f0ec832"
## 
## [[1]]$reject_reason
## NULL
## 
## 
## [[2]]
## [[2]]$email
## [1] "ebhattacharyya@kippchicago.org"
## 
## [[2]]$status
## [1] "sent"
## 
## [[2]]$`_id`
## [1] "e3dd027b0f5d47d89e2a7e129b291561"
## 
## [[2]]$reject_reason
## NULL
```

```r
message("Mandrill mailing KAMS team now")
mandrill_send_template(api_key = keys$mandrill_key,
                       recipient = rcpts_kams,
                       subject = subject,
                       template_name = "war-kams",
                       sender="data@kippchicago.org",
                       content=list(time_stamp=time_stamp2,
                                    target_table=target_table_html),
                       images=figs[grepl("KAMS", figs)],
                       css=TRUE
)
```

```
## [[1]]
## [[1]]$email
## [1] "chaid@kippchicago.org"
## 
## [[1]]$status
## [1] "sent"
## 
## [[1]]$`_id`
## [1] "5024372b7dad44f99a69f56f2886940d"
## 
## [[1]]$reject_reason
## NULL
## 
## 
## [[2]]
## [[2]]$email
## [1] "lhenley@kippchicago.org"
## 
## [[2]]$status
## [1] "sent"
## 
## [[2]]$`_id`
## [1] "4a357f4775bb42888f9f5836d9122c1f"
## 
## [[2]]$reject_reason
## NULL
```

```r
message("Mandrill mailing KCCP team now")
mandrill_send_template(api_key = keys$mandrill_key,
                       recipient = rcpts_kccp,
                       subject = subject,
                       template_name = "war-kccp",
                       sender="data@kippchicago.org",
                       content=list(time_stamp=time_stamp2,
                                    target_table=target_table_html),
                       images=figs[grepl("KCCP", figs)],
                       css=TRUE
)
```

```
## [[1]]
## [[1]]$email
## [1] "chaid@kippchicago.org"
## 
## [[1]]$status
## [1] "sent"
## 
## [[1]]$`_id`
## [1] "9079590a07cb4d18bb4865fa5f3015c5"
## 
## [[1]]$reject_reason
## NULL
## 
## 
## [[2]]
## [[2]]$email
## [1] "kmazurek@kippchicago.org"
## 
## [[2]]$status
## [1] "sent"
## 
## [[2]]$`_id`
## [1] "2de19b1b84cb4e7eb683a8b81fb6e55b"
## 
## [[2]]$reject_reason
## NULL
```

```r
message("Mandrill mailing KBCP team now")
mandrill_send_template(api_key = keys$mandrill_key,
                       recipient = rcpts_kbcp,
                       subject = subject,
                       template_name = "war-kbcp",
                       sender="data@kippchicago.org",
                       content=list(time_stamp=time_stamp2,
                                    target_table=target_table_html),
                       images=figs[grepl("KBCP", figs)],
                       css=TRUE
)
```

```
## [[1]]
## [[1]]$email
## [1] "chaid@kippchicago.org"
## 
## [[1]]$status
## [1] "sent"
## 
## [[1]]$`_id`
## [1] "e70361e2463341dd9dfa19d74aa12090"
## 
## [[1]]$reject_reason
## NULL
## 
## 
## [[2]]
## [[2]]$email
## [1] "esale@kippchicago.org"
## 
## [[2]]$status
## [1] "sent"
## 
## [[2]]$`_id`
## [1] "14b36e95364a4f6b9f9adaafdc51e309"
## 
## [[2]]$reject_reason
## NULL
```

```r
message("Mandrill mailing KAS team now")
mandrill_send_template(api_key = keys$mandrill_key,
                       recipient = rcpts_kas,
                       subject = subject,
                       template_name = "war-kas",
                       sender="data@kippchicago.org",
                       content=list(time_stamp=time_stamp2,
                                    target_table=target_table_html),
                       images=figs[grepl("KAS", figs)],
                       css=TRUE
)
```

```
## Error in data.frame(email = recipient, stringsAsFactors = FALSE): object 'rcpts_kas' not found
```


