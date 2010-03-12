<cffunction name="$createControllerClass" returntype="any" access="public" output="false">
	<cfargument name="name" type="string" required="true">
	<cfscript>
		//// bigrig: ////
		// var loc = {};
		// loc.fileName = capitalize(arguments.name);
		var loc = $getComponentInitInfo(arguments.name);
		loc.fileName = capitalize(loc.fileName);
		//// :bigrig ////
		
		// check if the controller file exists and store the results for performance reasons
		if (!ListFindNoCase(application.wheels.existingControllerFiles, arguments.name) && !ListFindNoCase(application.wheels.nonExistingControllerFiles, arguments.name))
		{
			//// bigrig: ////
			// if (FileExists(ExpandPath("#application.wheels.controllerPath#/#loc.fileName#.cfc")))
			//	application.wheels.existingControllerFiles = ListAppend(application.wheels.existingControllerFiles, arguments.name);
			if (FileExists(ExpandPath("#loc.controllerPath#/#loc.fileName#.cfc"))){
				application.wheels.existingControllerFiles = ListAppend(application.wheels.existingControllerFiles, arguments.name);
			}
			//// :bigrig ////
			else {
				application.wheels.nonExistingControllerFiles = ListAppend(application.wheels.nonExistingControllerFiles, arguments.name);
			}
		}

		// check if the controller's view helper file exists and store the results for performance reasons
		if (!ListFindNoCase(application.wheels.existingHelperFiles, arguments.name) && !ListFindNoCase(application.wheels.nonExistingHelperFiles, arguments.name))
		{
			//// bigrig: ////
			// if (FileExists(ExpandPath("#application.wheels.viewPath#/#LCase(arguments.name)#/helpers.cfm"))) 
			if (FileExists(ExpandPath("#loc.viewPath#/#LCase(loc.fileName)#/helpers.cfm")))
			//// :bigrig ////
				application.wheels.existingHelperFiles = ListAppend(application.wheels.existingHelperFiles, arguments.name);
			else
				application.wheels.nonExistingHelperFiles = ListAppend(application.wheels.nonExistingHelperFiles, arguments.name);
		}
		if (!ListFindNoCase(application.wheels.existingControllerFiles, arguments.name))
			loc.fileName = "Controller";
		//// bigrig: ////
		//application.wheels.controllers[arguments.name] = $createObjectFromRoot(path=application.wheels.controllerComponentPath, fileName=loc.fileName, method="$initControllerClass", name=arguments.name);
		application.wheels.controllers[arguments.name] = $createObjectFromRoot(path=listChangeDelims(loc.controllerComponentPath, ".", "/"), fileName=loc.fileName, method="$initControllerClass", name=arguments.name);
		//// :bigrig ////
		loc.returnValue = application.wheels.controllers[arguments.name];
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>

<cffunction name="$createModelClass" returntype="any" access="public" output="false">
	<cfargument name="name" type="string" required="true">
	<cfscript>
		//// bigrig: ////
		// var loc = {};
		// loc.fileName = capitalize(arguments.name);
		var loc = $getModelInitInfo(arguments.name);
		loc.fileName = capitalize(loc.fileName);
		//if (FileExists(ExpandPath("#application.wheels.modelPath#/#loc.fileName#.cfc")))
			//application.wheels.existingModelFiles = ListAppend(application.wheels.existingModelFiles, arguments.name);
		if (FileExists(ExpandPath("#loc.modelPath#/#loc.fileName#.cfc")))
			application.wheels.existingModelFiles = ListAppend(application.wheels.existingModelFiles, loc.name);
		else
			loc.fileName = "Model";
		// application.wheels.models[arguments.name] = $createObjectFromRoot(path=application.wheels.modelComponentPath, fileName=loc.fileName, method="$initModelClass", name=arguments.name);
		// loc.returnValue = application.wheels.models[arguments.name];
		application.wheels.models[loc.name] = $createObjectFromRoot(path=loc.modelComponentPath, fileName=loc.fileName, method="$initModelClass", name=loc.name);
		loc.returnValue = application.wheels.models[loc.name];
		//// :bigrig ////
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>

<cffunction name="$createObjectFromRoot" returntype="any" access="public" output="false">
	<cfargument name="path" type="string" required="true">
	<cfargument name="fileName" type="string" required="true">
	<cfargument name="method" type="string" required="true">
	<cfscript>
		//if(listFind("Wheels,Dispatch", arguments.fileName) == 0)
		var loc = {};
		arguments.returnVariable = "loc.returnValue";
		arguments.component = arguments.path & "." & arguments.fileName;
		StructDelete(arguments, "path");
		StructDelete(arguments, "fileName");
	</cfscript>
	<!--- bigrig: <cfinclude template="../../root.cfm"> --->
	<cfinclude template="../../../../root.cfm">
	<!--- :bigrig --->
	<cfreturn loc.returnValue>
</cffunction>

