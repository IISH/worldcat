#!/usr/bin/perl
#
# batman.pl provides batch update operations.
#
# Copyright (c) 2014-2015  International Institute of Social History
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
#
# Author: Lucien van Wouw <lwo@iisg.nl>
#
#
# This script will take all scheduled batch records from a table. For each batch the specified reports is loaded and it's tcns collected.
# An xslt transformation is applied to each bibliographic marc field. If different from the original, it will be stored.
# Only one batch process is allowed to run at any one time. It will not spawn multiple threats.
#
# I am not sure how to deploy this within the make distribution.... so I placed it under the support scripts.

use strict;
use warnings;
use DBI;
use FileHandle;
use Getopt::Long;
use OpenSRF::EX qw/:try/;
use OpenSRF::Utils::JSON;
use OpenSRF::Utils qw/:daemon/;
use OpenSRF::Utils::Logger qw/$logger/;
use OpenSRF::System;
use OpenSRF::AppSession;
use OpenSRF::Utils::SettingsClient;
use Email::Send;
use OpenILS::Application::AppUtils;
use Text::CSV ;
use Scalar::Util qw(looks_like_number);
use FindBin;
use FindBin qw($Bin);


use open ':utf8';

my $U = "OpenILS::Application::AppUtils";
use XML::LibXML;
use XML::LibXSLT;

#
# Instantiate the XML and XSLT packages
my $_xml_parser = new XML::LibXML;
my $_xslt_parser = new XML::LibXSLT;


my $xslt_1 = $_xslt_parser->parse_stylesheet($_xml_parser->parse_string(<<'XSLT1'));
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
XSLT1
my $xslt_2 = $_xslt_parser->parse_stylesheet($_xml_parser->parse_string(<<'XSLT2'));
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
XSLT2
my $xslt_3 = $_xslt_parser->parse_stylesheet($_xml_parser->parse_string(<<'XSLT3'));
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
XSLT3
my $xslt_4 = $_xslt_parser->parse_stylesheet($_xml_parser->parse_string(<<'XSLT4'));
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
XSLT4
my $xslt_5 = $_xslt_parser->parse_stylesheet($_xml_parser->parse_string(<<'XSLT5'));
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:marc="http://www.loc.gov/MARC21/slim"
                xmlns:xls="http://www.w3.org/1999/XSL/Transform">

	<xsl:template match="@*|node()">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>

	<!-- fix invalid indicator -->
	<xls:template match="marc:datafield">
		<xsl:variable name="var_ind1" select="@ind1"/>
		<xsl:variable name="var_ind2" select="@ind2"/>

		<marc:datafield>
			<xsl:attribute name="ind1">
			<xsl:choose>
				<xsl:when test="string-length($var_ind1) = 0"><xsl:value-of select="' '"/></xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$var_ind1"/>
				</xsl:otherwise>
			</xsl:choose>
			</xsl:attribute>

			<xsl:attribute name="ind2">
				<xsl:choose>
					<xsl:when test="string-length($var_ind2) = 0"><xsl:value-of select="' '"/></xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$var_ind2"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>

			<xsl:attribute name="tag">
				<xsl:value-of select="@tag"/>
			</xsl:attribute>

			<xsl:apply-templates select="node()"/>

		</marc:datafield>
	</xls:template>

</xsl:stylesheet>
XSLT5
my $xslt_6 = $_xslt_parser->parse_stylesheet($_xml_parser->parse_string(<<'XSLT6'));
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:marc="http://www.loc.gov/MARC21/slim"
                xmlns:xls="http://www.w3.org/1999/XSL/Transform">

	<xsl:template match="@*|node()">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>

	<!-- replace pipes -->
	<xls:template match="marc:controlfield[@tag='008']">
		<xsl:variable name="var_008_pipes" select="text()"/>

		<xsl:variable name="var_008_spaces">
			<xsl:call-template name="string-replace-all">
				<xsl:with-param name="text" select="$var_008_pipes"/>
				<xsl:with-param name="replace" select="'|'"/>
				<xsl:with-param name="by" select="' '"/>
			</xsl:call-template>
		</xsl:variable>

		<xsl:copy>
			<xsl:attribute name="tag">
				<xsl:value-of select="@tag"/>
			</xsl:attribute>
			<xsl:value-of select="$var_008_spaces"/>
		</xsl:copy>
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

</xsl:stylesheet>
XSLT6
my $xslt_7 = $_xslt_parser->parse_stylesheet($_xml_parser->parse_string(<<'XSLT7'));
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:marc="http://www.loc.gov/MARC21/slim">
    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="marc:datafield[not(marc:subfield)]"/>
</xsl:stylesheet>
XSLT7



#
# The fingerprint is used for comparing the source and end result of the transformation
my $xslt_fingerprint = $_xslt_parser->parse_stylesheet($_xml_parser->parse_string(<<'XSLT'));
<xsl:stylesheet version="1.0"
               xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
               xmlns="http://www.loc.gov/MARC21/slim"
               xmlns:marc="http://www.loc.gov/MARC21/slim"
       exclude-result-prefixes="marc">
   <xsl:output omit-xml-declaration="yes" indent="no"/>

   <xsl:template match="marc:record">
           <xsl:value-of select="concat('\\leader', marc:leader)"/>
           <xsl:for-each select="marc:controlfield">
               <xsl:value-of select="concat('\\', @tag, '  ', text())"/>
           </xsl:for-each>
           <xsl:for-each select="marc:datafield">
               <xsl:value-of select="concat('\\', @tag, @ind1, @ind2)"/>
               <xsl:for-each select="marc:subfield">
                   <xsl:value-of select="concat('$', @code, text())"/>
               </xsl:for-each>
           </xsl:for-each>
   </xsl:template>

</xsl:stylesheet>
XSLT



# A dummy marc record for trying out the transformation with.
my $dummy_marc = <<'XML';
<record xmlns="http://www.loc.gov/MARC21/slim">
    <leader>01142cam  2200301 a 4500</leader>
    <controlfield tag="001">   92005291 </controlfield>
    <controlfield tag="003">DLC</controlfield>
    <controlfield tag="005">19930521155141.9</controlfield>
    <controlfield tag="008">920219s1993    caua   j      000 0 eng  </controlfield>
    <datafield tag="010" ind1=" " ind2=" ">
        <subfield code="a">   92005291 </subfield>
    </datafield>
    <datafield tag="020" ind1=" " ind2=" ">
        <subfield code="a">0152038655 :</subfield>
        <subfield code="c">$15.95</subfield>
    </datafield>
    <datafield tag="040" ind1=" " ind2=" ">
        <subfield code="a">DLC</subfield>
        <subfield code="c">DLC</subfield>
        <subfield code="d">DLC</subfield>
    </datafield>
    <datafield tag="042" ind1=" " ind2=" ">
        <subfield code="a">lcac</subfield>
    </datafield>
    <datafield tag="050" ind1="0" ind2="0">
        <subfield code="a">PS3537.A618</subfield>
        <subfield code="b">A88 1993</subfield>
    </datafield>
    <datafield tag="082" ind1="0" ind2="0">
        <subfield code="a">811/.52</subfield>
        <subfield code="2">20</subfield>
    </datafield>
    <datafield tag="100" ind1="1" ind2=" ">
        <subfield code="a">Sandburg, Carl,</subfield>
        <subfield code="d">1878-1967.</subfield>
    </datafield>
    <datafield tag="245" ind1="1" ind2="0">
        <subfield code="a">Arithmetic /</subfield>
        <subfield code="c">Carl Sandburg ; illustrated as an anamorphic adventure by Ted Rand.</subfield>
    </datafield>
    <datafield tag="250" ind1=" " ind2=" ">
        <subfield code="a">1st ed.</subfield>
    </datafield>
    <datafield tag="260" ind1=" " ind2=" ">
        <subfield code="a">San Diego :</subfield>
        <subfield code="b">Harcourt Brace Jovanovich,</subfield>
        <subfield code="c">c1993.</subfield>
    </datafield>
    <datafield tag="300" ind1=" " ind2=" ">
        <subfield code="a">1 v. (unpaged) :</subfield>
        <subfield code="b">ill. (some col.) ;</subfield>
        <subfield code="c">26 cm.</subfield>
    </datafield>
    <datafield tag="500" ind1=" " ind2=" ">
        <subfield code="a">One Mylar sheet included in pocket.</subfield>
    </datafield>
    <datafield tag="520" ind1=" " ind2=" ">
        <subfield code="a">A poem about numbers and their characteristics. Features anamorphic, or distorted, drawings which can be restored to normal by viewing from a particular angle or by viewing the image's reflection in the provided Mylar cone.</subfield>
    </datafield>
    <datafield tag="650" ind1=" " ind2="0">
        <subfield code="a">Arithmetic</subfield>
        <subfield code="x">Juvenile poetry.</subfield>
    </datafield>
    <datafield tag="650" ind1=" " ind2="0">
        <subfield code="a">Children's poetry, American.</subfield>
    </datafield>
    <datafield tag="650" ind1=" " ind2="1">
        <subfield code="a">Arithmetic</subfield>
        <subfield code="x">Poetry.</subfield>
    </datafield>
    <datafield tag="650" ind1=" " ind2="1">
        <subfield code="a">American poetry.</subfield>
    </datafield>
    <datafield tag="650" ind1=" " ind2="1">
        <subfield code="a">Visual perception.</subfield>
    </datafield>
    <datafield tag="700" ind1="1" ind2=" ">
        <subfield code="a">Rand, Ted,</subfield>
        <subfield code="e">ill.</subfield>
    </datafield>
</record>
XML


#
# Schema validator for our marc
my $xmlschema = XML::LibXML::Schema->new( location => $Bin . '/marc21slim.xsd' );


#
# Pause in seconds between checking for new batch tasks
my $UPDATE_STATUS_INTERVAL = 10;


#
# Number of minutes a heartbeat is set from now. This is used to detect stale batch tasks
my $HEARTBEAT_INTERVAL = 5;


#
# Load settings
my ($count, $config, $sleep_interval, $lockfile, $daemon) = (1, '/openils/conf/opensrf_core.xml', 10, '/tmp/batch-LOCK');

GetOptions(
	"daemon"	=> \$daemon,
	"sleep=i"	=> \$sleep_interval,
	"bootstrap=s"	=> \$config,
	"lockfile=s"	=> \$lockfile,
);

if (-e $lockfile) {
	die "I seem to be running already. If not, remove $lockfile and try again\n";
}

OpenSRF::System->bootstrap_client( config_file => $config );

my %data_db;

my $sc = OpenSRF::Utils::SettingsClient->new;

$data_db{db_driver} = $sc->config_value( apps => 'open-ils.storage' => app_settings => databases => 'driver' );
$data_db{db_host}   = $sc->config_value( apps => 'open-ils.storage' => app_settings => databases => database => 'host' );
$data_db{db_port}   = $sc->config_value( apps => 'open-ils.storage' => app_settings => databases => database => 'port' );
$data_db{db_name}   = $sc->config_value( apps => 'open-ils.storage' => app_settings => databases => database => 'db' );
$data_db{db_user}   = $sc->config_value( apps => 'open-ils.storage' => app_settings => databases => database => 'user' );
$data_db{db_pw}     = $sc->config_value( apps => 'open-ils.storage' => app_settings => databases => database => 'pw' );

die "Unable to retrieve database connection information from the settings server"
    unless ( $data_db{db_driver} && $data_db{db_host} && $data_db{db_port} && $data_db{db_name} && $data_db{db_user});

my $email_server     = $sc->config_value( email_notify => 'smtp_server' );
my $email_sender     = $sc->config_value( email_notify => 'sender_address' );
my $success_template = $Bin . '/batman-success';
my $fail_template    = $Bin . '/batman-fail';
my $base_uri         = $sc->config_value( reporter => setup => 'base_uri' );
my $output_base      = $sc->config_value( reporter => setup => files => 'output_base' );

my $data_dsn  = "dbi:" .  $data_db{db_driver} . ":dbname=" .  $data_db{db_name} .';host=' .  $data_db{db_host} . ';port=' .  $data_db{db_port};

my ($dbh, $running, $sth, @reports, $run);

sub message {
    my @messages = (
	    "Mr. Freeze, give yourself up. We can get help for you... medical help!",
        "Why is a woman in love like a welder? Because they both carry a torch!",
        "No use, Joker! I knew you'd employ your sneezing powder, so I took an Anti-Allergy Pill! Instead of a SNEEZE, I've caught YOU, COLD!'",
        "It's Alfred's emergency belt-buckle Bat-call signal! He's in trouble!'",
        "I never touch spirits. Have you some milk?'",
        "Come on, Robin, to the Bat Cave! There's not a moment to lose!'",
        "It was noble of that animal to hurl himself into the path of that final torpedo. He gave his life for ours'",
        "An older head can't be put on younger shoulders.'",
        "Stop fiddling with that atomic pile and come down here!'",
        "Careful, Robin. Both hands on the Bat-rope.'",
        "Remember Robin, always look both ways.'",
        "Of course, Robin. Even crime-fighters must eat. And especially you. You're a growing boy and you need your nutrition.'",
        "Better three hours too soon than a minute too late.'",
        "It's sometimes difficult to think clearly when you're strapped to a printing press.'",
        "This is torture, at its most bizarre and terrible.'",
        "If you can't spend it, money's just a lot of worthless paper, isn't it?'",
        "Since there is no life on Mars as we know it, there can be no intelligible Marsish language.'",
        "Whatever is fair in love and war is also fair in crime fighting.'",
        "Planting a time bomb in a local library is a felony.'",
        "Ka-Pow !"
    ) ;

    my $message = $messages[rand @messages] ;
    $logger->info($message);
    return 'Batman: "' . $message . '"';
}


#
# Create fork if needed
if ($daemon) {
	open(F, ">$lockfile") or die "Cannot write lockfile '$lockfile'";
	print F $$;
	close F;
	daemonize(message());
}


#
# From here on loop:
DAEMON:

$dbh = DBI->connect(
	$data_dsn,
	$data_db{db_user},
	$data_db{db_pw},
	{ AutoCommit => 1,
	  pg_expand_array => 0,
	  pg_enable_utf8 => 1,
	  RaiseError => 1
	}
);


# Cancel any orphaned tasks where status(2)=running with an expired heartbeat value
#
$dbh->do(<<'SQL');
        UPDATE batch.schedule SET
            start_time = NULL,
            heartbeat_time = NULL,
            status = 4,
            error_code = 1,
            error_text = 'The heartbeat expired. Maybe the server or batch daemon restarted ? Re-queue this record to try again.'
        WHERE
            status = 2 AND heartbeat_time < now();
SQL


#
# make sure we're not already running $count reports
# status(2) = actively running
($running) = $dbh->selectrow_array(<<'SQL');
SELECT	count(*)
  FROM	batch.schedule
  WHERE	status = 2;
SQL

if ($count <= $running) {
    if ($daemon) {
    		$dbh->disconnect;
    		sleep 1;
    		POSIX::waitpid( -1, POSIX::WNOHANG );
    		sleep $sleep_interval;
    		goto DAEMON;
    }
    log_it("Already running maximum ($running) concurrent batches");
    exit 1;
}


#
# Number of slots.
# We'll pick one from the list. We will not use the open slot $run variable.
$run = $count - $running;
log_it("Available candidates: " . $run) ;
my $r = $dbh->selectrow_hashref(<<'SQL', {}, 1);
SELECT
    *
FROM
	batch.schedule
  WHERE
    status = 1 AND run_time < now()
  ORDER BY
    run_time
  LIMIT ?;
SQL

my ($id, $runner, $report_url, $xslt, $repeat, $email);
if ( $r ) {
    $id = $r->{id} ;
    $runner = $r->{runner};
    $report_url = $r->{report_url};
    $xslt = $r->{xslt};
    $repeat = $r->{repeat};
    $email = $r->{email};
} else {
    sleep 1;
    POSIX::waitpid( -1, POSIX::WNOHANG );
    sleep $sleep_interval;
    goto DAEMON if ($daemon);
    exit 0 ;
}


if (safe_fork()) {
    # Wait and retry.
} else {

    # Spawn a child
    daemonize(message());

    # Open database connection for this child.
    $logger->info("Running a batch for $id");
    my $data_dbh = DBI->connect(
        $data_dsn,
        $data_db{db_user},
        $data_db{db_pw},
        { AutoCommit => 1,
          pg_expand_array => 0,
          pg_enable_utf8 => 1,
          RaiseError => 1
        }
    );


    # set start_time and status
    $data_dbh->do(<<'SQL',{}, $HEARTBEAT_INTERVAL, $id);
        UPDATE
            batch.schedule
        SET
            start_time = now(),
            status = 2,
            records_changed = 0,
            records_unchanged = 0,
            records_failed = 0,
            records_total = 0,
            heartbeat_time = now() + (? * interval '1 minute'),
            error_code = 0,
            error_text = NULL
        WHERE
            id = ?;
SQL

    # Get the file from the last four parts of the url: https://a/b/c/d/e/1/2/report-data.csv
    unless ( $report_url =~ m/(\/\d*\/\d*\/\d*\/.*\.csv$)/ ) {
        my $e = 'Parsing url failed. I expect something that ends with /number/number/number/report-data.csv but I got ' . $report_url;
        error_exit($e, $id, $data_dbh, $email, $report_url);
    }
    my $file = $output_base . $1;
    unless ( -f $file ) {
        my $e = 'No such file: ' . $file ;
        error_exit( $e, $id, $data_dbh, $email, $report_url );
    }


    # Start logging to a file
    my $fh_debug = new FileHandle (">$file.batch.log") or die "Cannot write to '$file.batch.log'";
    log_it("Starting batch id(${id}) by runner(${runner}) for file(${file}) with xslt(${xslt})");


    # Load the xml into a stylesheet
    my $stylesheet;
    try {
        my $xml = $_xml_parser->parse_string( $xslt ) ;
        $stylesheet = $_xslt_parser->parse_stylesheet( $xml ) ;
    } otherwise {
        my $e = 'Parsing stylesheet failed. Correct the error and try again. The exception was ' . shift() ;
        error_exit($e, $id, $data_dbh, $email, $report_url, $fh_debug);
    };


    # Use a dummy ( but valid ) marc record to try out and see if the transformation is valid.
    try {
        my $new_marc = transform( $dummy_marc, $stylesheet ) ;
        $xmlschema->validate( $_xml_parser->parse_string($new_marc) );
    } otherwise {
        my $e = 'This stylesheet produces invalid XML or invalid MARC: ' . shift() ;
        error_exit($e, $id, $data_dbh, $email, $report_url, $fh_debug);
    };


    # Now open the report and for each line, find the tcn and store the value;
    my $csv = Text::CSV->new ({
      quote_char    => '"',
      sep_char      => ',',    # not really needed as this is the default
            binary => 1
    });

    my @tcns;
    open(my $data, '<:encoding(utf8)', $file) ;
    my $header = $csv->getline( $data ) ;
    my @array = @$header ;
    my ( $tcn_index ) = grep { $array[$_] eq 'TCN Value' } 0..$#array;
    $tcn_index = 0 unless ( $tcn_index ) ;
    while (my $fields = $csv->getline( $data )) {
        my $tcn = $fields->[$tcn_index] ;
        if ( looks_like_number( $tcn ) ) {
            unless ($tcn eq -1) {push @tcns, $tcn ;}
        } else {
            if ( $tcn ) { # We ignore blank, but everything else is a problem
                my $e = 'TCN value is not a number: ' . $tcn ;
                error_exit($e, $id, $data_dbh, $email, $report_url, $fh_debug);
            }
        }
    }
    if (not $csv->eof) {
        my $e = $csv->error_diag();
        error_exit($e, $id, $data_dbh, $email, $report_url, $fh_debug);
    }
    close $data;



    # Read in and parse each marc file
    my ($records_changed, $records_unchanged, $records_failed, $records_total) = (0, 0, 0, 0);
    foreach my $tcn (@tcns) {
        my $bre = $data_dbh->selectrow_hashref(<<'SQL', {}, $tcn);
            SELECT
                marc
            FROM
                biblio.record_entry
            WHERE
                id = ?
            LIMIT 1;
SQL


    # Apply the transformation and keep the before and after states
    my $marc = $bre->{marc} ;
    my $before = transform( $marc,     $xslt_fingerprint ) ;
    my $valid = 0; # invalid
    my $new_marc;
    try {
        $new_marc = transform($marc, $xslt_1);
        $new_marc = transform($new_marc, $xslt_2);
        $new_marc = transform($new_marc, $xslt_3);
        $new_marc = transform($new_marc, $xslt_4);
        $new_marc = transform($new_marc, $xslt_5);
        $new_marc = transform($new_marc, $xslt_6);
        $new_marc = transform($new_marc, $xslt_7);

        $valid = 1;
    } otherwise {
        my $e = 'tcn(' . $tcn . '): There was an error whilst transforming the marc data. The exception was ' . shift() ;
        log_it($e, $fh_debug);
    };


    if ( $valid ) {
        # Validate the MarcXML
        try {
            $xmlschema->validate( $_xml_parser->parse_string($new_marc) );
        } otherwise {
            $valid = 0 ;
            my $e = 'tcn(' . $tcn . '): The new the marc data is not valid marc21 XML. The exception was ' . shift() ;
            log_it($e, $fh_debug);
            log_it('Rejected: ' . $new_marc, $fh_debug);
        };
    }


    # Update the marc record. SQL Insert...
    $records_total++;
    if ( $valid ) {
        my $after = transform( $new_marc, $xslt_fingerprint ) if ($new_marc) ;
        if ($before eq $after) {
            log_it("tcn ${tcn} : no change" );
            $records_unchanged++;
        } else {
            try {
                $data_dbh->do(<<'SQL',{}, $U->entityize($new_marc), $tcn);
                    UPDATE
                        biblio.record_entry
                    SET
                        edit_date = now(),
                        marc = ?
                    WHERE
                        id = ?;
SQL
                log_it("tcn ${tcn} : updated" );
                $records_changed++;
            } otherwise {
                $records_failed++;
                my $e = 'tcn(' . $tcn . '): There was an error whilst saving the marc data into the database. The exception was ' . shift() ;
                log_it($e, $fh_debug);
            };
        }
    } else {
        $records_failed++;
    }


    # Give a heartbeat with status
    my $update_status = $records_total % $UPDATE_STATUS_INTERVAL ;
    if ( $update_status == 0 || $records_total == scalar @tcns) {
        $data_dbh->do(<<'SQL',{}, $records_changed, $records_unchanged, $records_failed, $records_total, $HEARTBEAT_INTERVAL, $id);
            UPDATE
                batch.schedule
            SET
                records_changed = ?,
                records_unchanged = ?,
                records_failed = ?,
                records_total = ?,
                heartbeat_time = now() + (? * interval '1 minute')
            WHERE
                id = ?;
SQL
        }

}


    #
    # Done work
    $repeat = 0 unless ($repeat) ;
    my $status = ($repeat) ? 1 :  3;
    $data_dbh->do(<<'SQL',{}, $status, $repeat, $id);
        UPDATE
            batch.schedule
        SET
        	complete_time = now(),
        	status = ?,
        	heartbeat_time = NULL,
        	run_time = now() + (? * interval '1 day')
        WHERE
            id = ?;
SQL

    log_it("records_changed = records_total=$records_total\nrecords_failed=$records_failed\n$records_changed\nrecords_unchanged=$records_unchanged\n");
    log_it('Done', $fh_debug) ;
    $data_dbh->disconnect;
    $fh_debug->close;

    notify($email, $report_url, $success_template);

    exit 0; # leave the child
}


if ($daemon) {
	sleep 1;
	POSIX::waitpid( -1, POSIX::WNOHANG );
	sleep $sleep_interval;
	goto DAEMON;
}

exit 0; # Exit as we are not a daemon

# parse the text into xml. Apply the stylesheet. Return the result without CrLfs.
sub transform {

    my $marc_text = shift ;
    my $stylesheet = shift ;

    my $marc_xml = $_xml_parser->parse_string( $marc_text ) ;
    my $result = $stylesheet->transform( $marc_xml );
    my $xml = $stylesheet->output_as_chars($result) ;
    $xml =~ s/\R//g;
    return $xml;
}



sub error_exit {

    my $error_text      = shift ;
    my $id              = shift ;
    my $dbh             = shift ;
    my $email           = shift ;
    my $report_url      = shift ;
    my $fh_debug        = shift ;

    log_it($error_text, $fh_debug) ;
    $dbh->do(<<'SQL',{}, $error_text, $id);
        UPDATE	batch.schedule
          SET status = 4,
            error_text = ?,
            error_code = 2,
            complete_time = now()
          WHERE id = ?;
SQL

    $dbh->disconnect;
    $fh_debug->close if ($fh_debug);

    notify($email, $report_url . 'batch.log', $fail_template);

    exit 1;
}

sub log_it {

    my $log = gmtime() . ' ' . shift ;
    my $fh_debug = shift ;

    print $fh_debug $log . "\n" if ($fh_debug);
    $logger->debug($log);
}

sub notify {
	my $email = shift;
	my $url = shift;
    my $template = shift ;

	return unless ( $email ) ;

	try {
	    open F, $template ;
	} otherwise {
	    my $e = shift ;
	    $logger->error($e);
	    return;
	};

	my $tmpl = join('',<F>);
	close F;

	$tmpl =~ s/{TO}/$email/smog;
	$tmpl =~ s/{FROM}/$email_sender/smog;
	$tmpl =~ s/{REPLY_TO}/$email_sender/smog;
	$tmpl =~ s/{OUTPUT_URL}/$url/smog;

	my $sender = Email::Send->new({mailer => 'SMTP'});
	$sender->mailer_args([Host => $email_server]);

	try {
	    $sender->send($tmpl);
	} otherwise {
        my $e = shift ;
        $logger->error($e);
    };
}






