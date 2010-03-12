<cfcomponent extends="Controller">
	<cffunction name="config">
		<cfparam name="params.key" default="" />
		
		<cfset pageTitle&=" Application Folders">
		<cfset enableHelpBox="config">
		
		<cfset appRouteSettings = $getAppDefinitions() />
	</cffunction>
</cfcomponent>