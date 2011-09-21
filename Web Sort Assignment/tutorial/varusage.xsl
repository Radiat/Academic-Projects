<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
<xsl:output method="html" />
<xsl:template match="/CATALOG" xmlns:saxon="http://icl.com/saxon">
  <xsl:for-each select="saxon:distinct(CD/CATEGORY)">
    <xsl:variable name="cat" select="." />
    <xsl:variable name="filename" select="concat(normalize-space($cat),'.html')" />
    <xsl:document href="{$filename}">
    <html>
    <head> <title> <xsl:value-of select="$cat" /> CATEGORY </title> </head>
    <body>
    <h1> <xsl:value-of select="$cat" /> CATEGORY </h1>
    <table>
    <xsl:for-each select="//CD[CATEGORY=$cat]">
      <tr><td> Title </td> <td> <xsl:value-of select="TITLE" /> </td></tr>
      <tr><td> Artist </td> <td> <xsl:value-of select="ARTIST" /> </td></tr>
      <tr><td> Price </td> <td> <xsl:value-of select="PRICE" /> </td></tr>
    </xsl:for-each>
    </table>
    </body> </html>
    </xsl:document>
  </xsl:for-each>
</xsl:template>
</xsl:stylesheet>
