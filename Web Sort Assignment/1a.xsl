<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 version="2.0">
 
 <!-- Output format for two files, which represent the sorted data -->
  <xsl:output method="xhtml" indent="yes" name="frame-format"
	      doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN"
	      doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"
  />
  
<xsl:param name="neighbourhoodType">Midgar</xsl:param>
<xsl:param name="sortType">Price</xsl:param>
  
  
<xsl:template match="/rentor">

<!-- Outputting necessary xhtml file, sort dictated by parametres -->
<xsl:result-document href="{$sortType}.html" format="frame-format">

<!-- Necessary for a temporary tree of the landlord node, for searching-->
<xsl:variable name="tempLandlord" select="landlord"/>

<!-- Start of HTML body -->
  <html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
  <head>
  <title>{$sortType} Sort</title>
  <link rel="stylesheet" type="text/css" href="1b.css"/>
  </head>
  <body>
    <table>
    <xsl:apply-templates/>
    </table>
  </body>
  </html>
</xsl:result-document>

</xsl:template>

<xsl:template match="unit">
	<xsl:for-each select="unit>
		<xsl:if test="neighborhood={$neighborhoodType}">
		
		<!--Selecting whole groups of units in the same neighborhood-->
	  <tr>
	  <th>
	  <xsl:value-of select="neighborhood"/> <!--Neighborhood Header-->
	  </th>
	  </tr>
	  
	  <!-- Grouping the units together from specified parametre, then sorting it-->
	  <xsl:for-each-group select="current-group()" group-by="{$sortType}">
	  <xsl:sort select="{$sortType}" data-type="number"/>
	  
	  <!-- Taking the landid to be matched with landlord data later-->
	  <xsl:variable name="varLandID">
	  <xsl:value-of select="@landid"/>
	  </xsl:variable>
	  <tr>
	  <td rowspan="2">
	  
	  <!--Testing to see if photos exist or not, and processing them-->
	  <xsl:choose>
	  	<xsl:when test="photos/photo">
	  	<xsl:for-each select="photos/photo">
	  		<xsl:variable name="imgURL">
	  		<xsl:value-of select="@url"/>
	  		</xsl:variable>
	  	<img src="{$imgURL}" alt="Picture"></img>
	  	<br/>
	  	</xsl:for-each>	
	  	</xsl:when>
	  	<xsl:otherwise>
	  	No images found!
	  	</xsl:otherwise>
	  </xsl:choose>
	  </td>
	  
	  <!--Address Section and Price-->
	  <td class="addr">
	  	Address:
	  	<br/>
		<xsl:value-of select="address/street"/>
		<br/>
		<xsl:if test="address/unitnum">
		Unit/Apt/Suite: <xsl:value-of select="address/unitnum"/>
		<br/>
		</xsl:if>
		<xsl:value-of select="address/city"/>, <xsl:value-of select="address/province"/>
	  </td>
	  </tr>
	  <tr><td class="price">$<xsl:value-of select="price"/></td></tr>
	  
	<!-- Misc. Info section for distance, beds and baths if applicable-->
      	<tr>
        <td class="info">
        Distance: <xsl:value-of select="distance"/>
        <br />
        <xsl:choose>
        <xsl:when test="beds">Beds: <xsl:value-of select="beds"/></xsl:when>
        <xsl:otherwise>Beds: Not Avaliable</xsl:otherwise>
        </xsl:choose>
        <br/>
        <xsl:choose>
        <xsl:when test="baths">Baths: <xsl:value-of select="baths"/></xsl:when>
        <xsl:otherwise>Baths: Not Avaliable</xsl:otherwise>
        </xsl:choose>
        <br/>
        </td>
        
        <!--Landlord section. Here we take the temporary tree with landlord
        data, and loop in it to match the landid, if there is a match.-->
        <xsl:for-each select="$tempLandlord">
        <xsl:if test="@landid=$varLandID">
        <td class="landl">
        Landlord:
        <br/>
        <xsl:value-of select="name/first"/> 
        <br/><xsl:value-of select="name/last"/>
        	<br/>
        	<xsl:value-of select="address/street"/>
		<br/>
		<xsl:if test="address/unitnum">
		Unit/Apt/Suite: <xsl:value-of select="address/unitnum"/>
		<br/>
		</xsl:if>
		<xsl:value-of select="address/city"/>, <xsl:value-of select="address/province"/>
		<br/>
		<xsl:value-of select="phone"/>
	</td>
	</xsl:if>
	</xsl:for-each>
      </tr>
      
      <!-- A quick hack to display some nice lines-->
      <tr><td><hr/><hr/></td></tr>
	  </xsl:for-each-group>
	</xsl:if>
	</xsl:for-each>
	
</xsl:template>

</xsl:stylesheet>
