# Contact page vulnerable to email injection attacks

## How to get started

### What do you need ?

- Apache Server
- PHP
- SMTP Server
- Postfix

### Installing Apache

- sudo apt-get install apache2

### Installing PHP

- sudo apt-get install php

### Configuring mail service with Postfix

- sudo apt-get install ssmtp
- sudo apt-get install postfix
- sudo apt-get install mailutils libsasl2-2 ca-certificates libsasl2-modules
- sudo nano /etc/postfix/main.cf

Add/edit following lines to it:

relayhost = [smtp.gmail.com]:587
smtp_sasl_auth_enable = yes
smtp_sasl_password_maps = hash:/etc/postfix/sasl_passwd
smtp_sasl_security_options = noanonymous
smtp_tls_CAfile = /etc/postfix/cacert.pem
smtp_use_tls = yes

- sudo nano /etc/postfix/sasl_passwd

Add the following line to it:
[smtp.gmail.com]:587 USERNAME@gmail.com:PASSWORD

- sudo chmod 600 /etc/postfix/sasl_passwd
- sudo postmap /etc/postfix/sasl_passwd
- cat /etc/ssl/certs/thawte_Primary_Root_CA.pem | sudo tee -a /etc/postfix/cacert.pem
- sudo etc/init.d/postfix.reload

### Testing configuration

- Set your Gmail account as less secure, logging into your gmail account using browser
- echo "Test mail from me." | mail -s "Test Mail" email_id@sample.com

## How to use

- Add both vuln_email.php and mail.css to your /var/www/html directory
- Change FROM_EMAIL and FROM_PWD in smtp_oracle.py to match yours (not needed anymore if you don't want to check the received email content by using the command line)
- run the following command :

python smtp_oracle.py :url :from :subject :message

