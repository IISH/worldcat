<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:marc="http://www.loc.gov/MARC21/slim"
                xmlns:xls="http://www.w3.org/1999/XSL/Transform">

	<xsl:template match="@*|node()">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>


	<!-- Verwijder ongeldige marc -->
	<xsl:template match="marc:subfield[not(@code) or @code='']"/>


	<!--
		Leader correcties test string:
		from abcdefghijklmnop0rstuv x
		to   abcdefghijklmnop7rstuv0x
	 -->
	<xls:template match="marc:leader">

		<!-- regel 3 -->
		<xsl:variable name="leader18_old" select="substring(text(), 18, 1)"/>
		<xsl:variable name="leader18_new">
			<xsl:choose>
				<xsl:when test="$leader18_old=' ' or $leader18_old='0'">7</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$leader18_old"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<!-- regel 5 -->
		<xsl:variable name="leader23_old" select="substring(text(), 23, 1)"/>
		<xsl:variable name="leader23_new">
			<xsl:choose>
				<xsl:when test="$leader23_old=' '">0</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$leader23_old"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<!-- concat -->
		<marc:leader>
			<xsl:value-of
					select="concat( substring( text(), 1, 17), $leader18_new, substring( text(), 19, 4), '+', $leader23_new, substring( text(), 24, 1))"/>
		</marc:leader>

	</xls:template>


	<!--
		008 39 (Srce)
		QUESTION: moet er gecontroleerd worden dat var3Language dut of eng is?
		QUESTION: kan er een postfix zijn?
	-->
	<xls:template match="marc:controlfield[@tag='008']">

		<xsl:variable name="var3" select="substring(text(), 1, 38)"/>
		<xsl:variable name="var3Language" select="substring(text(), 36, 3)"/>
		<xsl:variable name="var3Postfix" select="substring(text(), 39, 3)"/>

		<xsl:variable name="var3Postfix_new">
			<xsl:choose>
				<xsl:when test="$var3Postfix='' or $var3Postfix='  d' or $var3Postfix='| d' or $var3Postfix='||d'"> d</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$var3Postfix"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<!-- concat -->
		<marc:controlfield tag="008">
			<xsl:value-of
					select="concat($var3, $var3Postfix_new)" />
		</marc:controlfield>

	</xls:template>


	<!--
		008 15-17
	-->


</xsl:stylesheet>