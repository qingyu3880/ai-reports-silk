#!/usr/bin/env python3
"""Humanize AI-generated text"""
import argparse
import re

def humanize_text(text):
    """Make AI text sound more human"""
    
    # Remove overly formal transitions
    replacements = [
        (r'Furthermore,', 'Also,'),
        (r'Moreover,', 'Plus,'),
        (r'In conclusion,', 'So,'),
        (r'It is important to note that', 'Keep in mind'),
        (r'It should be noted that', 'Note that'),
        (r'In order to', 'To'),
        (r'At this point in time', 'Now'),
        (r'Due to the fact that', 'Because'),
        (r'In the event that', 'If'),
        (r'Prior to', 'Before'),
        (r' subsequent to', ' after'),
    ]
    
    result = text
    for pattern, replacement in replacements:
        result = re.sub(pattern, replacement, result, flags=re.IGNORECASE)
    
    # Add some contractions
    result = result.replace('do not', "don't")
    result = result.replace('does not', "doesn't")
    result = result.replace('will not', "won't")
    result = result.replace('cannot', "can't")
    result = result.replace('is not', "isn't")
    result = result.replace('are not', "aren't")
    
    # Vary sentence length (simple approach)
    sentences = re.split(r'(?<=[.!?])\s+', result)
    if len(sentences) > 3:
        # Shorten some sentences
        for i in range(0, len(sentences), 3):
            if len(sentences[i]) > 100:
                # Find a good break point
                words = sentences[i].split()
                if len(words) > 15:
                    sentences[i] = ' '.join(words[:12]) + '.'
    
    return ' '.join(sentences)

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument('--text', help='Text to humanize')
    parser.add_argument('--file', help='File to read')
    args = parser.parse_args()
    
    if args.file:
        with open(args.file, 'r') as f:
            text = f.read()
    elif args.text:
        text = args.text
    else:
        text = input("Enter text to humanize: ")
    
    result = humanize_text(text)
    print(result)
