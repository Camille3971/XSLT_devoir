<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0"
    version="2.0">
    
    
        <!-- Mes variables -->
    <!-- Ma variable HEAD -->
    <xsl:variable name="head">
        <head>
            <title><xsl:value-of select="(//teiHeader)[1]/fileDesc/titleStmt/title[1]"/></title>
            <link rel="stylesheet" type="text/css" href="styles.css"/>
        </head>
    </xsl:variable>
    
    <!-- Ma variable HEADER -->
    <xsl:variable name="header">
        <header>
            <h1>
                <xsl:value-of select="(//teiHeader)[1]/fileDesc/titleStmt/title[1]"/>
            </h1>
            <nav>
                <ul>
                    <li><a href="index.html">Accueil</a></li>
                    <xsl:for-each select="//TEI">
                        <li><a href="{concat('fable',@n, '.html')}">Fable <xsl:value-of select="@n"/></a> </li>
                    </xsl:for-each>
                </ul>
            </nav>
        </header>
    </xsl:variable>
    
    <!-- Ma variable AUTEUR -->
    <xsl:variable name="auteur"> <xsl:value-of select="concat
        (((//teiHeader)[1]//titleStmt/author//forename), ' ',upper-case((//teiHeader)[1]//titleStmt/author//surname))"/>
    </xsl:variable>
        
    
    
             <!-- Mes templates -->
    
        <!-- Mon template qui génère la page d'accueil -->
        <xsl:template name="index">
            <xsl:result-document href="index.html" method="html" indent="yes">
                <html>
                    <xsl:copy-of select="$head"/>
                    <body>
                        <xsl:copy-of select="$header"/>
                        <!-- Illustration -->
                        <img src="Lafontaine.PNG" alt="Portrait de Jean de La Fontaine" />
                        <!-- Informations -->
                        <p>Cette édition numérique est proposée par 
                            <xsl:value-of select="concat((//teiHeader)[1]//editor//forename, ' ', upper-case((//teiHeader)[1]//editor//surname), ' : ',(//teiHeader)[1]//editor//email)"/>.
                            <xsl:value-of select="(//teiHeader)[1]//licence"/><xsl:value-of select="(//teiHeader)[1]//projectDesc"/><xsl:value-of select="(//teiHeader)[1]//editorialDescl"/>
                        </p>
                        <p> <xsl:value-of select="(//teiHeader)[1]//editorialDesc"/></p>
                    </body>
                </html>
            </xsl:result-document>
        </xsl:template>
        
     <!-- Mon template qui génère les pages fables -->
    <xsl:template name="fable">
        <xsl:param name="fable-node"/>
        <xsl:result-document href="{concat('fable', $fable-node/@n, '.html')}" method="html" indent="yes">
            <html>
                <xsl:copy-of select="$head"/>
                <body>
                    <xsl:copy-of select="$header"/>
                    
                    <!-- Titre de la fable -->
                    <h1>
                        <xsl:value-of select="$fable-node//titleStmt/title"/>
                    </h1>
                    
                    <!-- Auteur -->
                    <p class="author"><xsl:copy-of select="$auteur"/>
                    </p>
                    
                    <!-- Date de publication -->
                    <p class="date">
                        <xsl:value-of select="$fable-node//sourceDesc//date"/>
                    </p>
                    
                    <!-- Corps de la fable -->
                    <div class="fable">
                        <xsl:for-each select="$fable-node//lg[@type='stanza']">
                            <p class="strophe">
                                <xsl:if test="@subtype='morale'">
                                    <span class="morale"> Cette strophe est une morale.</span><br/>
                                </xsl:if>
                                <xsl:for-each select="l">
                                    <span>
                                        <xsl:attribute name="class">
                                            <xsl:choose>
                                                <xsl:when test="@met='octosyllabe'">octosyllabe</xsl:when>
                                                <xsl:when test="@met='alexandrin'">alexandrin</xsl:when>
                                                <xsl:otherwise>autre</xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:attribute>
                                        <xsl:value-of select="."/><br/>
                                    </span>
                                </xsl:for-each>
                            </p>
                        </xsl:for-each>
                    </div>
                    <!-- Retour à l'accueil -->
                    <p><a href="index.html">Retour à l'accueil</a></p>
                </body>
            </html>
        </xsl:result-document>
    </xsl:template>
    
    
  
    <!-- Mon template principal -->
    <xsl:template match="/">
        
        <!-- Générer la page d'accueil -->
        <xsl:call-template name="index"/>
        
        <!-- Générer les fables -->
        <xsl:for-each select="//TEI">
            <xsl:call-template name="fable">
                <xsl:with-param name="fable-node" select="."/>
            </xsl:call-template>
        </xsl:for-each>
    </xsl:template>

</xsl:stylesheet>