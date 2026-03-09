#!/usr/bin/env python3
"""Read inbox via IMAP"""
import imaplib
import email
import os
import argparse

def read_inbox(limit=10):
    imap_host = os.getenv('EMAIL_IMAP_HOST', 'imap.gmail.com')
    user = os.getenv('EMAIL_USER')
    password = os.getenv('EMAIL_PASS')
    
    if not user or not password:
        print("Error: EMAIL_USER and EMAIL_PASS must be set")
        return []
    
    try:
        mail = imaplib.IMAP4_SSL(imap_host)
        mail.login(user, password)
        mail.select('inbox')
        
        _, search_data = mail.search(None, 'ALL')
        mail_ids = search_data[0].split()
        
        results = []
        for i in mail_ids[-limit:]:
            _, data = mail.fetch(i, '(RFC822)')
            raw_email = data[0][1]
            email_message = email.message_from_bytes(raw_email)
            
            results.append({
                'subject': email_message['Subject'],
                'from': email_message['From'],
                'date': email_message['Date']
            })
        
        mail.close()
        mail.logout()
        return results
    except Exception as e:
        print(f"Error reading inbox: {e}")
        return []

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument('--limit', type=int, default=10)
    args = parser.parse_args()
    
    emails = read_inbox(args.limit)
    for e in emails:
        print(f"From: {e['from']}")
        print(f"Subject: {e['subject']}")
        print(f"Date: {e['date']}")
        print("-" * 50)
