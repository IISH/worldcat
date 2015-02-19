<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:marc="http://www.loc.gov/MARC21/slim"
                xmlns:xls="http://www.w3.org/1999/XSL/Transform">

    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>

    <!-- Verwijder ongeldige marc -->
    <xsl:template match="marc:datafield[not(marc:subfield)]"/>
    <xsl:template match="marc:subfield[not(@code) or @code='']"/>

    <!--
        Leader correcties test string:
        from abcdefghijklmnop0rstuv x
        to   abcdefghijklmnop7rstuv0x
     -->
    <xls:template match="marc:leader">

        <!-- regel 3 -->
        <xsl:variable name="leader17_old" select="substring(text(), 17, 1)"/>
        <xsl:variable name="leader17_new">
            <xsl:choose>
                <xsl:when test="$leader17_old=' ' or $leader17_old='0'">7</xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$leader17_old"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <!-- regel 5 -->
        <xsl:variable name="leader22_old" select="substring(text(), 23, 1)"/>
        <xsl:variable name="leader22_new">
            <xsl:choose>
                <xsl:when test="$leader22_old=' '">0</xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$leader22_old"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <marc:leader>
            <xsl:value-of
                    select="concat( substring( text(), 1, 16), $leader17_new, substring( text(), 18, 5), $leader22_new, substring( text(), 24, 1))"/>
        </marc:leader>

    </xls:template>

</xsl:stylesheet>