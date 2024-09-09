# DONT_PANIC

<!-- badges: start -->

<!-- badges: end -->

Have you ever checked the waiting list 20 times a day to see if you can get a spot? Sometimes such behavior becomes obsessive and compulsive. 

The goal of `dont_panic` is to help you to avoid this behavior. The program will check the website for you during the time interval and with the frequency you want. If it finds an update to the waiting list, it will send an email to notify you. Now you only have to check your email box 20 times a day.

Currently the program is only used to check the HKSUT RPg housing application waiting list, but feel free to modify it to suit your needs.

## Set Up

### 1. Download this repo

### 2. Save your private information
In R console, run the following code to open the `.Renviron` file:
```r
usethis::edit_r_environ()
```
Add the following lines to the `.Renviron` file:
```r
GMAIL_USER='YOUR_GMAIL_ACCOUNT_TO_SEND_THE_EMAILS'
GMAIL_TO='YOUR_EMAIL_ACCOUNT_TO_RECEIVE_THE_EMAILS'
CREDS_PATH='PATH_TO_YOUR_GMAIL_CREDENTIALS'
DP_PATH='WHERE_YOU_SAVE_THIS_REPO'
````

### 3. Email Configuration

This project uses the `blastula` package to send email notifications when an update is detected on the website. To set up the email credentials:

- **Get Gmail App Code**:

  To use `blastula` with Gmail you will need to have an app password created for your Gmail account. To create an app password, follow the steps on the Google Account Help page [Sign in with App Passwords](https://support.google.com/accounts/answer/185833?hl=en).

- **Create the SMTP credentials**:
   
   You can create SMTP credentials using `blastula`'s `create_smtp_creds_file()` function. This will store your email credentials securely.

   ```r
   library(blastula)

   create_smtp_creds_file(
    file = Sys.getenv('CREDS_PATH'),
    user = Sys.getenv('GMAIL_USER'),
    provider = 'gmail',
    host = 'smtp.gmail.com',
    port = 465,
    use_ssl = TRUE
  )
   ```
   After running the code, you will be prompted to enter the App password of your Gmail account.
   
- **Test the email credentials**:

    You can test if your credentials work by sending a test email:
  
    ```r
    test_message <- prepare_test_message()
  
    smtp_send(
      test_message, 
      from = Sys.getenv('GMAIL_USER'), 
      to = Sys.getenv('GMAIL_TO'), 
      subject = "Testing the `smtp_send()` function",
      credentials = creds_file(file = Sys.getenv('CREDS_PATH'))
    )
    ```
  
## 4. Scheduling with Cron

To ensure the program checks the website regularly, you can schedule it using cron jobs. Here’s how to do it on a Unix-like system:

- **Open the cron tab**:

  You can edit the cron schedule by running the following command in the terminal:
  ```bash
  crontab -e
  ```
- **Add the cron job**:

    Add the following line to the crontab and adjust it based on your needs:
    
    ```bash
    0 12,14,16,18,20 * 6-7 * /usr/local/bin/Rscript PATH_TO_YOUR_REPO/wl_reminder.R
    ```
    
    - `0 12,14,16,18,20 * 6-7 *` means the script will run at 12:00, 14:00, 16:00, 18:00, and 20:00 every day from June to July. See [Cron Job Syntax](https://en.wikipedia.org/wiki/Cron#Overview) for more information.
  	- /usr/local/bin/Rscript is the path to your Rscript executable. You can find it by running `which Rscript` in the terminal.
  	-  PATH_TO_YOUR_REPO is the path to this R project.