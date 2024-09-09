pacman::p_load(tidyverse, blastula, glue)
create_smtp_creds_file(
  file = Sys.getenv('CREDS_PATH'),
  user = Sys.getenv('GMAIL_USER'),
  provider = 'gmail',
  host = 'smtp.gmail.com',
  port = 465,
  use_ssl = TRUE
)


test_message <- prepare_test_message()
test_message %>% 
  smtp_send(
    from = Sys.getenv('GMAIL_USER'), 
    to = Sys.getenv('GMAIL_TO'), 
    subject = "Testing the `smtp_send()` function",
    credentials = creds_file(file = Sys.getenv('CREDS_PATH'))
  )
