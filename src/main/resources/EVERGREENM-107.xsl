<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:marc="http://www.loc.gov/MARC21/slim">

    <xsl:template match="marc:controlfield[@tag='008']">

        <xsl:variable name="place" select="substring(text(), 16, 3)"/>
        <xsl:variable name="new_place">
            <xsl:choose>
                <xsl:when test="$place = 'xx '">ne </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$place"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:variable name="language" select="substring(text(), 36, 3)" />
        <xsl:variable name="new_language">
            <xsl:choose>
                <xsl:when test="$language = 'und'">dut</xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$language"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <marc:controlfield tag="008"><xsl:value-of select="concat( substring(text(), 1, 15), $new_place, substring(text(), 19, 17), $new_language, substring(text(), 39))"/></marc:controlfield>

    </xsl:template>

    <xsl:template match="marc:subfield[@code='k' and text()='Visual document.' and ../../marc:datafield[@tag='245']]">
        <marc:subfield code="k">Sound document.</marc:subfield>
    </xsl:template>

    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>

</xsl:stylesheet>