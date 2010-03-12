<cffunction name="addApp">
	<cfargument name="name" type="string" required="true" hint="" />
	<cfargument name="path" type="string" required="true" hint="Location of the package to make a mapping for." />
	<cfargument name="keyWord" type="string" default="#arguments.name#" hint="" />
	<cfargument name="multipleAppFolders" type="boolean" default="true" hint="" />
	
	<cfset var loc = {keyword = "#arguments.keyWord#/",appPattern = singularize(arguments.name) }/>
	
	<cfif loc.keyword EQ "/">
		<cfset loc.keyword = "" />
	</cfif>
	
	<cfif arguments.multipleAppFolders>
		<cfset addRoute(name=arguments.name, pattern="#loc.keyWord#[#loc.appPattern#]/[controller]/[action]/[key]")>
		<cfset addRoute(name=arguments.name, pattern="#loc.keyWord#[#loc.appPattern#]/[controller]/[action]")>
		<cfset addRoute(name=arguments.name, pattern="#loc.keyWord#[#loc.appPattern#]/[controller]", action="index")>
	<cfelse>
		<!--- todo: doesn't work... might be a dead end... --->
		<cfset loc.routeArguments = {
			name=arguments.name,
			pattern="#arguments.keyWord#[controller]/[action]/[key]",
			"#loc.appPattern#" = "#loc.appPattern#"
		} />
		
		<cfset addRoute(argumentCollection = loc.routeArguments)>

		<cfset loc.routeArguments.pattern="#loc.keyWord#[controller]/[action]">
		<cfset addRoute(argumentCollection = loc.routeArguments)>
		
		<cfset loc.routeArguments.pattern="#loc.keyWord#[controller]">
		<cfset loc.routeArguments.action="index">
		<cfset addRoute(argumentCollection = loc.routeArguments)>
	</cfif>
	
	<cfset this.mappings["/#arguments.name#"] = expandPath(arguments.path) />
</cffunction>

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
		
		if (ListLen(loc.fileName, "/") >= 2 AND ListLen(listGetAt(loc.controllerName, 1, "/"), ".") == 3) {
			loc.controllerName = listGetAt(loc.controllerName, 1, "/");
			loc.folderName = $getComponentName(loc.folderName);
			// extracts the file part of the path and replace ending ".cfm";
			loc.fileName = loc.fileName = Spanexcluding(Reverse(ListFirst(Reverse(loc.fileName), "/")), ".") & ".cfm";;
		}
		
		if(arguments.type == "partial") {
			loc.controllerName = variables.wheels.name;
			loc.fileName = loc.fileName = Spanexcluding(Reverse(ListFirst(Reverse(loc.fileName), "/")), ".") & ".cfm";
			writeDump(loc);
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
			loc.controllerComponentPath = "/#loc.package#/#loc.app#/#loc.controllerComponentPath#";
			loc.viewPath = "/#loc.package#/#loc.app#/#loc.viewPath#";
			
			if(listFind("layout,partial", arguments.type)) {
				loc.include = "#loc.package#/#loc.app#/#loc.include#";
			} else {
				loc.include = "#loc.package#/#loc.app#/#loc.include#/";
			}
		}
		
		if(listFind("partial",arguments.type)) {
			writeDump(label="initController....",var=arguments);writeDump(loc);
		}

		return loc;
	</cfscript>
</cffunction>

<cffunction name="$getModelInitInfo">
	<cfargument name="name" type="string" required="true">
	<cfscript>
		var loc = {};

		loc.fileName = arguments.name;
		if (ListLen(loc.fileName, ".") == 3) {
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
		
		
		if (ListLen(loc.controllerName, ".") == 3) {
			loc.package = $getPackageName(loc.controllerName);
			loc.app = $getAppName(loc.controllerName);
			
			loc.name = "#loc.package#.#loc.app#.#loc.fileName#";
			loc.modelPath = "/#loc.package#/#loc.app#/#loc.modelPath#";
			loc.modelComponentPath = "/#loc.package#/#loc.app#/#loc.modelComponentPath#";
		}
		return loc;
	</cfscript>
</cffunction>
