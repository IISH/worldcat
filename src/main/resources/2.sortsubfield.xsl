<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:marc="http://www.loc.gov/MARC21/slim">
	<!-- copy node -->
    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>

    <!-- sort first ascending characters codes, then sort ascending number codes -->
    <xsl:template
            match="marc:datafield[@tag='100' or @tag='110' or @tag='600' or @tag='610' or @tag='648' or @tag='650' or @tag='655' or @tag='700' or @tag='710' or @tag='830']">
        <marc:datafield ind1="{@ind1}" ind2="{@ind2}" tag="{@tag}">
            <xsl:for-each select="marc:subfield[not(@code>=0 and @code&lt;=9)]">
                <xsl:sort data-type="text" select="@code"/>
                <xsl:copy>
                    <xsl:apply-templates select="@*|node()"/>
                </xsl:copy>
            </xsl:for-each>
            <xsl:for-each select="marc:subfield[@code>=0 and @code&lt;=9]">
                <xsl:sort data-type="number" select="@code"/>
                <xsl:copy>
                    <xsl:apply-templates select="@*|node()"/>
                </xsl:copy>
            </xsl:for-each>
        </marc:datafield>
    </xsl:template>
</xsl:stylesheet>
