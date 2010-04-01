<cffunction name="$createControllerObject" returntype="any" access="public" output="false">
	<cfargument name="params" type="struct" required="true">
	<cfscript>
		//// bigrig: ////
		// var loc = {};
		// loc.fileName = capitalize(variables.wheels.name);
		var loc = $getComponentInitInfo(variables.wheels.name);
		loc.fileName = capitalize(loc.fileName);
		//// :bigrig ////

		if (!ListFindNoCase(application.wheels.existingControllerFiles, variables.wheels.name))
			loc.fileName = "Controller";
		//// bigrig: ////
		// loc.returnValue = $createObjectFromRoot(path=application.wheels.controllerComponentPath, fileName=loc.fileName, method="$initControllerObject", name=variables.wheels.name, params=arguments.params);
		loc.returnValue = $createObjectFromRoot(path=loc.controllerComponentPath, fileName=loc.fileName, method="$initControllerObject", name=variables.wheels.name, params=arguments.params);
		//// :bigrig ////
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>

<cffunction name="$initControllerObject" returntype="any" access="public" output="false">
	<cfargument name="name" type="string" required="true">
	<cfargument name="params" type="struct" required="true">
	<cfscript>
		//// bigrig: ////
		// var loc = {};
		var loc = $getComponentInitInfo(arguments.name);
		// include controller specific helper files if they exist
		if (ListFindNoCase(application.wheels.existingHelperFiles, arguments.params.controller))
		{
			//$include(template="#application.wheels.viewPath#/#arguments.params.controller#/helpers.cfm");
			$include(template="#loc.viewPath#/#arguments.params.controller#/helpers.cfm");
		}
		//// :bigrig ////
		
		loc.executeArgs = {};
		loc.executeArgs.name = arguments.name;
		$simpleLock(name="controllerLock", type="readonly", execute="$setControllerClassData", executeArgs=loc.executeArgs);
		variables.params = arguments.params;
	</cfscript>
	<cfreturn this>
</cffunction>

