#!python2
import sys
import re
from bs4 import BeautifulSoup

files = sys.argv[1:]
for file in files:
    print "Cleaning up %s" % file
    with open(file, 'r') as content_file:
        content = content_file.read()
    soup = BeautifulSoup(content, 'html.parser')
    for toc in soup.select('#toc'):
        toc.extract()
    for body in soup.find_all('body'):
        body_class = body['class']
        try:
            body_class.remove('toc2')
        except Exception as e:
            pass
        try:
            body_class.remove('toc-left')
        except Exception as e:
            pass
        body['class'] = body_class
    for anchor in soup.find_all('a'):
        text = re.sub(r'\s+', ' ', ' '.join(list(anchor.stripped_strings)), flags=re.UNICODE)
        anchor.string = text
    with open(file, 'w') as content_file:
        content_file.write(soup.prettify(formatter="html").encode('utf-8'))

