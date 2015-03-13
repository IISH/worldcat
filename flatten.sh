#!/bin/bash
#
# Flatten the xslt files and parse them into a perl statement.

xslt_folder=$1
if [ ! -d $xslt_folder ] ; then
	echo "Not a folder: ${xslt_folder}"
	exit 1
fi

for file in $xslt_folder/*
do
	echo "# Flattening ${file}"
	bn=$(basename $file)
	n=${bn:0:1}
	xslt=$(tr -d '\t\n\r' < $file)
	echo "my \$xslt_${n} = \$_xslt_parser->parse_stylesheet(\$_xml_parser->parse_string(<<'XSLT${n}'));"
	echo $xslt
	echo "XSLT${n}"
done
