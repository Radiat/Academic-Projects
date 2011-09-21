<?xml version="1.0"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
 <xsl:output method="xml" indent="yes"/> 
 <!-- catalog is a temporary tree variable containing all CD's meeting 
      the selection criterion - i.e. their YEAR of issue is before 1991
      -->
 <xsl:variable name="catalog" select="//CD[number(YEAR) &lt; 1991]"/>
  
 <xsl:template match="/">
    <!-- the output document has two sub-elements: Expensive
    which contains all CD data for CD's costing 9 or more and
    Cheap containing CD data for CD's costing less than 9. 
    Note that the xsl:apply-templates instruction operates
    on the catalog variable rather than on the input tree.
    Also note that the value of the PRICE element is converted
    to a number before the comparison operator is applied.
    For the sake of example, sort the expensive results by
    descending price order.
    -->
   <Expensive>
     <xsl:apply-templates select="$catalog[number(PRICE) >= 9]">
       <xsl:sort select="PRICE" data-type="number" order="descending" />
     </xsl:apply-templates>
   </Expensive>
   <Cheap>
     <xsl:apply-templates select="$catalog[number(PRICE) &lt; 9]"/>
   </Cheap>
 </xsl:template>
  
  <!-- handle the apply-templates processing invoked above by
  outputting the markup and content for a CD element -->
  <xsl:template match="CD">
    <xsl:copy-of select="."/>  <!-- output matched nodes -->
  </xsl:template>
</xsl:stylesheet>
