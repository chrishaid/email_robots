# email_robots
Automated emailing for KIPP Chicago using Mandrill. 

## Prereqs
```r
devtools::install_github('Gastrograph/RMandrill")
# devtools::install_github('chrishaid/RMandrill@attachments") # if you need attachment functionality
```

## Implementing a mailer
This should get you started, but feel free to reach out with any questsions:

1. Use `ProjectTemplate` to create separate project of a given mailer topic (attendence, recruitment, etc.).  

2. Data goes in `data/`, preprocessing in `munge`, configurations in `config`, etc.  

3. Create Proof of concept mailers can be created in the `reports/` directory via [an `Rmd` file](http://rmarkdown.rstudio.com/). ~~(Eventually I'll add to RMandrill a  function to create a Mandrill template along with a source file for variable data/images form the original RMD.  Maybe by extending `knitr`.~~ You can simply knit the`Rmd` to `html` and edit the resulting `html` to create a Mandrill template. To help with templating you can create a custom knitr chunk option by inserting the following code in a chunk near the top of the `Rmd`:

```r
mandrill_content_hook<-function(before, options, envir){
  if(!before){

    #after chunk add these lines
    return(sprintf('<div mc:edit="%s">%s</div>', options$label, options$label))
    opts_chunk$set(results='show')
  }
}

knit_hooks$set(mandrill.content = mandrill_content_hook)
``` 
Then all you need to is add `mandrill.content = TRUE` to the options of any code chunk that contains content you will push up to mandrill (think time stamps, html table, names for salutions).  When you knit to `html` the resulting file will wrap the output of those codechunk in `<div>`s with the class attribute set to `mc:edit=slug` where slug is the code chunk's name.  You'll use that code chunk name/slug in your content list when you call `RMandrill::send_mandrill_template` below.   

4. Add to template [Mandrill](https://mandrillapp.com/) 

5. Create a source file in `src/` or `reports`  that terminates with a call to `RMandrill::send_mandrill_template`.I've actaully taken to putting the `send_mandrill_template` call at the bottom of the `Rmd` that I used to design the template. Then I simply create source file with two commands:
```r
require(knitr)
knitr::knit2html("my_cool_emailer.Rmd", 
                 quiet=TRUE,
                 options=c("use_xhtml","smartypants","mathjax","highlight_code"),
                 fragment.only=TRUE
)
```
The `fragments.only=TRUE` bit causes `knitr` to save any images as PNGs in a `figure` directory, rather than embedding the images inlin encoded as base64.  Doing so means you simply need to point `send_mandrill_template`'s `images` parameter at the figures to include in the email body (as list of file locations). 

The end result is that your origianl Rmd is used to author a prototype, jump start a mandrill template, and then serves as the code used to send recipients, generate and embed html and images, as well as generate and attach visualizations or other files.  

6. Create cron job to run your source file

That's it!
