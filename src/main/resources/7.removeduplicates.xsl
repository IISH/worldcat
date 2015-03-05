<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:marc="http://www.loc.gov/MARC21/slim"
                xmlns:xls="http://www.w3.org/1999/XSL/Transform">

	<!-- -->
	<xsl:key name="kLineById" match="marc:datafield[@tag]/marc:subfield[@code]" use="concat(@tag,@code,text())"/>

	<!-- copy node -->
	<xsl:template match="@*|node()">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>

	<!-- -->
	<xsl:template match="marc:datafield[@tag]/marc:subfield[@code][not(generate-id() = generate-id(key('kLineById', concat(@tag,@code,text()))[1]))]" />
</xsl:stylesheet>
