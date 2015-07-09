# bpmn2dot
BPMN2.0 to dot language XSL

You can use this style sheet to convert  urn:jbpm.org:jpdl-3.2 files to dot version
This one can help to generate different images format from process definition
you need "dot" installed

More details about dot language: http://www.graphviz.org/doc/info/lang.html
For tool download follow thi link: http://www.graphviz.org/Download.php  

## Usage

### eclipse
add to your eclipse run configuration for XML file.
You have to specify output file name (by default the same file name.ext+dot)
### console
from console its requires to have some xslt processor installed,`saxon` for example :

```bash
saxon-xslt -o processdefinition.dot myprocess.xml
```

## Image generation
You can generate image running dot tool

For example JPEG image `processimage.jpg` from `processdefinition.dot`:
```bash
dot -Tjpg -oprocessimage.jpg processdefinition.dot
```

## License
This project is under WTFPL license, enjoy it ;)
