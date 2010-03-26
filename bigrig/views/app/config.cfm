<cfoutput>
<cftry>

<div class="description">
	<p>The BigRig applicaton installer will parse the config/plugins/bigrig/appRoutes.cfm file for calls to appRoute() and let you control them through a web interface(only available in design and maintenance modes). You can control what folders are wheels enabled by code, or by using this form.</p>
	<p>This form simply automates the bits of coding required to add more wheels enabled folders to an application.</p>
</div>
<cfif flashKeyExists("bigrigInstall")>
	<strong>Installer requires the appRoutes.cfm file to work.</strong>
<cfelse>
#startFormTag(action="save", class="properties")#
<div class="item template">
	#textfieldTag(name="appRoutes[name]", value="", label="Name: ")#
	#textfieldTag(name="appRoutes[keyword]", value="", label="Keyword: ")#
	#textfieldTag(name="appRoutes[path]", value="", label="Path: ")#
</div>
<cfloop array="#$getAppDefinitions().appRoutes#" index="appRoute">
	<div class="item #cycle("odd,even")#">
		#textfieldTag(name="appRoutes[name]", value=appRoute.name, label="Name: ")#
		<cfif NOT structKeyExists(appRoute, "keyword")>
			<cfset appRoute.keyword = "">
		</cfif>
		#textfieldTag(name="appRoutes[keyword]", value=appRoute.keyword, label="Keyword: ")#
		<cfif NOT structKeyExists(appRoute, "path")>
			<cfset appRoute.path = "">
		</cfif>
		#textfieldTag(name="appRoutes[path]", value=appRoute.path, label="Path: ")#
	</div>
</cfloop>
<a href="##add" class="add">Add new Application Folder</a>
#submitTag()#
#endFormTag()#
</cfif>

<cfcatch>
<cfdump label="config.cfm" var="#cfcatch#">
</cfcatch>
</cftry>
</ul>

</cfoutput>