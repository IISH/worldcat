<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:marc="http://www.loc.gov/MARC21/slim">
	<!-- copy node -->
    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>

    <!-- remove node if preceding sibling is the same -->
    <xsl:template
            match="marc:subfield[@code = preceding-sibling::marc:subfield[1]/@code and text() = preceding-sibling::marc:subfield[1]/text()]"/>
</xsl:stylesheet>
