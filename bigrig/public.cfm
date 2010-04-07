<cffunction name="addRig">
	<cfargument name="name" type="string" required="true" hint="" />
	<cfargument name="keyWord" type="string" default="#arguments.name#" hint="" />
	<cfargument name="singleAppFolder" type="string" default="" hint="" />
	
	<cfset var loc = {keyword = "#arguments.keyWord#/", appPattern = singularize(arguments.name) }/>
	
	<cfif loc.keyword EQ "/">
		<cfset loc.keyword = "" />
	</cfif>

	<cfif arguments.singleAppFolder EQ "">
		<cfset addRoute(name=arguments.name, pattern="#loc.keyWord#[#loc.appPattern#]/[controller]/[action]/[key]")>
		<cfset addRoute(name=arguments.name, pattern="#loc.keyWord#[#loc.appPattern#]/[controller]/[action]")>
		<cfset addRoute(name=arguments.name, pattern="#loc.keyWord#[#loc.appPattern#]/[controller]", action="index")>
	<cfelse>
		<cfset loc.routeArguments = {
			name=arguments.name,
			pattern="#loc.keyWord#[controller]/[action]/[key]",
			"#loc.appPattern#" = "#arguments.singleAppFolder#"
		} />

		<cfset addRoute(argumentCollection = loc.routeArguments)>

		<cfset loc.routeArguments.pattern="#loc.keyWord#[controller]/[action]">
		<cfset addRoute(argumentCollection = loc.routeArguments)>

		<cfset loc.routeArguments.pattern="#loc.keyWord#[controller]">
		<cfset loc.routeArguments.action="index">
		<cfset addRoute(argumentCollection = loc.routeArguments)>
	</cfif>
</cffunction>