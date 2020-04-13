import requests
import sys
import smtplib
import time
import imaplib
import email

url = 'http://127.0.0.1:80/vuln_email.php'
FROM_EMAIL = 
FROM_PWD =
SMTP_SERVER = "imap.gmail.com"
SMTP_PORT = 993

def readmail():
    try:
        mail = imaplib.IMAP4_SSL(SMTP_SERVER)
        mail.login(FROM_EMAIL,FROM_PWD)
        mail.select('inbox')
        type, data = mail.search(None,'ALL')
        mail_ids = data[0]
        id_list = mail_ids.split()
        latest_email_id = int(id_list[-1])

        type_mail, data_mail = mail.fetch(latest_email_id, '(RFC822)')
        for response_part in data_mail:
            if isinstance(response_part, tuple):
                msg_received = email.message_from_string(response_part[1])
                return msg_received
    except Exception, e:
        print str(e)

def main(p_from,subject,message):
    data = {"from":p_from, "subject":subject, "message":message}
    response = requests.post(url,data=data)
    if(response.status_code != 200):
        exit(180)

    exit(0)

if __name__=="__main__":
    if(len(sys.argv) == 4):
        main(sys.argv[1],sys.argv[2],sys.argv[3])
    else:
        print("Usage: python smtp_oracle.py [from] [subject] [message]")
