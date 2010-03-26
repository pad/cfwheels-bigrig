<cfset bigrigHelperFunction="addRig">
<p>BigRig extends the Wheels convention for code organization, allowing you to implement your models, views and controllers in a <a href="?controller=wheels&action=wheels&view=plugins&name=bigrig&docs=sample-config">customized, nested structure</a>.</p>

<p>BigRig folders each require supporting named routes and a mapping to function properly.</p>

<!--- <h3>Option one: Add base routes and a mapping</h3>

<p>First set up a mapping in the app.cfm file:</p>

<pre><code>&lt;cfset this.mappings["/apps"]=expandPath("apps") />
</code></pre>

<p><small>* Some versions of Railo might have issues with controllers that are initialized through application level mappings. You may need to use the web administrator to define any mappings your application would need instead of doing it in code.</small></p>

<p>Next, add base routes in for the apps folder in your routes.cfm file:</p>

<pre><code>&lt;cfset addRoute(name="apps", pattern="apps/[app]/[controller]/[action]/[key]") />
&lt;cfset addRoute(name="apps", pattern="apps/[app]/[controller]/[action]") />
&lt;cfset addRoute(name="apps", pattern="apps/[app]/[controller]", action="index") />
</code></pre>

<p>BigRig uses the name of the route paired with a sungularized version of the route name as a URL key as a trigger to do its magic. For example, if you have a route named apps and a parameter named app BigRig will parse the request, looking for all models views and controllers in the folder name that matches the route parameter <code>app</code>.</p> --->

<h3>Quick Start</h3>

<p>Simply add a call to the BigRig function <code><cfoutput>#bigrigHelperFunction#</cfoutput>(<em>name, [path, keyword, singleAppFolder]</em>)</code> in your routes.cfm file and it will auto wire some routes for your new folder locations.</p>

<pre><code>&lt;cfset <cfoutput>#bigrigHelperFunction#</cfoutput>(name="apps") /></code></pre>

<p>You can now use urls like this(assuming you had a blog folder with it's own mvc folders)</p>

<p><code>http://example.com/apps/blog/list</code> - would get to the <code>apps/blog/views/list/index.cfm</code> view.</p>

<p><a href="?controller=wheels&action=wheels&view=plugins&name=bigrig&docs=helper-details">What BigRig does</a> when you call <code><cfoutput>#bigRigHelperFunction#</cfoutput>()</code>.</p>

<!--- <h3>Option three: Auto Installer</h3>
<cfif flashCount() EQ 0>
	<cftry>
		<cfset message='<p>It appears everything is set up to use the auto installer: #linkTo(route="wheelsplugins", wheelsplugin="bigrig", controller="app", action="config", text="BigRig Auto Installer")#.</p>' />
		<cfoutput>#message#</cfoutput>
	<cfcatch>
		<cfoutput>
		<div class="bigrig flash">
			<h3>#cfcatch.message#</h3>
			<p>#cfcatch.ExtendedInfo#</p>
			<cfif cfcatch.message EQ "Could not find the `wheelsplugins` route.">
				<cfif NOT structKeyExists(params, "reload")>
					<cfset redirectTo(params="controller=wheels&action=wheels&view=plugins&name=bigrig&docs=#params.docs#&reload=true") />
				</cfif>
				<p>You still need to add a call to enableBigRig() in your config/app.cfm file:</p>
				
				<pre><code>&lt;cfset enableBigRig() /></code></pre>
				
				<p>(or #linkTo(params="controller=wheels&action=wheels&view=plugins&name=bigrig&docs=#params.docs#&reload=true",text="reload")# if you already have)</p>
			</cfif>
		</div>
		</cfoutput>
	</cfcatch>
	</cftry>
<cfelse>
	<p>If you are ok turning some control over to code, you can use this auto installer built using wheels and BigRig.</p>
	<div class="bigrig flash">
		<h3>BigRig Routes file does not exist</h3>
		<p>
			<cfoutput>#flash("bigrigInstall")#</cfoutput>
		</p>
	</div>
</cfif> --->