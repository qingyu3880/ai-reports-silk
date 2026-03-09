#!/usr/bin/env python3
"""Send email via SMTP"""
import smtplib
import os
import argparse
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart

def send_email(to_email, subject, body, html=False):
    smtp_host = os.getenv('EMAIL_SMTP_HOST', 'smtp.gmail.com')
    smtp_port = int(os.getenv('EMAIL_SMTP_PORT', '587'))
    user = os.getenv('EMAIL_USER')
    password = os.getenv('EMAIL_PASS')
    
    if not user or not password:
        print("Error: EMAIL_USER and EMAIL_PASS must be set")
        return False
    
    msg = MIMEMultipart()
    msg['From'] = user
    msg['To'] = to_email
    msg['Subject'] = subject
    
    content_type = 'html' if html else 'plain'
    msg.attach(MIMEText(body, content_type))
    
    try:
        server = smtplib.SMTP(smtp_host, smtp_port)
        server.starttls()
        server.login(user, password)
        server.send_message(msg)
        server.quit()
        print(f"Email sent successfully to {to_email}")
        return True
    except Exception as e:
        print(f"Error sending email: {e}")
        return False

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument('--to', required=True)
    parser.add_argument('--subject', required=True)
    parser.add_argument('--body', required=True)
    parser.add_argument('--html', action='store_true')
    args = parser.parse_args()
    
    send_email(args.to, args.subject, args.body, args.html)
