<?xml version="1.0"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="xml" indent="yes" name="cd-format"/>
  <xsl:template match="/CATALOG">
    <!-- group the data by COUNTRY element value -->
    <xsl:for-each-group select="CD" group-by="COUNTRY">
      <!-- create a result document (file) for each group, naming the files
           using the pattern CD#_country where # is the position within the
	   groups list, and country is the key used to create the groups.
	   Note the format reference to "cd-format" defined in the xsl:output
	   element above, and note how <xsl:copy-of> is used here.  -->
      <xsl:result-document 
         href="CD{position()}_{current-grouping-key()}.xml" format="cd-format">
        <CD_LIST country="{current-grouping-key()}">
          <xsl:copy-of select="current-group()"/>
        </CD_LIST>
      </xsl:result-document>
    </xsl:for-each-group>
  </xsl:template>
</xsl:stylesheet>
