# email_robots
Automate emailing for KIPP Chicago using Mandrill. 

## Implementing a a mailer

1. Use `ProjectTemplate` to create separate project of a given mailer topic (attendence, recruitment, etc.).  
2. Data goes in `data/`, preprocessing in `munge`, configurations in `config`, etc.  
2. (Optional) Create Proof of concept mailers can be created in the `reports/` directory via an `Rmd` file (Eventually I'll add to RMandrill a  function to create a Mandrill template along with a source file for variable data/images form the original RMD.  Maybe by extending `knitr`.
3. Add to template [Mandrill](https://mandrillapp.com/) 
4. Create source file in `src/` that terminates with a call to `RMandrill::send_mandrill_template`.
5. Create cron job to run source

That's it!
