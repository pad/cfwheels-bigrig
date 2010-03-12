<cffunction name="contentForLayout">
	<cfset var content = core.contentForLayout() />
	
	<cfset var token = "" />
	<cfset var i = "" />
	<cfloop from=1 to=6 index="i">
		<cfset token &= "=" />
		<cfset content = rereplace(content, "(?m)^#token#([^=].*?)\n$", "<h#i#>\1</h#i#>", "all") />
	</cfloop>

	<cfset content = rereplace(content, "(?m)^[\r\n]+", "<p>\1</p>", "all") />
	
	<cfreturn content />
</cffunction>	