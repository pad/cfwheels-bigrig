<h1>BigRig</h1>
<p>Allows for multiple wheels enabled folders. The convention decided on is to specify an application folder that can hold multiple wheels apps, each with their own wheels enabled model/view/controller folders.</p>

<p>Simply add a call to <code>addApp(<em>name, path[, keyword]</em>)</code> and it will auto wire some routes for your new folder locations.</p>

<p>Here's a quick overview of what it does were you to add an application folder called apps with the location of apps and the keyword of '':</p>

<pre><code>&lt;cfset addRoute(name=arguments.name, pattern="/[app]/[controller]/[action]/[key]")>
&lt;cfset addRoute(name=arguments.name, pattern="/[app]/[controller]/[action]")>
&lt;cfset addRoute(name="apps", pattern="/[app]/[controller]", action="index")>
	
&lt;cfset this.mappings["/#arguments.name#"] = expandPath(arguments.path) />
</code></pre>