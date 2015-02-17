#!/usr/bin/python
import jinja2, os, re, yaml, shutil


# Load the vars
# example for vars.yml
"""
username: radius
password: xxxxxxx
"""
FILE = "var.yml"
f = open(FILE, 'r')
document = f.read()
f.close

templateVars = yaml.load(document)

dirTemplates = os.getcwd()+"/templates"
dirFiles = os.getcwd()+"/files"

templateLoader = jinja2.FileSystemLoader( searchpath="/" )
# An environment provides the data necessary to read and
#   parse our templates.  We pass in the loader object here.
templateEnv = jinja2.Environment( loader=templateLoader )
# This constant string specifies the template file we will use.

def findTemplates():
    for root, dirs, files in os.walk(dirTemplates, topdown=True):
        #print root
        for dir in dirs:
            #print "ROOT "+root
            m = re.search(dirTemplates+'(.*)', root)
            path = m.group(1)+"/"
            if (not os.path.isdir(dirFiles+path+dir)):
                os.mkdir(dirFiles+path+dir)
                print "mkdir "+dirFiles+path+dir
        for file in files:
            #print file
            m = re.search(dirTemplates+'(.*)', root)
            path = m.group(1)+"/"
            m = re.search('(.*)\.j2', file)
            if not m is None:
                filename = m.group(1)
                FILE = dirFiles+path+filename
                TEMPLATE_FILE = root+"/"+file
                print TEMPLATE_FILE
                f = open(FILE, 'w')
                # Read the template file using the environment object.
                # This also constructs our Template object.
                template = templateEnv.get_template( TEMPLATE_FILE )
                
                # Finally, process the template to produce our final text.
                outputText = template.render( templateVars )
                f.write(outputText)
                f.close
                print "create "+dirFiles+path+filename
            else:
                shutil.copyfile(root+"/"+file, dirFiles+path+file)
                print "not template "+dirFiles+path+file

findTemplates()
