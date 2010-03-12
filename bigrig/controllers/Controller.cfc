<cfcomponent extends="core.controllers.Wheels">
	<cffunction name="init">
		<cfset filters("$verifyInstall,$restrictAccess,$viewInit") />
	</cffunction>
	
	<cffunction name="$verifyInstall">
		<cfif NOT StructKeyExists(application.wheels, "bigrig")>
			<cfset application.wheels.bigrig = {} />
		</cfif>
		
		<cfif NOT StructKeyExists(application.wheels.bigrig, "applicationFolders")>
			<cfset flashInsert(bigrig='<p>You need to include the BigRig appRoutes.cfm in your config/routes.cfm file.</p><pre><code>&lt;cfinclude template="plugins/bigrig/appRoutes.cfm" /></code></pre><p><em>Or <a href="?reload=true">reload</a> wheels if you already added it.</em></p>') />
		</cfif>
	</cffunction>
	
	<cffunction name="$restrictAccess">
        <cfif NOT listFind("design,maintenance", application.wheels.environment)>
			<cfthrow message="Access Denied">
		</cfif>
    </cffunction>
	
	<cffunction name="$viewInit">
		<cfset pageTitle="BigRig">
		<cfset enableHelpBox="">
	</cffunction>
	
	<cffunction name="$getAppDefinitions">
		<cfset var loc = {returnStruct={appRoutes=[]},file=""} />
		
		<!--- check if the plugin settings exist in the config/plugins/bigrig folder if not, make the appRoute.cfm file with initial content --->
		<cfif NOT fileExists(expandPath('config/plugins/bigrig/appRoutes.cfm'))>
			<!--- check if the folder exists, if not make it --->
			<cfif NOT directoryExists(expandPath("config/plugins/bigrig/"))>
				<cfdirectory action="create" directory="#expandPath("config/plugins/bigrig")#" />
			</cfif>
			
			<!--- add the bigrig.applicationFolders array to keep track of installed application locations --->
			<cfset loc.returnStruct.file = "<!--- BigRig Applicaiton Routes --->#chr(13)#<cfset application.wheels.bigrig.applicationFolders=[]/>" />
			<cffile action="write" file="#expandPath('config/plugins/bigrig/appRoutes.cfm')#" output="#loc.returnStruct.file#" />
		</cfif>
		
		<!--- read the current bigrig appRoutes settings file for parsing --->
		<cffile variable="loc.returnStruct.file" action="Read" file="#expandPath('config/plugins/bigrig/appRoutes.cfm')#" />
		
		<!--- parse the settings --->
		
		<cfset loc.index = 1 />
		<cfset loc.addAppPattern = "<cfset\s+addApp\(([^\(]*)\)\s*/?>" />
		<!--- find existing appRoute calls --->
		<cfloop condition="refindNoCase(loc.addAppPattern, loc.returnStruct.file, loc.index, false)">
			<cfset loc.find = refind(loc.addAppPattern, loc.returnStruct.file, loc.index, true) />
			<cfset loc.arguments = $parseArgumentString(mid(loc.returnStruct.file, loc.find.pos[2], loc.find.len[2]), "name,path,[keyword]") />
			<cfset arrayAppend(loc.returnStruct.appRoutes, loc.arguments) />
			
			<!--- update index for next iteration --->
			<cfset loc.index = loc.find.pos[1] + loc.find.len[1] />
		</cfloop>
		
		<cfreturn loc.returnStruct />
	</cffunction>
	
	<cffunction name="$parseArgumentString">
		<cfargument name="argumentList" required="true">
		<cfargument name="argumentNames" default="">
		<cfset var loc = {arguments={},argumentPattern="(\s*[^=]*)\s*=\s*(.+)\s*$",i=0} />
		<cfloop list="#arguments.argumentList#" index="loc.argument">
			<cfset loc.i++ />
			
			<cfif reFind(loc.argumentPattern, loc.argument, 1, false)>
				<cfset loc.find = reFind(loc.argumentPattern, loc.argument, 1, true) />
				<cfset loc.key = trim(mid(loc.argument,loc.find.pos[2],loc.find.len[2])) />
				<cfset loc.value = mid(loc.argument,loc.find.pos[3],loc.find.len[3])>
			<cfelse>
				<!--- see if it is an optional parameter --->
				<cfif loc.i LTE listLen(arguments.argumentList) OR reFind("\[[^\]]*\]", listGetAt(arguments.argumentNames, loc.i))>
					<cfset loc.key = rereplace(listGetAt(arguments.argumentNames, loc.i), "^\s*\[([^\]]+)\]\s*$", "\1") />
					<cfset loc.value = loc.argument />
				<cfelse>
					<cfthrow message="Argument list does not match count for required argument names(#arguments.argumentNames#)" />
				</cfif>
			</cfif>
			
			<!--- strip quotes --->
			<cfset loc.arguments[loc.key] = rereplace(loc.value, "^\s*[\#'"'#']([^\#'"'#^']+)[\#'"'#']\s*$", "\1") />
		</cfloop>

		<cfreturn loc.arguments />
	</cffunction>
</cfcomponent>