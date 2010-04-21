<cffunction name="$createInstance" returntype="any" access="public" output="false">
	<cfargument name="properties" type="any" required="true">
	<cfargument name="persisted" type="boolean" required="true">
	<cfargument name="row" type="numeric" required="false" default="1">
	<cfscript>
		//// bigrig: ////
		// var loc = {};
		// loc.fileName = capitalize(variables.wheels.class.name);
		var loc = $getModelInitInfo(variables.wheels.class.name);
		loc.fileName = capitalize(loc.fileName);
		if(loc.fileName == "") { writeDump(loc);abort; }
		if (!ListFindNoCase(application.wheels.existingModelFiles, variables.wheels.class.name))
			loc.fileName = "Model";
		// loc.returnValue = $createObjectFromRoot(path=application.wheels.modelComponentPath, fileName=loc.fileName, method="$initModelObject", name=variables.wheels.class.name, properties=arguments.properties, persisted=arguments.persisted, row=arguments.row);
		// if this method is called with a struct we're creating a new object and then we call the afterNew callback. If called with a query we call the afterFind callback instead. If the called method does not return false we proceed and run the afterInitialize callback.
		loc.returnValue = $createObjectFromRoot(path=loc.modelComponentPath, fileName=loc.fileName, method="$initModelObject", name=variables.wheels.class.name, properties=arguments.properties, persisted=arguments.persisted, row=arguments.row);
		if ((IsQuery(arguments.properties) && loc.returnValue.$callback("afterFind")) || (IsStruct(arguments.properties) && loc.returnValue.$callback("afterNew")))
			loc.returnValue.$callback("afterInitialization");
		//// :bigrig ////
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>

