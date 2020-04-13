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

def checkValidity(msg_received,p_from,subject,message):
    validity = True
    if(msg_received['subject'] != subject or msg_received.get_payload()[:-2] != message or len(msg_received) != 9):
        validity = False
        print("DETOURNEMENT DE LA FONCTION DE MAIL DETECTE !")
    return validity

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
    time.sleep(3)
    msg_received = readmail()

    print("========== CODE SOURCE DU MAIL ENVOYE ==========\n")
    print(msg_received)

    validity = checkValidity(msg_received,p_from,subject,message)
    if(validity):
        exit(0)
    else:
        exit(180)

if __name__=="__main__":
    if(len(sys.argv) == 4):
        main(sys.argv[1],sys.argv[2],sys.argv[3])
    else:
        print("Usage: python smtp_oracle.py [from] [subject] [message]")
