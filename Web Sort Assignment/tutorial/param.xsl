<?xml version="1.0"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:param name="marker"> Example </xsl:param>

<xsl:template match="/">
  <xsl:text> The value of variable $marker is: </xsl:text>
  <xsl:value-of select="$marker" />
</xsl:template>

</xsl:stylesheet>
