#Chris Carpio
#994954518
#makefile :D
#Thanks to Prof. Rosselet!

JAVA = /usr/java/bin/java
JAVAFLAGS = -cp ".:/student1/Courses/cscc09/common/lib/saxon8.jar:/student1/Courses/cscc09/common/lib/xerces.jar"

processxml:
	$(JAVA) -jar /student1/Courses/cscc09/common/lib/saxon8.jar 1a.xml 1a.xsl 
	chmod 644 price.html distance.html

.PHONY: validatexml
validatexml:
	$(JAVA) $(JAVAFLAGS) Validator -v 1a.xml
	$(JAVA) $(JAVAFLAGS) Validator -v price.html
	$(JAVA) $(JAVAFLAGS) Validator -v distance.html
	$(JAVA) $(JAVAFLAGS) Validator -v index.html


.PHONY: clean
clean:
	/bin/rm -f price.html
	/bin/rm -f distance.html