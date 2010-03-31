<cffunction name="$getPackageName">
	<cfargument name="name" type="string" required="true" />
	<cfargument name="position" type="numeric" default="1" />
	<cfargument name="delimeter" type="string" default="." />
	
	<cfreturn listGetAt(arguments.name, arguments.position, arguments.delimeter) />
</cffunction>
<cffunction name="$getAppName">
	<cfargument name="name" type="string" required="true" />
	<cfargument name="position" type="numeric" default="2" />
	<cfargument name="delimeter" type="string" default="." />
	
	<cfreturn listGetAt(arguments.name, arguments.position, arguments.delimeter) />
</cffunction>
<cffunction name="$getComponentName">
	<cfargument name="name" type="string" required="true" />
	<cfargument name="position" type="numeric" default="3" />
	<cfargument name="delimeter" type="string" default="." />
	
	<cfreturn listGetAt(arguments.name, arguments.position, arguments.delimeter) />
</cffunction>

<cffunction name="$getComponentInitInfo">
	<cfargument name="name" type="string" required="true">
	<cfargument name="type" type="string" default="page">
	<cfscript>
		var loc = {};
		loc.controllerPath = application.wheels.controllerPath;
		loc.controllerComponentPath = application.wheels.controllerComponentPath;
		loc.include = application.wheels.viewPath;
		loc.viewPath = application.wheels.viewPath;
		loc.fileName = arguments.name;
		loc.controllerName = arguments.name;
		
		loc.folderName = Reverse(ListRest(Reverse(loc.fileName), "/"));
		
		if (ListLen(loc.fileName, "/") >= 2) {
			loc.controllerName = listGetAt(loc.controllerName, 1, "/");
			
			if(ListLen(loc.controllerName, ".") == 3) {
				loc.folderName = $getComponentName(loc.folderName);
			}
			// extracts the file part of the path and replace ending ".cfm";
			loc.fileName = Spanexcluding(Reverse(ListFirst(Reverse(loc.fileName), "/")), ".") & ".cfm";;
		}
		
		if(arguments.type == "partial") {
			loc.controllerName = variables.wheels.name;
			loc.fileName = Spanexcluding(Reverse(ListFirst(Reverse(loc.fileName), "/")), ".") & ".cfm";
		}
		
		if (ListLen(loc.controllerName, ".") == 3) {
			loc.package = $getPackageName(loc.controllerName);
			loc.app = $getAppName(loc.controllerName);
			
			// fix the controller name for partials, now that we're done with referencing it
			if(arguments.type == "partial") {
				loc.controllerName = $getComponentName(loc.controllerName);
			// fix the filename if it is still a 3 key value(for controllers)
			} else if(ListLen(loc.fileName, ".") == 3) {
				loc.fileName = $getComponentName(loc.fileName);
			}
			
			loc.controllerPath = "/#loc.package#/#loc.app#/#loc.controllerPath#";
			loc.controllerComponentPath = "#loc.package#.#loc.app#.#loc.controllerComponentPath#";
			loc.viewPath = "/#loc.package#/#loc.app#/#loc.viewPath#";
			
			if(listFind("layout,partial", arguments.type)) {
				loc.include = "#loc.package#/#loc.app#/#loc.include#";
			} else {
				loc.include = "#loc.package#/#loc.app#/#loc.include#/";
			}
		}
		
		return loc;
	</cfscript>
</cffunction>

<cffunction name="$getModelInitInfo">
	<cfargument name="name" type="string" required="true">
	<cfscript>
		var loc = {};

		loc.fileName = arguments.name;
		if ($isBigRigRequest(loc.fileName)) {
			loc.controllerName = loc.fileName;
			loc.fileName = $getComponentName(loc.fileName);
		}
		else if (isDefined("variables.wheels.name"))
		{
			loc.controllerName = variables.wheels.name;
		}
		else if (isDefined("variables.wheels.class.name"))
		{
			loc.controllerName = variables.wheels.class.name;
		}
		loc.modelPath = application.wheels.modelPath;
		loc.modelComponentPath = application.wheels.modelComponentPath;
		
		
		if ($isBigRigRequest(loc.controllerName)) {
			loc.package = $getPackageName(loc.controllerName);
			loc.app = $getAppName(loc.controllerName);
			
			loc.name = "#loc.package#.#loc.app#.#loc.fileName#";
			loc.modelPath = "/#loc.package#/#loc.app#/#loc.modelPath#";
			loc.modelComponentPath = "/#loc.package#/#loc.app#/#loc.modelComponentPath#";
		}
		return loc;
	</cfscript>
</cffunction>

<cffunction name="$getViewPath">
	<cfargument name="controller" type="string" required="true" />
	<cfargument name="action" type="string" required="true" />
	
	<cfset var loc = {} />
	
	<cfset loc = $getComponentInitInfo(arguments.controller) />
	<cfset loc.fileName = arguments.action />
	<cfset loc.folderName = listAppend(loc.controllerName, loc.folderName, "/")>
	
	<cfset loc.result = reReplace(listAppend(listAppend(reReplace(loc.viewPath, "^/", ""), loc.folderName, "/"), loc.fileName, "/"), "//", "/", "all") />

	<cfif NOT reFind("\.cfm$", loc.result)>
		<cfset loc.result &= ".cfm" />
	</cfif>

	<cfreturn loc.result />
</cffunction>

<cffunction name="$isBigRigRequest">
	<cfargument name="controller">
	
	<cfset var result = false />
	
	<cfif listLen(arguments.controller, ".") EQ 3>
		<cfset result = true />
	</cfif>
	
	<cfreturn result />
</cffunction>