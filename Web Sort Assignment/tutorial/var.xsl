<?xml version="1.0"?>

<xsl:stylesheet version='2.0'
xmlns:xsl='http://www.w3.org/1999/XSL/Transform' >  
 
  <xsl:variable name="totalChapters">  
    <xsl:value-of select="//chapter[last()]"/>  
  </xsl:variable>  
  
  <xsl:template match="/">  
    <xsl:value-of select="$totalChapters"/>  
  </xsl:template>  
</xsl:stylesheet>  
