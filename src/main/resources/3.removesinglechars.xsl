<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:marc="http://www.loc.gov/MARC21/slim">
	<!-- copy node -->
    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>

    <!-- remove single char codes with single char values -->
    <xsl:template
            match="marc:datafield[@tag='100' or @tag='110' or @tag='600' or @tag='610' or @tag='648' or @tag='650' or @tag='655' or @tag='700' or @tag='710' or @tag='830']/marc:subfield[string-length(@code)=1]">
        <xsl:choose>
            <xsl:when test="string-length(text()) &lt;2 or text()='()'"/>
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:apply-templates select="@*|node()"/>
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>
