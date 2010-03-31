<cfinclude template="header.cfm" />

<cfoutput>
<div class="docs">
	<a target="_blank" href="http://wiki.github.com/pad/cfwheels-bigrig/">Docs</a>
</div>
</cfoutput>

<h1>BigRig</h1>

<p>BigRig extends the Wheels convention for code organization, allowing you to implement your models, views and controllers in a <a target="_blank" href="http://wiki.github.com/pad/cfwheels-bigrig/site-structure">customized, nested structure</a>.</p>

<p>BigRig folders each require supporting named routes and a mapping to function properly. There is a helper function, <cfoutput><code><a target="_blank" href="http://wiki.github.com/pad/cfwheels-bigrig/addrig">#bigRigHelperFunction#()</a></code></cfoutput>, that can set this up for you.</p>

<hr/>


<h3>Quick Start</h3>

<p>For this quick start guide, we're going to create a BigRig folder called apps, place a blog application in it and get it up and running. It is assumed you have installed wheels in the webroot of your server.</p>

<ul>
	<li>Add the /apps folder to your webroot</li>
	<li>Add the /apps/blog folder</li>
	<li>Copy the /models, /views, and /controllers folder from a fresh wheels install</li>
	<li>Fix your Wheels.cfc files
		<h4>/apps/blog/controllers/Wheels.cfc</h4>
<pre><code>&lt;cfcomponent output="false" displayName="Controller"&gt;
	&lt;cfinclude template="../../../wheels/controller.cfm"&gt;
&lt;/cfcomponent&gt;</code></pre>
		<h4>/apps/blog/models/Wheels.cfc</h4>
<pre><code>&lt;cfcomponent output="false" displayName="Model"&gt;
	&lt;cfinclude template="../../../wheels/model.cfm"&gt;
&lt;/cfcomponent&gt;</code></pre>
	</li>
	<li>Add a call to <cfoutput><code><a target="_blank" href="http://wiki.github.com/pad/cfwheels-bigrig/addrig">#bigRigHelperFunction#(<em>name, [path, keyword, singleAppFolder]</em>)</a></code></cfoutput>
		<h4><code>/config/routes.cfm</code></h4>
		<pre><code>&lt;cfset <cfoutput>#bigrigHelperFunction#</cfoutput>(name="apps") /></code></pre>
	
	</li>
</ul>

<p>You can now use urls like this (assuming you had URL rewritting turned on)</p>

<p><code>http://example.com/apps/blog/feed</code> - would get to the <code>apps/blog/views/feed/index.cfm</code> view.</p>
