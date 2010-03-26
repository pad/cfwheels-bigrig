<cffunction name="$includeAndReturnOutput" returntype="string" access="public" output="false">
	<cfargument name="$template" type="string" required="true">
	<cfset var loc = {}>
	<cfif StructKeyExists(arguments, "$type") AND arguments.$type IS "partial">
		<!--- make it so the developer can reference passed in arguments in the loc scope if they prefer --->
		<cfset loc = arguments>
	</cfif>
	<!--- we prefix returnValue with "wheels" here to make sure the variable does not get overwritten in the included template --->
	
	<!--- <cfsavecontent variable="loc.wheelsReturnValue"><cfoutput><cfinclude template="../../#LCase(arguments.$template)#"></cfoutput></cfsavecontent> --->
	<cfif fileExists(expandPath("#LCase(arguments.$template)#"))>
		<cfsavecontent variable="loc.wheelsReturnValue"><cfoutput><cfinclude template="../../../../#LCase(arguments.$template)#"></cfoutput></cfsavecontent>
	<!--- bigrig: making wheels require mappings now... doh! --->
	<cfelseif fileExists(expandPath("/#LCase(arguments.$template)#"))>
		<cfsavecontent variable="loc.wheelsReturnValue"><cfoutput><cfinclude template="/#LCase(arguments.$template)#"></cfoutput></cfsavecontent>
	</cfif>
	<!--- :bigrig --->
	<cfreturn loc.wheelsReturnValue>
</cffunction>