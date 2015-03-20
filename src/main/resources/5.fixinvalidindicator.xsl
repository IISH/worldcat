<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:marc="http://www.loc.gov/MARC21/slim"
                xmlns:xls="http://www.w3.org/1999/XSL/Transform">

	<xsl:template match="@*|node()">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>

	<!-- fix invalid indicator -->
	<xls:template match="marc:datafield">
		<xsl:variable name="var_ind1" select="@ind1"/>
		<xsl:variable name="var_ind2" select="@ind2"/>

		<marc:datafield>
			<xsl:attribute name="ind1">
			<xsl:choose>
				<xsl:when test="string-length($var_ind1) = 0"><xsl:value-of select="' '"/></xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$var_ind1"/>
				</xsl:otherwise>
			</xsl:choose>
			</xsl:attribute>

			<xsl:attribute name="ind2">
				<xsl:choose>
					<xsl:when test="string-length($var_ind2) = 0"><xsl:value-of select="' '"/></xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$var_ind2"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>

			<xsl:attribute name="tag">
				<xsl:value-of select="@tag"/>
			</xsl:attribute>

			<xsl:apply-templates select="node()"/>

		</marc:datafield>
	</xls:template>

</xsl:stylesheet>
