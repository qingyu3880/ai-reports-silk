#!/usr/bin/env python3
"""SEO content optimizer"""
import argparse
import re

def analyze_seo(content, keyword):
    """Analyze SEO metrics"""
    word_count = len(content.split())
    keyword_count = content.lower().count(keyword.lower())
    keyword_density = (keyword_count / word_count * 100) if word_count > 0 else 0
    
    # Check title
    title_match = re.search(r'^#\s+(.+)$', content, re.MULTILINE)
    has_keyword_in_title = keyword.lower() in title_match.group(1).lower() if title_match else False
    
    # Check headings
    h2_count = len(re.findall(r'^##\s+', content, re.MULTILINE))
    
    # Check links
    link_count = len(re.findall(r'\[.+?\]\(.+?\)', content))
    
    return {
        'word_count': word_count,
        'keyword_count': keyword_count,
        'keyword_density': round(keyword_density, 2),
        'has_keyword_in_title': has_keyword_in_title,
        'h2_count': h2_count,
        'link_count': link_count,
        'score': calculate_score(word_count, keyword_density, has_keyword_in_title, h2_count, link_count)
    }

def calculate_score(words, density, title_keyword, h2_count, links):
    score = 0
    if words >= 300: score += 20
    if 1 <= density <= 3: score += 30
    if title_keyword: score += 20
    if h2_count >= 2: score += 15
    if links >= 1: score += 15
    return score

def optimize_content(content, keyword):
    """Suggest SEO improvements"""
    suggestions = []
    
    word_count = len(content.split())
    if word_count < 300:
        suggestions.append(f"Content too short ({word_count} words). Aim for 300+ words.")
    
    keyword_count = content.lower().count(keyword.lower())
    density = (keyword_count / word_count * 100) if word_count > 0 else 0
    if density < 1:
        suggestions.append(f"Keyword density too low ({density}%). Add more '{keyword}'.")
    elif density > 3:
        suggestions.append(f"Keyword density too high ({density}%). Reduce '{keyword}' usage.")
    
    title_match = re.search(r'^#\s+(.+)$', content, re.MULTILINE)
    if not title_match or keyword.lower() not in title_match.group(1).lower():
        suggestions.append(f"Add keyword '{keyword}' to title.")
    
    h2_count = len(re.findall(r'^##\s+', content, re.MULTILINE))
    if h2_count < 2:
        suggestions.append("Add more H2 headings (at least 2).")
    
    return suggestions

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument('--file', required=True)
    parser.add_argument('--keyword', required=True)
    args = parser.parse_args()
    
    with open(args.file, 'r') as f:
        content = f.read()
    
    analysis = analyze_seo(content, args.keyword)
    suggestions = optimize_content(content, args.keyword)
    
    print(f"SEO Analysis for keyword: '{args.keyword}'")
    print("=" * 50)
    print(f"Word count: {analysis['word_count']}")
    print(f"Keyword count: {analysis['keyword_count']}")
    print(f"Keyword density: {analysis['keyword_density']}%")
    print(f"Keyword in title: {'Yes' if analysis['has_keyword_in_title'] else 'No'}")
    print(f"H2 headings: {analysis['h2_count']}")
    print(f"Links: {analysis['link_count']}")
    print(f"SEO Score: {analysis['score']}/100")
    print()
    if suggestions:
        print("Suggestions:")
        for s in suggestions:
            print(f"  - {s}")
    else:
        print("Great job! No major SEO issues found.")
