<?xml version="1.0" encoding="UTF-8"?>
<!--
           DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
                   Version 2, December 2004

Copyright (C) 2015 Alexander Varchenko <alexander.varchenko@gmail.com>

Everyone is permitted to copy and distribute verbatim or modified
copies of this license document, and changing it is allowed as long
as the name is changed.

           DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
  TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION

 0. You just DO WHAT THE FUCK YOU WANT TO.

    bpmn2dot.xsl - transform BPMN2.0 process definition into DOT.
	Example for JPG output:
		 dot -Tjpg -oprocessimage.jpg processdefinition.dot
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:bpmn2dot="http://bpmn2.0_to_dot/converter">
	<xsl:output method="text" encoding="UTF-8" indent="no" omit-xml-declaration="yes"/>
	<xsl:strip-space elements="none"/>
	<xsl:preserve-space elements="*"/>
	<xsl:variable name="delims"> ,:-()[]</xsl:variable>
	<!-- xsl:variable name="replacements">____ xsl:variable -->
	<xsl:variable name="replacements"></xsl:variable>
	<xsl:variable name="graphtype">digraph</xsl:variable>
	<xsl:variable name="style-start-end">shape=oval;style="filled";center=true;color="#777777";fillcolor="gray";fontsize=12</xsl:variable>
	
	<xsl:template match="/">
		<!-- BPMN2.0 to dot files template -->
		<xsl:apply-templates select="process-definition">
		</xsl:apply-templates>
	</xsl:template>
	
	<xsl:template match="process-definition">
	<xsl:value-of select="$graphtype"/><xsl:text> </xsl:text><xsl:value-of select="translate(@name,$delims,$replacements)" />
	<xsl:text><![CDATA[ {
	//settings
	//rankdir="LR"
	graph [bgcolor="#ffffff"]
	node [shape=box3d;style=rounded;color="#777777";fontcolor="blue"]
	edge [color="#C1f474";fontcolor="#2f5f1f"]]]>
	</xsl:text>

		<xsl:apply-templates select="start-state">
			<xsl:with-param name="x-from" select="@name"></xsl:with-param>
		</xsl:apply-templates>
		
		<xsl:apply-templates select="task-node">
			<xsl:with-param name="x-from" select="@name"></xsl:with-param>
		</xsl:apply-templates>
		
		<xsl:apply-templates select="process-state">
			<xsl:with-param name="x-from" select="@name"></xsl:with-param>
		</xsl:apply-templates>
		
		<xsl:apply-templates select="transition">
			<xsl:with-param name="x-from" select="@name"></xsl:with-param>
		</xsl:apply-templates>
		
		<xsl:apply-templates select="decision">
			<xsl:with-param name="x-from" select="@name"></xsl:with-param>
		</xsl:apply-templates>
		
		<xsl:apply-templates select="fork">
			<xsl:with-param name="x-from" select="@name"></xsl:with-param>
		</xsl:apply-templates>

		<xsl:apply-templates select="join">
			<xsl:with-param name="x-from" select="@name"></xsl:with-param>
		</xsl:apply-templates>

		<xsl:apply-templates select="end-state" />
	<xsl:text>}</xsl:text>
	</xsl:template>
	
	<xsl:template match="start-state">
		<xsl:value-of select="translate(@name,$delims,$replacements)"/><xsl:text> [label=" </xsl:text><xsl:value-of select="@name"/><xsl:text> ";</xsl:text><xsl:value-of select="$style-start-end"/><xsl:text>];</xsl:text>
	<xsl:apply-templates select="transition">
		<xsl:with-param name="x-from" select="@name"></xsl:with-param>
	</xsl:apply-templates>
	</xsl:template>
	
	<xsl:template match="end-state">
		<xsl:value-of select="translate(@name,$delims,$replacements)"/><xsl:text> [label=" </xsl:text><xsl:value-of select="@name"/><xsl:text> ";</xsl:text><xsl:value-of select="$style-start-end"/><xsl:text>];</xsl:text>
	</xsl:template>
	
	<xsl:template match="task-node">
		<xsl:value-of select="translate(@name,$delims,$replacements)" /><xsl:text> [label=" </xsl:text><xsl:apply-templates select="task" /><xsl:text> "];</xsl:text>
		<xsl:apply-templates select="transition">
			<xsl:with-param name="x-from" select="@name"></xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>
	
	<xsl:template match="task">
		<xsl:choose>
			<xsl:when test="@description">
				<xsl:value-of select="normalize-space(@description)" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="normalize-space(./description/text())" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="process-state">

	<xsl:value-of select="translate(@name,$delims,$replacements)" /><![CDATA[ [shape=component;label="]]><xsl:value-of select="@name" /><![CDATA["];]]>
	<xsl:apply-templates select="sub-process" />
	<xsl:apply-templates select="transition">
		<xsl:with-param name="x-from" select="@name"></xsl:with-param>
	</xsl:apply-templates>
	</xsl:template>
	
	<xsl:template match="sub-process">
		<![CDATA[//sub-process
		]]>
	</xsl:template>
	
	<xsl:template match="transition">

		<xsl:param name="x-from"></xsl:param>
		<xsl:value-of select="translate($x-from,$delims,$replacements)" /><![CDATA[ -> ]]><xsl:value-of select="translate(@to,$delims,$replacements)" /><![CDATA[ [label="  ]]><xsl:value-of select="@name" /><![CDATA[  "];]]>
	</xsl:template>
	
	<xsl:template match="decision">

		<xsl:value-of select="translate(@name,$delims,$replacements)" />
		<xml:text> [shape=diamond;label="</xml:text><xsl:value-of select="@name" /><xml:text>"];</xml:text>
	<xsl:apply-templates select="transition">
		<xsl:with-param name="x-from" select="@name"></xsl:with-param>
	</xsl:apply-templates>
	</xsl:template>

	<xsl:template match="fork">

		<xsl:value-of select="translate(@name,$delims,$replacements)" />
		<xml:text> [shape=invhouse;label="</xml:text><xsl:value-of select="@name" /><xml:text>"];</xml:text>
	<xsl:apply-templates select="transition">
		<xsl:with-param name="x-from" select="@name"></xsl:with-param>
	</xsl:apply-templates>
	</xsl:template>

	<xsl:template match="join">

		<xsl:value-of select="translate(@name,$delims,$replacements)" />
		<xml:text> [shape=house;label="</xml:text><xsl:value-of select="@name" /><xml:text>"];</xml:text>
	<xsl:apply-templates select="transition">
		<xsl:with-param name="x-from" select="@name"></xsl:with-param>
	</xsl:apply-templates>
	</xsl:template>
	
</xsl:stylesheet>
