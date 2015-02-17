<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:marc="http://www.loc.gov/MARC21/slim"
                xmlns:xls="http://www.w3.org/1999/XSL/Transform">

    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>

    <!-- Rule 1: leaders end with 4500  -->
    <xls:template match="marc:leader">
        <xsl:variable name="tmp" select="normalize-space(text())"/>
        <marc:leader>
            <xsl:value-of select="concat( substring( text(), 0, 21), '4500')"/>
        </marc:leader>
    </xls:template>

</xsl:stylesheet>