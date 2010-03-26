<cfparam name="params.docs" default="info">

<cfinclude template="views/docs/_header.cfm" />

<cfoutput>
<div style="float: right;padding-top: 8px;">
	#linkTo(text="home")# >
	<cfif NOT params.docs IS "info">
		#linkTo(params="wheels&view=plugins&name=bigrig", text="bigrig")# > #params.docs#
	<cfelse>
		bigrig
	</cfif>
</div>
</cfoutput>

<h1>BigRig</h1>

<!--- check if the plugin settings exist in the config/plugins/bigrig folder if not, make the appRoute.cfm file with initial content --->
<cfif NOT fileExists(expandPath('config/plugins/bigrig/appRoutes.cfm'))>
	<!--- check if the folder exists, if not make it --->
	<cfif NOT directoryExists(expandPath("config/plugins/bigrig/"))>
		<cfif NOT isDefined("params.bigrig.createRoutesFile")>
			<cfset flashInsert(bigrigInstall='#startFormTag(params="controller=wheels&action=wheels&view=plugins&name=bigrig&docs=#params.docs#")# #checkboxTag(name="bigrig[createRoutesFile]", labelPlacement="after", label=" Create BigRig route file?")# #submitTag("Create File")##endFormTag()#(/config/plugins/bigrig/appRoutes.cfm)') />
		<cfelse>
			<cfif flashKeyExists("bigrigDoInstall")>
				<cfset flashDelete("bigrigDoInstall")>
			</cfif>
			<cfset structDelete(params.bigrig, "createRoutesFile") />
			<cfdirectory action="create" directory="#expandPath("config/plugins/bigrig")#" />

			<!--- add the bigrig.applicationFolders array to keep track of installed application locations --->
			<cfset loc.returnStruct.file = '<!--- BigRig Applicaiton Routes --->#chr(13)#<cfset application.wheels.bigrig.useAutoInstaller=true/>#chr(13)#<cfset addApp(name="wheelsplugins", path="plugins", keyword="bigrig", singleAppFolder=true)>' />
			<cffile action="write" file="#expandPath('config/plugins/bigrig/appRoutes.cfm')#" output="#loc.returnStruct.file#" />
		</cfif>
	</cfif>
</cfif>

<cfinclude template="views/docs/#params.docs#.cfm">