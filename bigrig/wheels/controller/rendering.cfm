<cffunction name="$includeFile" returntype="string" access="public" output="false">
	<cfargument name="$name" type="any" required="true">
	<cfargument name="$type" type="string" required="true">
	<cfscript>
		//// bigrig: //
		// var loc = {};
		//
		// loc.include = application.wheels.viewPath;
		// loc.fileName = Spanexcluding(Reverse(ListFirst(Reverse(arguments.$name), "/")), ".") & ".cfm"; // extracts the file part of the path and replace ending ".cfm"
		//
		// if (arguments.$type == "partial")
		//	loc.fileName = Replace("_" & loc.fileName, "__", "_", "one"); // replaces leading "_" when the file is a partial
		//
		// loc.folderName = Reverse(ListRest(Reverse(arguments.$name), "/"));
		var loc = $getComponentInitInfo(name=arguments.$name, type=arguments.$type);;
		if (arguments.$type == "partial") {
			loc.fileName = Replace("_" & loc.fileName, "__", "_", "one"); // replaces leading "_" when the file is a partial
		}
		if (Left(arguments.$name, 1) == "/"){
			loc.include = loc.include & loc.folderName & "/" & loc.fileName; // Include a file in a sub folder to views
		}
		else if (arguments.$name Contains "/"){
			// loc.include = loc.include & "/" & variables.params.controller & "/" & loc.folderName & "/" & loc.fileName; // Include a file in a sub folder of the current controller
			loc.include = loc.include & "/" & loc.controllerName & "/" & loc.folderName & "/" & loc.fileName; // Include a file in a sub folder of the current controller
		}
		else {
			// loc.include = loc.include & "/" & variables.params.controller & "/" & loc.fileName; // Include a file in the current controller's view folder
			loc.include = loc.include & "/" & loc.controllerName & "/" & loc.fileName; // Include a file in the current controller's view folder
		}
		//// :bigrig ////
		
		arguments.$template = loc.include;
		
		if (arguments.$type == "partial")
		{
			loc.pluralizedName = pluralize(arguments.$name);
			if (StructKeyExists(arguments, loc.pluralizedName) && IsQuery(arguments[loc.pluralizedName]))
			{
				loc.query = arguments[loc.pluralizedName];
				loc.returnValue = "";
				loc.iEnd = loc.query.recordCount;
				if (Len(arguments.$group))
				{
					// we want to group based on a column so loop through the rows until we find, this will break if the query is not ordered by the grouped column
					loc.tempSpacer = "}|{";
					loc.groupValue = "";
					loc.groupQueryCount = 1;
					arguments.group = QueryNew(loc.query.columnList);
					if (application.wheels.showErrorInformation && !ListFindNoCase(loc.query.columnList, arguments.$group))
						$throw(type="Wheels.GroupColumnNotFound", message="Wheels couldn't find a query column with the name of `#arguments.$group#`.", extendedInfo="Make sure your finder method has the column `#arguments.$group#` specified in the `select` argument. If the column does not exist, create it.");
					for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
					{
						if (loc.i == 1)
						{
							loc.groupValue = loc.query[arguments.$group][loc.i];
						}
						else if (loc.groupValue != loc.query[arguments.$group][loc.i])
						{
							// we have a different group for this row so output what we have
							writeDump(label="ouch", var=arguments);abort;
							loc.returnValue = loc.returnValue & $includeAndReturnOutput(argumentCollection=arguments);
							if (StructKeyExists(arguments, "$spacer"))
								loc.returnValue = loc.returnValue & loc.tempSpacer;
							loc.groupValue = loc.query[arguments.$group][loc.i];
							arguments.group = QueryNew(loc.query.columnList);
							loc.groupQueryCount = 1;
						}
						loc.dump = QueryAddRow(arguments.group);
						loc.jEnd = ListLen(loc.query.columnList);
						for (loc.j=1; loc.j <= loc.jEnd; loc.j++)
						{
							loc.property = ListGetAt(loc.query.columnList, loc.j);
							arguments[loc.property] = loc.query[loc.property][loc.i];
							loc.dump = QuerySetCell(arguments.group, loc.property, loc.query[loc.property][loc.i], loc.groupQueryCount);
						}
						arguments.current = (loc.i+1) - arguments.group.recordCount;
						loc.groupQueryCount++;
					}
					// if we have anything left at the end we need to render it too
					if (arguments.group.RecordCount > 0)
					{
						writeDump(label="more fun",var=arguments);abort;
						loc.returnValue = loc.returnValue & $includeAndReturnOutput(argumentCollection=arguments);
						if (StructKeyExists(arguments, "$spacer") && loc.i < loc.iEnd)
							loc.returnValue = loc.returnValue & loc.tempSpacer;
					}
					// now remove the last temp spacer and replace the tempSpacer with $spacer
					if (Right(loc.returnValue, 3) == loc.tempSpacer)
						loc.returnValue = Left(loc.returnValue, Len(loc.returnValue) - 3);
					loc.returnValue = Replace(loc.returnValue, loc.tempSpacer, arguments.$spacer, "all");
				}
				else
				{
					for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
					{
						arguments.current = loc.i;
						loc.jEnd = ListLen(loc.query.columnList);
						for (loc.j=1; loc.j <= loc.jEnd; loc.j++)
						{
							loc.property = ListGetAt(loc.query.columnList, loc.j);
							arguments[loc.property] = loc.query[loc.property][loc.i];
						}
						writeDump(label="this sucks",var=arguments);abort;
						loc.returnValue = loc.returnValue & $includeAndReturnOutput(argumentCollection=arguments);
						if (StructKeyExists(arguments, "$spacer") && loc.i < loc.iEnd)
							loc.returnValue = loc.returnValue & arguments.$spacer;
					}
				}
			}
			else if (StructKeyExists(arguments, arguments.$name) && IsObject(arguments[arguments.$name]))
			{
				loc.object = arguments[arguments.$name];
				StructAppend(arguments, loc.object.properties(), false);
			}
			else if (StructKeyExists(arguments, loc.pluralizedName) && IsArray(arguments[loc.pluralizedName]))
			{
				loc.originalArguments = Duplicate(arguments);
				loc.array = arguments[loc.pluralizedName];
				loc.returnValue = "";
				loc.iEnd = ArrayLen(loc.array);
				for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
				{
					arguments.current = loc.i;
					loc.properties = loc.array[loc.i].properties();
					for (loc.key in loc.originalArguments)
						if (StructKeyExists(loc.properties, loc.key))
							StructDelete(loc.properties, loc.key);
					StructAppend(arguments, loc.properties, true);
					writeDump(var=arguments,label="sparta!!");abort;
					loc.returnValue = loc.returnValue & $includeAndReturnOutput(argumentCollection=arguments);
					if (StructKeyExists(arguments, "$spacer") && loc.i < loc.iEnd)
						loc.returnValue = loc.returnValue & arguments.$spacer;
				}
			}
		}
		if (!StructKeyExists(loc, "returnValue")){
			loc.returnValue = $includeAndReturnOutput(argumentCollection=arguments);
		}
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>

<cffunction name="$renderLayout" returntype="string" access="public" output="false">
	<cfargument name="$content" type="string" required="true">
	<cfargument name="$layout" type="any" required="true">
	<cfscript>
		//// bigrig: ////
		// var loc = {};
		// $renderLayout doesn't expect a trailing slash
		var loc = $getComponentInitInfo(name=variables.params.controller, type="layout");
		//// :bigrig ////
		if ((IsBoolean(arguments.$layout) && arguments.$layout) || (!IsBoolean(arguments.$layout) && Len(arguments.$layout)))
		{
			request.wheels.contentForLayout = arguments.$content; // store the content in a variable in the request scope so it can be accessed by the contentForLayout function that the developer uses in layout files (this is done so we avoid passing data to/from it since it would complicate things for the developer)
			
			//// bigrig: ////
			// loc.include = application.wheels.viewPath;
			//// :bigrig ////
			if (IsBoolean(arguments.$layout))
			{
				
				if (!ListFindNoCase(application.wheels.existingLayoutFiles, variables.params.controller) && !ListFindNoCase(application.wheels.nonExistingLayoutFiles, variables.params.controller))
				{
					//// bigrig: ////
					//if (FileExists(ExpandPath("#application.wheels.viewPath#/#LCase(variables.params.controller)#/layout.cfm")))
					if (FileExists(ExpandPath("#loc.viewPath#/#LCase(loc.fileName)#/layout.cfm")))
					//// :bigrig ////
						application.wheels.existingLayoutFiles = ListAppend(application.wheels.existingLayoutFiles, variables.params.controller);
					else
						application.wheels.nonExistingLayoutFiles = ListAppend(application.wheels.nonExistingLayoutFiles, variables.params.controller);
				}
				if (ListFindNoCase(application.wheels.existingLayoutFiles, variables.params.controller))
				{
					//// bigrig: ////
					// loc.include = loc.include & "/" & variables.params.controller & "/" & "layout.cfm";
					loc.include = loc.include & "/" & loc.fileName & "/" & "layout.cfm";
					//// :bigrig ////
				}
				else
				{
					loc.include = loc.include & "/" & "layout.cfm";
				}

				loc.returnValue = $includeAndReturnOutput($template=loc.include);
			}
			else
			{
				loc.returnValue = $includeFile($name=arguments.$layout, $type="layout");
			}
		}
		else
		{
			loc.returnValue = arguments.$content;
		}
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>