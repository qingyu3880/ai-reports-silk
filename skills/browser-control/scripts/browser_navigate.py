#!/usr/bin/env python3
"""Browser navigation with screenshot"""
import argparse
import sys

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--url', required=True)
    parser.add_argument('--action', choices=['screenshot', 'html', 'text'], default='screenshot')
    parser.add_argument('--output', default='/tmp/browser_output')
    args = parser.parse_args()
    
    try:
        from playwright.sync_api import sync_playwright
        
        with sync_playwright() as p:
            browser = p.chromium.launch(headless=True)
            page = browser.new_page()
            page.goto(args.url, wait_until='networkidle')
            
            if args.action == 'screenshot':
                output_file = f"{args.output}.png"
                page.screenshot(path=output_file, full_page=True)
                print(f"Screenshot saved: {output_file}")
            elif args.action == 'html':
                output_file = f"{args.output}.html"
                with open(output_file, 'w') as f:
                    f.write(page.content())
                print(f"HTML saved: {output_file}")
            elif args.action == 'text':
                text = page.inner_text('body')
                print(text[:2000])
            
            browser.close()
            return True
    except ImportError:
        print("Error: playwright not installed. Run: pip install playwright")
        return False
    except Exception as e:
        print(f"Error: {e}")
        return False

if __name__ == "__main__":
    success = main()
    sys.exit(0 if success else 1)
