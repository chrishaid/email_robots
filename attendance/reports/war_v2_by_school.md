---
title: "Daily Attendance Report"
author: "Chris Haid"
date: "2015-05-13"
output: html_document
---







*Attendance data as of Wednesday, May 13, 2015 at 12:00 PM*

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
## [1] "83a748c92a7a46b88f2c6ace282ecc55"
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
## [1] "adb56052931f454bb3a2a6ab5b93787f"
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
## [1] "d6911de144a64ab8b396e89e2329c08e"
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
## [1] "bb6eb5e114ee44648315a35209aec1f4"
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
## [1] "613bb6df4c02415da768af35e0a2e598"
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
## [1] "ebhattacharyya@kippchicago.org"
## 
## [[1]]$status
## [1] "sent"
## 
## [[1]]$`_id`
## [1] "025fdc6689e148aeb27902f8f7dbc70a"
## 
## [[1]]$reject_reason
## NULL
## 
## 
## [[2]]
## [[2]]$email
## [1] "chaid@kippchicago.org"
## 
## [[2]]$status
## [1] "sent"
## 
## [[2]]$`_id`
## [1] "4b02f1c136b14d6da73f8749877203be"
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
## [1] "lhenley@kippchicago.org"
## 
## [[1]]$status
## [1] "sent"
## 
## [[1]]$`_id`
## [1] "9f1e0f9e48734b58bc0e9a076717358e"
## 
## [[1]]$reject_reason
## NULL
## 
## 
## [[2]]
## [[2]]$email
## [1] "chaid@kippchicago.org"
## 
## [[2]]$status
## [1] "sent"
## 
## [[2]]$`_id`
## [1] "6c6230d1dde841eeb0fdbfa64182db51"
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
## [1] "kmazurek@kippchicago.org"
## 
## [[1]]$status
## [1] "sent"
## 
## [[1]]$`_id`
## [1] "e320b3b4c387456888384273bbee236b"
## 
## [[1]]$reject_reason
## NULL
## 
## 
## [[2]]
## [[2]]$email
## [1] "chaid@kippchicago.org"
## 
## [[2]]$status
## [1] "sent"
## 
## [[2]]$`_id`
## [1] "4617b928d3ab4efabcbd208fefd24dc8"
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
## [1] "esale@kippchicago.org"
## 
## [[1]]$status
## [1] "sent"
## 
## [[1]]$`_id`
## [1] "86f5282d6eff4acdafbf2ab1bfb2b736"
## 
## [[1]]$reject_reason
## NULL
## 
## 
## [[2]]
## [[2]]$email
## [1] "chaid@kippchicago.org"
## 
## [[2]]$status
## [1] "sent"
## 
## [[2]]$`_id`
## [1] "362ebc1259b241b8b4b1b1ec2a0d8474"
## 
## [[2]]$reject_reason
## NULL
```


