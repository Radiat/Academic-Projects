<?xml version="1.0"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="xml" indent="yes"/>
  <xsl:template match="/CATALOG">
    <!-- group all CD nodes according to their COUNTRY values -->
    <xsl:for-each-group select="CD" group-by="COUNTRY">
      <!-- sort the resulting groups by COUNTRY name -->
      <xsl:sort select="COUNTRY"/>
      <COUNTRY name="{COUNTRY}">
        <xsl:for-each-group select="current-group()" group-by="YEAR">
	  <!-- sort each COUNTRY group by YEAR the CD was issued -->
          <xsl:sort select="YEAR"/>
          <YEAR year="{YEAR}">
	    <!-- could output the entire group value, but choose to output
	    only the TITLE elements.  Note the difference between
	    copy-of and value-of (the former's value includes the element
	    tags and content, the latter only the element content) -->
            <xsl:copy-of select="current-group()/TITLE"/>
          </YEAR>
        </xsl:for-each-group>
      </COUNTRY>
    </xsl:for-each-group>
  </xsl:template>
</xsl:stylesheet>
