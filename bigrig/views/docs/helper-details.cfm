<div class="addApp docs">
<p>This is a general overview of what the <code>addApp()</code> funtion does, and how to add your own, custom BigRig routes.</p>
<h2>Examples</h2>
	<p>All examples would take you to the <a href="#details" class="tree">/apps/blog/views/user/edit.cfm</a> view. (So long as no other patterns were matched first.)</p>

<div class="details">
<pre>
  &lt;server>
    &lt;apps>
      &lt;blog>
        &lt;controllers>
          <strong>Users.cfc</strong>
            action=edit
            key=5
        &lt;views>
          &lt;users>
            <strong>edit.cfm</strong>
    &lt;controllers>
    &lt;models>
    &lt;views>
    &lt;wheels>
    &lt;etc>
</pre>
</div>

<h2>Name, path, empty string keyword</h2>
<h3><a href="#details"><code>&lt;cfset addApp(name="apps", path="apps", keyword="") /></code></a></h3>
<div class="details">

<p>This is a shortcut for the following code: (you could do it manualy if you wanted)</p>

<pre><code>&lt;cfset addRoute(name="apps", pattern="/[app]/[controller]/[action]/[key]")>
&lt;cfset addRoute(name="apps", pattern="/[app]/[controller]/[action]")>
&lt;cfset addRoute(name="apps", pattern="/[app]/[controller]", action="index")>
	
&lt;cfset this.mappings["/apps"] = expandPath("path") />
</code></pre>

<p>This would enable a folder with the name of <code>apps</code> inside of your root wheels install folder to have as many wheels enabled folders as required, so long as your apps didn't have any naming collisions with other BigRig application folders(in this case, apps would be the BigRig application folder).</p>

<p>For example, this URL:</p>

<pre><code>/blog/users/add/5</code></pre>

<p>Would load the /apps/blog/controllers/User.cfc controller, hit the add action with the key of 5 and render the /apps/blog/views/user/edit.cfm view.</p>
</div>

<h2>Name, path, custom keyword</h2>
<h3><a href="#details"><code>&lt;cfset addApp(name="apps", path="apps", keyword="my-apps") /></code></a></h3>

<div class="details">
<pre><code>&lt;cfset addRoute(name="apps", pattern="my-apps/[app]/[controller]/[action]/[key]")>
&lt;cfset addRoute(name="apps", pattern="my-apps/[app]/[controller]/[action]")>
&lt;cfset addRoute(name="apps", pattern="my-apps/[app]/[controller]", action="index")>
	
&lt;cfset this.mappings["/#arguments.name#"] = expandPath(arguments.path) />
</code></pre>
</div>
</div>