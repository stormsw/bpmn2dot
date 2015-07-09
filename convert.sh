#!/bin/sh
#
#    bpmn2dot.xsl - transform BPMN2.0 process definition into DOT.
#
saxon-xslt -o processdefinition.dot $1 bpmndot.xsl && dot -Tjpg -oprocessimage.jpg processdefinition.dot