<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:marc="http://www.loc.gov/MARC21/slim"
                xmlns:xls="http://www.w3.org/1999/XSL/Transform">

	<xsl:template match="@*|node()">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>

	<!-- replace pipes -->
	<xls:template match="marc:controlfield[@tag='008']">
		<xsl:variable name="var_008_pipes" select="text()"/>

		<xsl:variable name="var_008_spaces">
			<xsl:call-template name="string-replace-all">
				<xsl:with-param name="text" select="$var_008_pipes"/>
				<xsl:with-param name="replace" select="'|'"/>
				<xsl:with-param name="by" select="' '"/>
			</xsl:call-template>
		</xsl:variable>

		<xsl:copy>
			<xsl:attribute name="tag">
				<xsl:value-of select="@tag"/>
			</xsl:attribute>
			<xsl:value-of select="$var_008_spaces"/>
		</xsl:copy>
	</xls:template>

	<!-- replace function -->
	<xsl:template name="string-replace-all">
		<xsl:param name="text"/>
		<xsl:param name="replace"/>
		<xsl:param name="by"/>
		<xsl:choose>
			<xsl:when test="contains($text, $replace)">
				<xsl:value-of select="substring-before($text,$replace)"/>
				<xsl:value-of select="$by"/>
				<xsl:call-template name="string-replace-all">
					<xsl:with-param name="text" select="substring-after($text,$replace)"/>
					<xsl:with-param name="replace" select="$replace"/>
					<xsl:with-param name="by" select="$by"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$text"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>
