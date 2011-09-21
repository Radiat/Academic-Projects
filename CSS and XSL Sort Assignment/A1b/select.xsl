<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
version="2.0">

<!-- Output format for two files, which represent the sorted data -->
 <!--<xsl:output method="xhtml" indent="yes" name="option-format"
	    doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN"
	     doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"
		 -->

<xsl:output method="xhtml" indent="yes" omit-xml-declaration="yes"/>
 
<xsl:template match="/rentor">



<!-- Outputting necessary xhtml file -->
<!--<xsl:result-document href="links.html" format="option-format">-->
 <select name="NeighborhoodList">
 <xsl:for-each-group select="unit" group-by="neighborhood">
 <xsl:variable name="temp" select="neighborhood"/>
 <option value="{$temp}"><xsl:value-of select="$temp"/></option>
 </xsl:for-each-group>
 </select>
 
<!--</xsl:result-document>-->
</xsl:template>
</xsl:stylesheet>
