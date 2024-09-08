pacman::p_load(tidyverse, rvest, blastula, glue)

DP_PATH <- Sys.getenv('DP_PATH')
pdflink_last <- readRDS(glue("{DP_PATH}/pdflink_last.rds"))

# Scrape the website
url <- "https://shrl.hkust.edu.hk/apply-for-housing/pg/continuing-rpgs"
pdflink <- read_html(url) %>% 
  html_elements(xpath = "//a[strong[text()='Continuing RPGs Waitlist']]") %>% 
  html_attr('href') %>% 
  url_absolute(base = url)

if(pdflink != pdflink_last){
  # Send email
  sender <- Sys.getenv('GMAIL_USER') %>% 
    str_extract('.*@') %>% 
    str_remove('@')
  
  receiver <- Sys.getenv('GMAIL_TO') %>% 
    str_extract('.*@') %>% 
    str_remove('@')
  
  body_text <-
    md(glue("
Dear {receiver},

The housing application waiting list has just been updated. Please check the link below: 

[{pdflink}]({pdflink})

Good Luck!

{sender}
            "))
  
  footer_text <- md("Don't Panic.")
  
  reminder <- compose_email(
    body = body_text,
    footer = footer_text
  )
  
  reminder %>% 
    smtp_send(
      from = Sys.getenv('GMAIL_USER'), 
      to = Sys.getenv('GMAIL_TO'), 
      subject = "Waiting List Updated",
      credentials = creds_file(file = Sys.getenv('CREDS_PATH'))
    )
}

pdflink %>% saveRDS(glue("{DP_PATH}/pdflink_last.rds"))




