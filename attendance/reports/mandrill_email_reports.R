require(knitr)
knitr::knit2html("war_v2_by_school.Rmd", 
                 quiet=TRUE,
                 options=c("use_xhtml","smartypants","mathjax","highlight_code"),
                 fragment.only=TRUE
)