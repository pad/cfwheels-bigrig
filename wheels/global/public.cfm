<cffunction name="URLFor" returntype="string" access="public" output="false"
	hint="Creates an internal URL based on supplied arguments."
	examples=
	'
		##URLFor(controller="account", action="logOut")##

		##URLFor(action="comments", anchor="comment10")##
	'
	categories="global-helper" chapters="request-handling,linking-pages" functions="redirectTo,linkTo,startFormTag">
	<cfargument name="route" type="string" required="false" default="" hint="Name of a route that you have configured in 'config/routes.cfm'">
	<cfargument name="controller" type="string" required="false" default="" hint="Name of the controller to include in the URL">
	<cfargument name="action" type="string" required="false" default="" hint="Name of the action to include in the URL">
	<cfargument name="key" type="any" required="false" default="" hint="Key(s) to include in the URL">
	<cfargument name="params" type="string" required="false" default="" hint="Any additional params to be set in the query string">
	<cfargument name="anchor" type="string" required="false" default="" hint="Sets an anchor name to be appended to the path">
	<cfargument name="onlyPath" type="boolean" required="false" default="#application.wheels.functions.URLFor.onlyPath#" hint="If true, returns only the relative URL (no protocol, host name or port)">
	<cfargument name="host" type="string" required="false" default="#application.wheels.functions.URLFor.host#" hint="Set this to override the current host">
	<cfargument name="protocol" type="string" required="false" default="#application.wheels.functions.URLFor.protocol#" hint="Set this to override the current protocol">
	<cfargument name="port" type="numeric" required="false" default="#application.wheels.functions.URLFor.port#" hint="Set this to override the current port number">
	<cfscript>
		var loc = {};
		loc.params = {};
		if (StructKeyExists(variables, "params"))
			StructAppend(loc.params, variables.params, true);
		if (application.wheels.showErrorInformation)
		{
			if (arguments.onlyPath && (Len(arguments.host) || Len(arguments.protocol)))
				$throw(type="Wheels.IncorrectArguments", message="Can't use the `host` or `protocol` arguments when `onlyPath` is `true`.", extendedInfo="Set `onlyPath` to `false` so that `linkTo` will create absolute URLs and thus allowing you to set the `host` and `protocol` on the link.");
		}

		// get primary key values if an object was passed in
		if (IsObject(arguments.key))
		{
			arguments.key = arguments.key.key();
		}

		// build the link
		loc.returnValue = application.wheels.webPath & ListLast(request.cgi.script_name, "/");
		
		//// bigrig: ////
		// no route was requested, there is a matching route defined for this request and this request is for a BigRig controller
		if (!Len(arguments.route) && StructKeyExists(loc.params, "route") && $isBigRigRequest(loc.params.controller)) {
			arguments.route = loc.params.route;
			arguments[singularize(arguments.route)] = loc.params[singularize(arguments.route)];
			if(arguments.controller EQ "") {
				arguments.controller = $getComponentName(loc.params.controller);
			}
		}
		//// :bigrig ////
		
		if (Len(arguments.route))
		{
			// link for a named route
			loc.route = $findRoute(argumentCollection=arguments);
			if (application.wheels.URLRewriting == "Off")
			{
				loc.returnValue = loc.returnValue & "?controller=" & REReplace(REReplace(loc.route.controller, "([A-Z])", "-\l\1", "all"), "^-", "", "one");
				loc.returnValue = loc.returnValue & "&action=" & REReplace(REReplace(loc.route.action, "([A-Z])", "-\l\1", "all"), "^-", "", "one");
				loc.iEnd = ListLen(loc.route.variables);
				for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
				{
					loc.property = ListGetAt(loc.route.variables, loc.i);
					loc.returnValue = loc.returnValue & "&" & loc.property & "=" & $URLEncode(arguments[loc.property]);
				}
			}
			else
			{
				loc.iEnd = ListLen(loc.route.pattern, "/");
				for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
				{
					loc.property = ListGetAt(loc.route.pattern, loc.i, "/");
					if (loc.property Contains "[")
					{
						loc.property = Mid(loc.property, 2, Len(loc.property)-2);
						if (application.wheels.showErrorInformation && !StructKeyExists(arguments, loc.property))
							$throw(type="Wheels", message="Incorrect Arguments", extendedInfo="The route chosen by Wheels `#loc.route.name#` requires the argument `#loc.property#`. Pass the argument `#loc.property#` or change your routes to reflect the proper variables needed.");
						loc.param = $URLEncode(arguments[loc.property]);
						if (loc.property == "controller" || loc.property == "action")
							loc.param = REReplace(REReplace(loc.param, "([A-Z])", "-\l\1", "all"), "^-", "", "one");
						else if (application.wheels.obfuscateUrls)
							loc.param = obfuscateParam(loc.param);
						loc.returnValue = loc.returnValue & "/" & loc.param; // get param from arguments
					}
					else
					{
						loc.returnValue = loc.returnValue & "/" & loc.property; // add hard coded param from route
					}
				}
			}
		}
		else
		{
			// link based on controller/action/key
			if (!Len(arguments.controller) && !Len(arguments.action) && StructKeyExists(loc.params, "action"))
				arguments.action = loc.params.action; // when no controller or action was passed in we link to the current page (controller/action only, not query string etc) by default
			if (!Len(arguments.controller) && StructKeyExists(loc.params, "controller"))
				arguments.controller = loc.params.controller; // use the current controller as the default when none was passed in by the developer
			loc.returnValue = loc.returnValue & "?controller=" & REReplace(REReplace(arguments.controller, "([A-Z])", "-\l\1", "all"), "^-", "", "one");
			if (Len(arguments.action))
				loc.returnValue = loc.returnValue & "&action=" & REReplace(REReplace(arguments.action, "([A-Z])", "-\l\1", "all"), "^-", "", "one");
			if (Len(arguments.key))
			{
				loc.param = $URLEncode(arguments.key);
				if (application.wheels.obfuscateUrls)
					loc.param = obfuscateParam(loc.param);
				loc.returnValue = loc.returnValue & "&key=" & loc.param;
			}
		}

		if (application.wheels.URLRewriting != "Off")
		{
			loc.returnValue = Replace(loc.returnValue, "?controller=", "/");
			loc.returnValue = Replace(loc.returnValue, "&action=", "/");
			loc.returnValue = Replace(loc.returnValue, "&key=", "/");
		}
		if (application.wheels.URLRewriting == "On")
		{
			loc.returnValue = Replace(loc.returnValue, "rewrite.cfm", "");
			loc.returnValue = Replace(loc.returnValue, "//", "/");
		}

		if (Len(arguments.params))
			loc.returnValue = loc.returnValue & $constructParams(arguments.params);
		if (Len(arguments.anchor))
			loc.returnValue = loc.returnValue & "##" & arguments.anchor;

		if (!arguments.onlyPath)
		{
			if (arguments.port != 0)
				loc.returnValue = ":" & arguments.port & loc.returnValue; // use the port that was passed in by the developer
			else if (request.cgi.server_port != 80 && request.cgi.server_port != 443)
				loc.returnValue = ":" & request.cgi.server_port & loc.returnValue; // if the port currently in use is not 80 or 443 we set it explicitly in the URL
			if (Len(arguments.host))
				loc.returnValue = arguments.host & loc.returnValue;
			else
				loc.returnValue = request.cgi.server_name & loc.returnValue;
			if (Len(arguments.protocol))
				loc.returnValue = arguments.protocol & "://" & loc.returnValue;
			else
				loc.returnValue = SpanExcluding(request.cgi.server_protocol, "/") & "://" & loc.returnValue;
		}
		loc.returnValue = LCase(loc.returnValue);
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>