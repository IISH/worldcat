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

		<!-- step 1 -->
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


		<xsl:variable name="var3step1" select="concat($var3, $var3Postfix_new)"/>

		<!--
			step 2
			008 15-17
		-->

		<xsl:variable name="var3step1_pos16_18" select="substring($var3step1, 16, 3)"/>
		<xsl:variable name="var044a" select="//marc:datafield[@tag='044']/marc:subfield[@code='a']"/>

		<xsl:variable name="var3NewPubCode">
			<xsl:choose>
				<xsl:when test="string-length($var044a)=2"><xsl:value-of select="concat($var044a, '#')"/></xsl:when>
				<xsl:when test="string-length($var044a)=3"><xsl:value-of select="$var044a"/></xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$var3step1_pos16_18"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="var3NewPubCode_2">
			<xsl:call-template name="string-replace-all">
				<xsl:with-param name="text" select="$var3NewPubCode" />
				<xsl:with-param name="replace" select="'|||'" />
				<xsl:with-param name="by" select="'xx#'" />
			</xsl:call-template>
		</xsl:variable>






		<!-- concat -->
		<marc:controlfield tag="008">
			<xsl:value-of select="$var3step1" /> -- <xsl:value-of select="$var3step1_pos16_18" /> -- <xsl:value-of select="$var044a" /> ++ <xsl:value-of select="$var3NewPubCode" /> ++ <xsl:value-of select="$var3NewPubCode_2" /> ++
		</marc:controlfield>

	</xls:template>


	<xsl:template name="string-replace-all">
		<xsl:param name="text" />
		<xsl:param name="replace" />
		<xsl:param name="by" />
		<xsl:choose>
			<xsl:when test="contains($text, $replace)">
				<xsl:value-of select="substring-before($text,$replace)" />
				<xsl:value-of select="$by" />
				<xsl:call-template name="string-replace-all">
					<xsl:with-param name="text" select="substring-after($text,$replace)" />
					<xsl:with-param name="replace" select="$replace" />
					<xsl:with-param name="by" select="$by" />
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$text" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>

