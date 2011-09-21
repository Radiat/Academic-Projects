<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 version="2.0">
<xsl:template match="/rentor">
  <html>
  <body>
    <table border="2" style="background-color: yellow">
      <tr>
        <th>Neighborhood</th>
        <th>Street</th>
		<th>Price (in $)</th>
      </tr>
	  <xsl:for-each-group select="unit" group-by="neighborhood">
	  <xsl:sort select="price" data-type="number"/>
	  <tr>
		<td><xsl:value-of select="{neighborhood}"/></td>]
		</tr>
		<xsl:for-each-group select="current-group()" group-by="price">
		<xsl:sort select="price" data-type="number"/>
      <tr>
        <td><xsl:value-of select="neighborhood"/></td>
        <td><xsl:value-of select="address/street"/></td>
		<td><xsl:value-of select="price"/></td>
      </tr>
	  </xsl:for-each-group>
      </xsl:for-each-group>
    </table>
  </body>
  </html>
</xsl:template>
</xsl:stylesheet>
