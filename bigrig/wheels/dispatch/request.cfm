<cffunction name="$request" returntype="string" access="public" output="false">
	<cfscript>
		var loc = {};
		if (application.wheels.showDebugInformation)
			$debugPoint("setup");

		// set route from incoming url, find a matching one and create the params struct
		loc.route = $getRouteFromRequest();
		loc.foundRoute = $findMatchingRoute(route=loc.route);

		loc.params = $createParams(route=loc.route, foundRoute=loc.foundRoute);
		//// bigrig: ////
		//// :bigrig ////
		// set params in the request scope as well so we can display it in the debug info outside of the controller context
		request.wheels.params = loc.params;

		// create an empty flash unless it already exists
		if (!StructKeyExists(session, "flash"))
			session.flash = {};
		
		///// bigrig: ////
		if(StructKeyExists(loc.foundRoute, "name")) {
			// add to params - for cases where there is no matching variable in the foundRoute.pattern
			if(!StructKeyExists(loc.params, singularize(loc.foundroute.name)) && StructKeyExists(loc.foundRoute, singularize(loc.foundroute.name))) {
				loc.params[singularize(loc.foundroute.name)] = loc.foundRoute[singularize(loc.foundroute.name)];
			}
			// see if the controller needs to be modified - only modify if the route explicitly has parameter
			// overriding controller name to support packages (apps) through routes
			if (structKeyExists(loc.params, singularize(loc.foundRoute.name)) && (ListFind(loc.foundRoute.variables, singularize(loc.foundroute.name)) || StructKeyExists(loc.foundRoute, singularize(loc.foundroute.name)))) {
				loc.params.controller = "#loc.foundroute.name#.#loc.params[singularize(loc.foundroute.name)]#.#loc.params.controller#";
			}
		}
		//// :bigrig ////

		// create the requested controller
		loc.controller = $controller(loc.params.controller).$createControllerObject(loc.params);
		if (application.wheels.showDebugInformation)
			$debugPoint("setup,beforeFilters");

		// run verifications and before filters if they exist on the controller
		$runVerifications(controller=loc.controller, actionName=loc.params.action, params=loc.params);
		$runFilters(controller=loc.controller, type="before", actionName=loc.params.action);

		if (application.wheels.showDebugInformation)
			$debugPoint("beforeFilters,action");

		// call action on controller if it exists
		loc.actionIsCachable = false;
		if (application.wheels.cacheActions && StructIsEmpty(session.flash) && StructIsEmpty(form))
		{
			loc.cachableActions = loc.controller.$getCachableActions();
			loc.iEnd = ArrayLen(loc.cachableActions);
			for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
			{
				if (loc.cachableActions[loc.i].action == loc.params.action)
				{
					loc.actionIsCachable = true;
					loc.timeToCache = loc.cachableActions[loc.i].time;
				}
			}
		}
		if (loc.actionIsCachable)
		{
			loc.category = "action";
			loc.key = "#request.cgi.script_name##request.cgi.path_info##request.cgi.query_string#";
			loc.lockName = loc.category & loc.key;
			loc.conditionArgs = {};
			loc.conditionArgs.key = loc.key;
			loc.conditionArgs.category = loc.category;
			loc.executeArgs = {};
			loc.executeArgs.controller = loc.controller;
			loc.executeArgs.controllerName = loc.params.controller;
			loc.executeArgs.actionName = loc.params.action;
			loc.executeArgs.key = loc.key;
			loc.executeArgs.time = loc.timeToCache;
			loc.executeArgs.category = loc.category;
			request.wheels.response = $doubleCheckedLock(name=loc.lockName, condition="$getFromCache", execute="$callActionAndAddToCache", conditionArgs=loc.conditionArgs, executeArgs=loc.executeArgs);
		}
		else
		{
			$callAction(controller=loc.controller, controllerName=loc.params.controller, actionName=loc.params.action);
		}
		if (application.wheels.showDebugInformation)
			$debugPoint("action,afterFilters");
		$runFilters(controller=loc.controller, type="after", actionName=loc.params.action);
		if (application.wheels.showDebugInformation)
			$debugPoint("afterFilters");

		// clear the flash (note that this is not done for redirectTo since the processing does not get here)
		StructClear(session.flash);
	</cfscript>
	<cfreturn Trim(request.wheels.response)>
</cffunction>