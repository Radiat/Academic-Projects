<?xml version="1.0"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
 <!-- describe the output format used for the expensive and cheap output files
      -->
 <xsl:output method="xml" indent="yes" name="cd-output"/> 

 <!-- catalog is a temporary tree variable containing all CD's elements 
      -->
 <xsl:variable name="catalog" select="//CD"/>
  
 <xsl:template match="/">
    <!-- generate separate output documents for Expensive CD's
    (costing 9 or more) and Cheap containing CD's costing less than 9. 

    Note that the xsl:apply-templates instruction operates
    on the catalog variable rather than on the input tree.

    Also note that the value of the PRICE element is converted
    to a number before the comparison operator is applied.
    -->
   <xsl:result-document href="expensive.xml" format="cd-output">
    <Expensive>
     <xsl:apply-templates select="$catalog[number(PRICE) > 9]"/>
    </Expensive>
   </xsl:result-document>
   <xsl:result-document href="cheap.xml" format="cd-output">
   <Cheap>
     <xsl:apply-templates select="$catalog[number(PRICE) &lt; 9]"/>
   </Cheap>
   </xsl:result-document>
 </xsl:template>
  
  <!-- handle the apply-templates processing invoked above by
  outputting the markup and content for a CD element -->
  <xsl:template match="CD">
    <xsl:copy-of select="."/>  <!-- output matched nodes -->
  </xsl:template>
</xsl:stylesheet>
