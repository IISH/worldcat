<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:marc="http://www.loc.gov/MARC21/slim"
                xmlns:xls="http://www.w3.org/1999/XSL/Transform">
	<!-- check 245a -->
	<xsl:template name="check245Title">
		<xsl:param name="title"/>
		<xsl:choose>
			<xsl:when test="$title='[]'">
				<xsl:value-of select="'[No Title.]'"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$title"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- check correctness of language code -->
    <xsl:template name="checkLanguageCode">
        <xsl:param name="lc"/>
        <xsl:param name="if_incorrect_return_value"/>
        <xsl:choose>
            <xsl:when test="$lc='afr'">
                <xsl:value-of select="$lc"/>
            </xsl:when>
            <xsl:when test="$lc='alb'">
                <xsl:value-of select="$lc"/>
            </xsl:when>
            <xsl:when test="$lc='ara'">
                <xsl:value-of select="$lc"/>
            </xsl:when>
            <xsl:when test="$lc='asm'">
                <xsl:value-of select="$lc"/>
            </xsl:when>
            <xsl:when test="$lc='aze'">
                <xsl:value-of select="$lc"/>
            </xsl:when>
            <xsl:when test="$lc='bak'">
                <xsl:value-of select="$lc"/>
            </xsl:when>
            <xsl:when test="$lc='bal'">
                <xsl:value-of select="$lc"/>
            </xsl:when>
            <xsl:when test="$lc='ban'">
                <xsl:value-of select="$lc"/>
            </xsl:when>
            <xsl:when test="$lc='baq'">
                <xsl:value-of select="$lc"/>
            </xsl:when>
            <xsl:when test="$lc='bel'">
                <xsl:value-of select="$lc"/>
            </xsl:when>
            <xsl:when test="$lc='ben'">
                <xsl:value-of select="$lc"/>
            </xsl:when>
            <xsl:when test="$lc='bre'">
                <xsl:value-of select="$lc"/>
            </xsl:when>
            <xsl:when test="$lc='bul'">
                <xsl:value-of select="$lc"/>
            </xsl:when>
            <xsl:when test="$lc='bur'">
                <xsl:value-of select="$lc"/>
            </xsl:when>
            <xsl:when test="$lc='cat'">
                <xsl:value-of select="$lc"/>
            </xsl:when>
            <xsl:when test="$lc='cel'">
                <xsl:value-of select="$lc"/>
            </xsl:when>
            <xsl:when test="$lc='che'">
                <xsl:value-of select="$lc"/>
            </xsl:when>
            <xsl:when test="$lc='chi'">
                <xsl:value-of select="$lc"/>
            </xsl:when>
            <xsl:when test="$lc='cpe'">
                <xsl:value-of select="$lc"/>
            </xsl:when>
            <xsl:when test="$lc='crp'">
                <xsl:value-of select="$lc"/>
            </xsl:when>
            <xsl:when test="$lc='cze'">
                <xsl:value-of select="$lc"/>
            </xsl:when>
            <xsl:when test="$lc='dan'">
                <xsl:value-of select="$lc"/>
            </xsl:when>
            <xsl:when test="$lc='dum'">
                <xsl:value-of select="$lc"/>
            </xsl:when>
            <xsl:when test="$lc='dut'">
                <xsl:value-of select="$lc"/>
            </xsl:when>
            <xsl:when test="$lc='eng'">
                <xsl:value-of select="$lc"/>
            </xsl:when>
            <xsl:when test="$lc='epo'">
                <xsl:value-of select="$lc"/>
            </xsl:when>
            <xsl:when test="$lc='est'">
                <xsl:value-of select="$lc"/>
            </xsl:when>
            <xsl:when test="$lc='fao'">
                <xsl:value-of select="$lc"/>
            </xsl:when>
            <xsl:when test="$lc='fin'">
                <xsl:value-of select="$lc"/>
            </xsl:when>
            <xsl:when test="$lc='fre'">
                <xsl:value-of select="$lc"/>
            </xsl:when>
            <xsl:when test="$lc='fry'">
                <xsl:value-of select="$lc"/>
            </xsl:when>
            <xsl:when test="$lc='geo'">
                <xsl:value-of select="$lc"/>
            </xsl:when>
            <xsl:when test="$lc='ger'">
                <xsl:value-of select="$lc"/>
            </xsl:when>
            <xsl:when test="$lc='gle'">
                <xsl:value-of select="$lc"/>
            </xsl:when>
            <xsl:when test="$lc='glg'">
                <xsl:value-of select="$lc"/>
            </xsl:when>
            <xsl:when test="$lc='gmh'">
                <xsl:value-of select="$lc"/>
            </xsl:when>
            <xsl:when test="$lc='gre'">
                <xsl:value-of select="$lc"/>
            </xsl:when>
            <xsl:when test="$lc='gsw'">
                <xsl:value-of select="$lc"/>
            </xsl:when>
            <xsl:when test="$lc='heb'">
                <xsl:value-of select="$lc"/>
            </xsl:when>
            <xsl:when test="$lc='hin'">
                <xsl:value-of select="$lc"/>
            </xsl:when>
            <xsl:when test="$lc='hrv'">
                <xsl:value-of select="$lc"/>
            </xsl:when>
            <xsl:when test="$lc='hun'">
                <xsl:value-of select="$lc"/>
            </xsl:when>
            <xsl:when test="$lc='ice'">
                <xsl:value-of select="$lc"/>
            </xsl:when>
            <xsl:when test="$lc='ido'">
                <xsl:value-of select="$lc"/>
            </xsl:when>
            <xsl:when test="$lc='iku'">
                <xsl:value-of select="$lc"/>
            </xsl:when>
            <xsl:when test="$lc='ina'">
                <xsl:value-of select="$lc"/>
            </xsl:when>
            <xsl:when test="$lc='inc'">
                <xsl:value-of select="$lc"/>
            </xsl:when>
            <xsl:when test="$lc='ind'">
                <xsl:value-of select="$lc"/>
            </xsl:when>
            <xsl:when test="$lc='ira'">
                <xsl:value-of select="$lc"/>
            </xsl:when>
            <xsl:when test="$lc='ita'">
                <xsl:value-of select="$lc"/>
            </xsl:when>
            <xsl:when test="$lc='jav'">
                <xsl:value-of select="$lc"/>
            </xsl:when>
            <xsl:when test="$lc='jpn'">
                <xsl:value-of select="$lc"/>
            </xsl:when>
            <xsl:when test="$lc='kac'">
                <xsl:value-of select="$lc"/>
            </xsl:when>
            <xsl:when test="$lc='kar'">
                <xsl:value-of select="$lc"/>
            </xsl:when>
            <xsl:when test="$lc='kas'">
                <xsl:value-of select="$lc"/>
            </xsl:when>
            <xsl:when test="$lc='kaz'">
                <xsl:value-of select="$lc"/>
            </xsl:when>
            <xsl:when test="$lc='khm'">
                <xsl:value-of select="$lc"/>
            </xsl:when>
            <xsl:when test="$lc='kor'">
                <xsl:value-of select="$lc"/>
            </xsl:when>
            <xsl:when test="$lc='kro'">
                <xsl:value-of select="$lc"/>
            </xsl:when>
            <xsl:when test="$lc='kur'">
                <xsl:value-of select="$lc"/>
            </xsl:when>
            <xsl:when test="$lc='lat'">
                <xsl:value-of select="$lc"/>
            </xsl:when>
            <xsl:when test="$lc='lav'">
                <xsl:value-of select="$lc"/>
            </xsl:when>
            <xsl:when test="$lc='lit'">
                <xsl:value-of select="$lc"/>
            </xsl:when>
            <xsl:when test="$lc='ltz'">
                <xsl:value-of select="$lc"/>
            </xsl:when>
            <xsl:when test="$lc='mac'">
                <xsl:value-of select="$lc"/>
            </xsl:when>
            <xsl:when test="$lc='mal'">
                <xsl:value-of select="$lc"/>
            </xsl:when>
            <xsl:when test="$lc='map'">
                <xsl:value-of select="$lc"/>
            </xsl:when>
            <xsl:when test="$lc='mar'">
                <xsl:value-of select="$lc"/>
            </xsl:when>
            <xsl:when test="$lc='may'">
                <xsl:value-of select="$lc"/>
            </xsl:when>
            <xsl:when test="$lc='mis'">
                <xsl:value-of select="$lc"/>
            </xsl:when>
            <xsl:when test="$lc='mlg'">
                <xsl:value-of select="$lc"/>
            </xsl:when>
            <xsl:when test="$lc='mon'">
                <xsl:value-of select="$lc"/>
            </xsl:when>
            <xsl:when test="$lc='mul'">
                <xsl:value-of select="$lc"/>
            </xsl:when>
            <xsl:when test="$lc='nep'">
                <xsl:value-of select="$lc"/>
            </xsl:when>
            <xsl:when test="$lc='nor'">
                <xsl:value-of select="$lc"/>
            </xsl:when>
            <xsl:when test="$lc='pan'">
                <xsl:value-of select="$lc"/>
            </xsl:when>
            <xsl:when test="$lc='pap'">
                <xsl:value-of select="$lc"/>
            </xsl:when>
            <xsl:when test="$lc='per'">
                <xsl:value-of select="$lc"/>
            </xsl:when>
            <xsl:when test="$lc='pol'">
                <xsl:value-of select="$lc"/>
            </xsl:when>
            <xsl:when test="$lc='por'">
                <xsl:value-of select="$lc"/>
            </xsl:when>
            <xsl:when test="$lc='pro'">
                <xsl:value-of select="$lc"/>
            </xsl:when>
            <xsl:when test="$lc='pus'">
                <xsl:value-of select="$lc"/>
            </xsl:when>
            <xsl:when test="$lc='que'">
                <xsl:value-of select="$lc"/>
            </xsl:when>
            <xsl:when test="$lc='raj'">
                <xsl:value-of select="$lc"/>
            </xsl:when>
            <xsl:when test="$lc='rom'">
                <xsl:value-of select="$lc"/>
            </xsl:when>
            <xsl:when test="$lc='rum'">
                <xsl:value-of select="$lc"/>
            </xsl:when>
            <xsl:when test="$lc='rus'">
                <xsl:value-of select="$lc"/>
            </xsl:when>
            <xsl:when test="$lc='san'">
                <xsl:value-of select="$lc"/>
            </xsl:when>
            <xsl:when test="$lc='shn'">
                <xsl:value-of select="$lc"/>
            </xsl:when>
            <xsl:when test="$lc='sin'">
                <xsl:value-of select="$lc"/>
            </xsl:when>
            <xsl:when test="$lc='slo'">
                <xsl:value-of select="$lc"/>
            </xsl:when>
            <xsl:when test="$lc='slv'">
                <xsl:value-of select="$lc"/>
            </xsl:when>
            <xsl:when test="$lc='smn'">
                <xsl:value-of select="$lc"/>
            </xsl:when>
            <xsl:when test="$lc='sna'">
                <xsl:value-of select="$lc"/>
            </xsl:when>
            <xsl:when test="$lc='snd'">
                <xsl:value-of select="$lc"/>
            </xsl:when>
            <xsl:when test="$lc='spa'">
                <xsl:value-of select="$lc"/>
            </xsl:when>
            <xsl:when test="$lc='srd'">
                <xsl:value-of select="$lc"/>
            </xsl:when>
            <xsl:when test="$lc='srn'">
                <xsl:value-of select="$lc"/>
            </xsl:when>
            <xsl:when test="$lc='srp'">
                <xsl:value-of select="$lc"/>
            </xsl:when>
            <xsl:when test="$lc='sun'">
                <xsl:value-of select="$lc"/>
            </xsl:when>
            <xsl:when test="$lc='swe'">
                <xsl:value-of select="$lc"/>
            </xsl:when>
            <xsl:when test="$lc='tam'">
                <xsl:value-of select="$lc"/>
            </xsl:when>
            <xsl:when test="$lc='tat'">
                <xsl:value-of select="$lc"/>
            </xsl:when>
            <xsl:when test="$lc='tel'">
                <xsl:value-of select="$lc"/>
            </xsl:when>
            <xsl:when test="$lc='tgk'">
                <xsl:value-of select="$lc"/>
            </xsl:when>
            <xsl:when test="$lc='tgl'">
                <xsl:value-of select="$lc"/>
            </xsl:when>
            <xsl:when test="$lc='tha'">
                <xsl:value-of select="$lc"/>
            </xsl:when>
            <xsl:when test="$lc='tib'">
                <xsl:value-of select="$lc"/>
            </xsl:when>
            <xsl:when test="$lc='tur'">
                <xsl:value-of select="$lc"/>
            </xsl:when>
            <xsl:when test="$lc='tut'">
                <xsl:value-of select="$lc"/>
            </xsl:when>
            <xsl:when test="$lc='ukr'">
                <xsl:value-of select="$lc"/>
            </xsl:when>
            <xsl:when test="$lc='urd'">
                <xsl:value-of select="$lc"/>
            </xsl:when>
            <xsl:when test="$lc='uzb'">
                <xsl:value-of select="$lc"/>
            </xsl:when>
            <xsl:when test="$lc='vie'">
                <xsl:value-of select="$lc"/>
            </xsl:when>
            <xsl:when test="$lc='vot'">
                <xsl:value-of select="$lc"/>
            </xsl:when>
            <xsl:when test="$lc='wel'">
                <xsl:value-of select="$lc"/>
            </xsl:when>
            <xsl:when test="$lc='xho'">
                <xsl:value-of select="$lc"/>
            </xsl:when>
            <xsl:when test="$lc='yid'">
                <xsl:value-of select="$lc"/>
            </xsl:when>
            <xsl:when test="$lc='zul'">
                <xsl:value-of select="$lc"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$if_incorrect_return_value"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <!-- correct the place of publication code -->
    <xsl:template name="correctLanguageCode">
        <xsl:param name="c"/>
        <xsl:choose>
            <xsl:when test="$c='uuu'">und</xsl:when>
            <xsl:when test="$c='joe'">srp</xsl:when>
            <xsl:when test="$c='fra'">fre</xsl:when>
            <xsl:when test="$c='ru#'">rus</xsl:when>
            <xsl:when test="$c='ru '">rus</xsl:when>
            <xsl:when test="$c='ru|'">rus</xsl:when>
            <xsl:when test="$c='ne#'">dut</xsl:when>
            <xsl:when test="$c='ne '">dut</xsl:when>
            <xsl:when test="$c='ne|'">dut</xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$c"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <!-- correct the place of publication code -->
    <xsl:template name="correctPlaceOfPublicationCode">
        <xsl:param name="c"/>
        <xsl:choose>
            <xsl:when test="$c='|||'"><xsl:value-of select="'xx '"/></xsl:when>
            <xsl:when test="$c='|| '"><xsl:value-of select="'xx '"/></xsl:when>
            <xsl:when test="$c='|  '"><xsl:value-of select="'xx '"/></xsl:when>
            <xsl:when test="$c='||'"><xsl:value-of select="'xx '"/></xsl:when>
            <xsl:when test="$c='|'"><xsl:value-of select="'xx '"/></xsl:when>
            <xsl:when test="$c='uk#'">xxk</xsl:when>
            <xsl:when test="$c='uk|'">xxk</xsl:when>
            <xsl:when test="$c='uk '">xxk</xsl:when>
            <xsl:when test="$c='uk'">xxk</xsl:when>
            <xsl:when test="$c='us#'">xxu</xsl:when>
            <xsl:when test="$c='us|'">xxu</xsl:when>
            <xsl:when test="$c='us '">xxu</xsl:when>
            <xsl:when test="$c='us'">xxu</xsl:when>
            <xsl:when test="$c='cn#'">xxc</xsl:when>
            <xsl:when test="$c='cn|'">xxc</xsl:when>
            <xsl:when test="$c='cn '">xxc</xsl:when>
            <xsl:when test="$c='cn'">xxc</xsl:when>
            <xsl:when test="$c='cs#'"><xsl:value-of select="'xr '"/></xsl:when>
            <xsl:when test="$c='cs|'"><xsl:value-of select="'xr '"/></xsl:when>
            <xsl:when test="$c='cs '"><xsl:value-of select="'xr '"/></xsl:when>
            <xsl:when test="$c='cs'"><xsl:value-of select="'xr '"/></xsl:when>
            <xsl:when test="$c='hk#'"><xsl:value-of select="'cc '"/></xsl:when>
            <xsl:when test="$c='hk|'"><xsl:value-of select="'cc '"/></xsl:when>
            <xsl:when test="$c='hk '"><xsl:value-of select="'cc '"/></xsl:when>
            <xsl:when test="$c='hk'"><xsl:value-of select="'cc '"/></xsl:when>
            <xsl:when test="$c='yu#'"><xsl:value-of select="'rb '"/></xsl:when>
            <xsl:when test="$c='yu|'"><xsl:value-of select="'rb '"/></xsl:when>
            <xsl:when test="$c='yu '"><xsl:value-of select="'rb '"/></xsl:when>
            <xsl:when test="$c='yu'"><xsl:value-of select="'rb '"/></xsl:when>
            <xsl:when test="$c='ge#'"><xsl:value-of select="'gw '"/></xsl:when>
            <xsl:when test="$c='ge|'"><xsl:value-of select="'gw '"/></xsl:when>
            <xsl:when test="$c='ge '"><xsl:value-of select="'gw '"/></xsl:when>
            <xsl:when test="$c='ge'"><xsl:value-of select="'gw '"/></xsl:when>
            <xsl:when test="$c='uu#'"><xsl:value-of select="'xx '"/></xsl:when>
            <xsl:when test="$c='uu|'"><xsl:value-of select="'xx '"/></xsl:when>
            <xsl:when test="$c='uu '"><xsl:value-of select="'xx '"/></xsl:when>
            <xsl:when test="$c='uu'"><xsl:value-of select="'xx '"/></xsl:when>
            <xsl:when test="$c='rus'"><xsl:value-of select="'ru '"/></xsl:when>
            <xsl:when test="$c='dut'"><xsl:value-of select="'ne '"/></xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$c"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <!-- copy node -->
    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>
    <!-- Verwijder ongeldige marc --> <!--<xsl:template match="marc:subfield[not(@code) or not(string-length(normalize-space(@code))=1)]"/>--> <!-- Leader correcties test string: from abcdefghijklmnop0rstuv x to abcdefghijklmnop7rstuv0x -->
    <xls:template match="marc:leader"> <!-- regel 3 -->
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
                    select="concat( substring( text(), 1, 17 ), $leader18_new, substring( text(), 19, 4 ), $leader23_new, substring( text(), 24, 1 ))"/>
        </marc:leader>
    </xls:template>
    <!-- Zie ook http://www.loc.gov/marc/bibliographic/bd008.html 008 39 (Srce) -->
    <xls:template match="marc:controlfield[@tag='008']"> <!-- step 1 -->
        <xsl:variable name="var3" select="substring(text(), 1, 38)"/>
        <xsl:variable name="var3Postfix" select="substring(text(), 39, 3)"/>
        <xsl:variable name="var3Postfix_new">
            <xsl:choose>
                <xsl:when test="$var3Postfix='' or $var3Postfix='  d' or $var3Postfix='| d' or $var3Postfix='||d'">
                    <xsl:value-of select="concat(' ', 'd')"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$var3Postfix"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <!-- concat -->
        <xsl:variable name="var3step1" select="concat($var3, $var3Postfix_new)"/>
        <!-- step 2 008 15-17 -->
        <xsl:variable name="var3step1_pos1_15" select="substring($var3step1, 1, 15)"/>
        <xsl:variable name="var3step1_pos16_18" select="substring($var3step1, 16, 3)"/>
        <xsl:variable name="var3step1_pos19_41" select="substring($var3step1, 19, 23)"/>
        <xsl:variable name="var044a" select="//marc:datafield[@tag='044']/marc:subfield[@code='a']"/>
        <xsl:variable name="var3NewPubCode">
            <xsl:choose> <!-- opmerking A, ook spatie|| en ||spatie -->
                <xsl:when
                        test="( $var3step1_pos16_18='|||' or $var3step1_pos16_18=' ||' or $var3step1_pos16_18='|| ' ) and string-length($var044a)=2"> <!-- opmerking B, spatie en niet # -->
                    <xsl:value-of select="concat($var044a, ' ')"/>
                </xsl:when>
                <xsl:when
                        test="( $var3step1_pos16_18='|||' or $var3step1_pos16_18=' ||' or $var3step1_pos16_18='|| ' ) and string-length($var044a)=3">
                    <xsl:value-of select="$var044a"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$var3step1_pos16_18"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="var3NewPubCode_2">
	        <!-- TODO vraag: wat gebeurt er als waarde eindigt met een spatie? wordt de spatie eraf geknipt ? -->
            <xsl:call-template name="correctPlaceOfPublicationCode">
                <xsl:with-param name="c" select="$var3NewPubCode"/>
            </xsl:call-template>
        </xsl:variable>
	    <!-- extra trailing space protection -->
	    <xsl:variable name="var3NewPubCode_3">
		    <xsl:choose>
			    <xsl:when test="string-length($var3NewPubCode_2)=2">
				    <xsl:value-of select="concat($var3NewPubCode_2, ' ')"/>
			    </xsl:when>
			    <xsl:otherwise>
				    <xsl:value-of select="$var3NewPubCode_2"/>
			    </xsl:otherwise>
		    </xsl:choose>
	    </xsl:variable>
        <!-- concat -->
        <xsl:variable name="var3step2" select="concat($var3step1_pos1_15, $var3NewPubCode_3, $var3step1_pos19_41)"/>
        <!-- step 3 008 35-37 -->
        <xsl:variable name="var3step1_pos1_35" select="substring($var3step2, 1, 35)"/>
        <xsl:variable name="var3step1_pos36_38" select="substring($var3step2, 36, 3)"/>
        <xsl:variable name="var3step1_pos39_41" select="substring($var3step2, 39, 3)"/>
        <xsl:variable name="var041a" select="//marc:datafield[@tag='041']/marc:subfield[@code='a']"/>
        <xsl:variable name="var655a" select="//marc:datafield[@tag='655']/marc:subfield[@code='a']"/>
        <xsl:variable name="varmarcleader" select="//marc:leader"/>
        <xsl:variable name="varmarcleader_pos7" select="substring($varmarcleader, 7, 1)"/>
        <xsl:variable name="var3langcode" select="$var3step1_pos36_38"/>
        <xsl:variable name="var3langcode_2">
            <xsl:choose>
                <xsl:when
                        test="$var3langcode='|||' and string-length($var041a)=3"> <!-- check if 041a code is correct, if not return ||| -->
                    <xsl:variable name="var041a_checked">
                        <xsl:call-template name="checkLanguageCode">
                            <xsl:with-param name="lc" select="$var041a"/>
                            <xsl:with-param name="if_incorrect_return_value" select="'|||'"/>
                        </xsl:call-template>
                    </xsl:variable>
                    <xsl:value-of select="$var041a_checked"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$var3langcode"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="var3langcode_3">
            <xsl:choose>
                <xsl:when
                        test="$var3langcode_2='|||' and ( $var655a='Photo' or $var655a='Photo.' ) and $varmarcleader_pos7='k'">
                    <xsl:value-of select="'zxx'"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$var3langcode_2"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="var3langcode_4">
            <xsl:choose>
                <xsl:when test="$var3langcode_3='|||'">
                    <xsl:value-of select="'und'"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$var3langcode_3"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="var3langcode_5">
            <xsl:call-template name="correctLanguageCode">
                <xsl:with-param name="c" select="$var3langcode_4"/>
            </xsl:call-template>
        </xsl:variable>
        <!-- concat -->
        <xsl:variable name="var3step3" select="concat($var3step1_pos1_35, $var3langcode_5, $var3step1_pos39_41)"/>
        <!-- create controlfield 008 -->
        <marc:controlfield tag="008">
            <xsl:value-of select="$var3step3"/>
        </marc:controlfield>
    </xls:template>
    <!-- step 041$a -->
    <xls:template match="marc:datafield[@tag='041']">
        <xsl:copy>
            <xsl:apply-templates select="@*"/>
            <xsl:variable name="count041a"
                          select="count(//marc:datafield[@tag='041']/marc:subfield[@code='a'])"/>
            <xsl:choose>
                <xsl:when test="$count041a=1">
                    <xsl:apply-templates select="//marc:datafield[@tag='041']/marc:subfield[@code!='a']"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates select="node()"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:copy>
    </xls:template>
    <!-- step 044$a -->
    <xls:template match="marc:datafield[@tag='044']">
        <xsl:copy>
            <xsl:apply-templates select="@*"/>
            <xsl:variable name="count044a"
                          select="count(//marc:datafield[@tag='044']/marc:subfield[@code='a'])"/>
            <xsl:choose>
                <xsl:when test="$count044a=1">
                    <xsl:apply-templates select="//marc:datafield[@tag='044']/marc:subfield[@code!='a']"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates select="node()"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:copy>
    </xls:template>
    <!-- step 245$a -->
    <xls:template match="marc:datafield[@tag='245']">
        <xsl:copy>
            <xsl:apply-templates select="@*"/>
            <xsl:variable name="var245_marcleader_pos7" select="substring(//marc:leader, 7, 1)"/>
            <xsl:variable name="var245_marcleader_pos8" select="substring(//marc:leader, 8, 1)"/>
            <xsl:variable name="var245_245a" select="//marc:datafield[@tag='245']/marc:subfield[@code='a']"/>
            <xsl:choose> <!-- 655a -->
                <xsl:when test="string-length($var245_245a)=0 and ( $var245_marcleader_pos7='g' or  $var245_marcleader_pos7='i' or  $var245_marcleader_pos7='k' or  $var245_marcleader_pos7='o' or  $var245_marcleader_pos7='r' )">
                    <!-- opmerking D, vierkante [] eromheen -->
                    <marc:subfield code="a">
	                    <!-- if title equals [] then show No Title else show value -->
	                    <xsl:call-template name="check245Title">
		                    <xsl:with-param name="title" select="concat('[', //marc:datafield[@tag='655']/marc:subfield[@code='a'], ']')"/>
	                    </xsl:call-template>
                    </marc:subfield>
                </xsl:when>
                <!-- 245k -->
                <xsl:when test="string-length($var245_245a)=0 and $var245_marcleader_pos8='s'">
                    <!-- TODO QUESTION: opmerking D, vierkante [] eromheen -->
                    <marc:subfield code="a">
	                    <!-- if title equals [] then show No Title else show value -->
	                    <xsl:call-template name="check245Title">
		                    <xsl:with-param name="title" select="concat('[', marc:subfield[@code='k'], ']')"/>
	                    </xsl:call-template>
                    </marc:subfield>
                </xsl:when>
                <!-- Opmerking C, als 245a bestaat dan moet origineel getoond worden -->
                <xsl:when test="string-length($var245_245a)>0">
                    <marc:subfield code="a">
                        <xsl:value-of select="$var245_245a"/>
                    </marc:subfield>
                </xsl:when>
            </xsl:choose>
            <xsl:apply-templates select="node()[@code!='a']"/>
        </xsl:copy>
    </xls:template>
    <!-- step 020$a (isbn) Opmerking F, zorgen dat voor code 'a' en code 'z' werkt -->
    <xls:template match="marc:datafield[@tag='020']/marc:subfield[@code='a' or @code='z']">
        <xsl:variable name="var020a_1">
            <xsl:call-template name="string-replace-all">
                <xsl:with-param name="text" select="text()"/>
                <xsl:with-param name="replace" select="'-'"/>
                <xsl:with-param name="by" select="''"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="var020a_2">
            <xsl:call-template name="string-replace-all">
                <xsl:with-param name="text" select="$var020a_1"/>
                <xsl:with-param name="replace" select="' '"/>
                <xsl:with-param name="by" select="''"/>
            </xsl:call-template>
        </xsl:variable>
        <marc:subfield>
            <xsl:attribute name="code">
                <xsl:value-of select="@code"/>
            </xsl:attribute>
            <xsl:value-of select="$var020a_2"/>
        </marc:subfield>
    </xls:template>
    <!-- invalid subfield codes, part 1, collector, designer, draughtsman, engraver, painter, photographer -->
	<!-- TODO met punt collector. ze moeten allemaal een punt krijgen ook de gene zonder -->
    <xls:template
            match="marc:datafield[@tag='100' or @tag='110' or @tag='600' or @tag='610' or @tag='648' or @tag='650' or @tag='655'or @tag='700' or @tag='710' or @tag='830']/marc:subfield[@code='collector']">
        <marc:subfield code="e">collector.</marc:subfield>
    </xls:template>
	<xls:template
			match="marc:datafield[@tag='100' or @tag='110' or @tag='600' or @tag='610' or @tag='648' or @tag='650' or @tag='655'or @tag='700' or @tag='710' or @tag='830']/marc:subfield[@code='collector.']">
		<marc:subfield code="e">collector.</marc:subfield>
	</xls:template>
    <xls:template
            match="marc:datafield[@tag='100' or @tag='110' or @tag='600' or @tag='610' or @tag='648' or @tag='650' or @tag='655' or @tag='700' or @tag='710' or @tag='830']/marc:subfield[@code='designer']">
        <marc:subfield code="e">designer.</marc:subfield>
    </xls:template>
	<xls:template
			match="marc:datafield[@tag='100' or @tag='110' or @tag='600' or @tag='610' or @tag='648' or @tag='650' or @tag='655' or @tag='700' or @tag='710' or @tag='830']/marc:subfield[@code='designer.']">
		<marc:subfield code="e">designer.</marc:subfield>
	</xls:template>
    <xls:template
            match="marc:datafield[@tag='100' or @tag='110' or @tag='600' or @tag='610' or @tag='648' or @tag='650' or @tag='655' or @tag='700' or @tag='710' or @tag='830']/marc:subfield[@code='draughtsman']">
        <marc:subfield code="e">draughtsman.</marc:subfield>
    </xls:template>
	<xls:template
			match="marc:datafield[@tag='100' or @tag='110' or @tag='600' or @tag='610' or @tag='648' or @tag='650' or @tag='655' or @tag='700' or @tag='710' or @tag='830']/marc:subfield[@code='draughtsman.']">
		<marc:subfield code="e">draughtsman.</marc:subfield>
	</xls:template>
    <xls:template
            match="marc:datafield[@tag='100' or @tag='110' or @tag='600' or @tag='610' or @tag='648' or @tag='650' or @tag='655' or @tag='700' or @tag='710' or @tag='830']/marc:subfield[@code='engraver']">
        <marc:subfield code="e">engraver.</marc:subfield>
    </xls:template>
	<xls:template
			match="marc:datafield[@tag='100' or @tag='110' or @tag='600' or @tag='610' or @tag='648' or @tag='650' or @tag='655' or @tag='700' or @tag='710' or @tag='830']/marc:subfield[@code='engraver.']">
		<marc:subfield code="e">engraver.</marc:subfield>
	</xls:template>
    <xls:template
            match="marc:datafield[@tag='100' or @tag='110' or @tag='600' or @tag='610' or @tag='648' or @tag='650' or @tag='655' or @tag='700' or @tag='710' or @tag='830']/marc:subfield[@code='painter']">
        <marc:subfield code="e">painter.</marc:subfield>
    </xls:template>
	<xls:template
			match="marc:datafield[@tag='100' or @tag='110' or @tag='600' or @tag='610' or @tag='648' or @tag='650' or @tag='655' or @tag='700' or @tag='710' or @tag='830']/marc:subfield[@code='painter.']">
		<marc:subfield code="e">painter.</marc:subfield>
	</xls:template>
	<xls:template
			match="marc:datafield[@tag='100' or @tag='110' or @tag='600' or @tag='610' or @tag='648' or @tag='650' or @tag='655' or @tag='700' or @tag='710' or @tag='830']/marc:subfield[@code='photographer']">
		<marc:subfield code="e">photographer.</marc:subfield>
	</xls:template>
	<xls:template
			match="marc:datafield[@tag='100' or @tag='110' or @tag='600' or @tag='610' or @tag='648' or @tag='650' or @tag='655' or @tag='700' or @tag='710' or @tag='830']/marc:subfield[@code='photographer.']">
		<marc:subfield code="e">photographer.</marc:subfield>
	</xls:template>

	<!-- 611 and 711: revert attribute and value -->
	<xls:template
			match="marc:datafield[@tag='611' or @tag='711']/marc:subfield[text()='e' and string-length(@code) >= 2]">

		<xsl:variable name="var_value_d" select="../marc:subfield[@code='d']"/>

		<xsl:choose>
			<!-- check if original d values is not zero long -->
			<xsl:when test="string-length($var_value_d) = 0">
				<!-- create d node -->
				<marc:subfield code="d"><xsl:value-of select="@code"/></marc:subfield>
			</xsl:when>
			<xsl:otherwise>
				<!-- keep original node -->
				<xsl:copy>
					<xsl:apply-templates select="@*|node()"/>
				</xsl:copy>
			</xsl:otherwise>
		</xsl:choose>

	</xls:template>

    <!-- replace function -->
    <xsl:template name="string-replace-all">
        <xsl:param name="text"/>
        <xsl:param name="replace"/>
        <xsl:param name="by"/>
        <xsl:choose>
            <xsl:when test="contains($text, $replace)">
                <xsl:value-of select="substring-before($text,$replace)"/>
                <xsl:value-of select="$by"/>
                <xsl:call-template name="string-replace-all">
                    <xsl:with-param name="text" select="substring-after($text,$replace)"/>
                    <xsl:with-param name="replace" select="$replace"/>
                    <xsl:with-param name="by" select="$by"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$text"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="marc:subfield[@code='']"/>
</xsl:stylesheet>
