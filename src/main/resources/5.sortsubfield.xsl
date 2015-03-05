<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:marc="http://www.loc.gov/MARC21/slim"
                xmlns:xls="http://www.w3.org/1999/XSL/Transform">

	<!-- copy node -->
	<xsl:template match="@*|node()">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="marc:datafield">
		<marc:datafield ind1="{@ind1}" ind2="{@ind2}" tag="{@tag}">
			<xsl:for-each select="marc:subfield[not(@code>=0 and @code&lt;=9)]"><xsl:sort data-type="text" select="@code" />
				<xsl:copy>
					<xsl:apply-templates select="@*|node()"/>
				</xsl:copy>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code>=0 and @code&lt;=9]"><xsl:sort data-type="number" select="@code" />
				<xsl:copy>
					<xsl:apply-templates select="@*|node()"/>
				</xsl:copy>
			</xsl:for-each>
		</marc:datafield>
	</xsl:template>

</xsl:stylesheet>
