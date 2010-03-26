<h1><code>addApp()</code></h1>
<h2>Description</h2>
<p>Adds wheels enabled folders to your application.</p>
<h2>Function Syntax</h2>
<p>addApp(<em>name</em>, <em>path</em> [, <em>keyword</em>])</p>
<table>
	<thead>
		<tr>
			<th>Parameter</th>
			<th>Type</th>
			<th>Required</th>
			<th>Default</th>
			<th>Description</th>
		</tr>
	</thead>
	<tbody>
		
			<tr>
				<td valign="top"><code>name</code></td>
				<td valign="top"><code>string</code></td>
				<td valign="top" class="required">Yes</td>
				<td valign="top"><code></code></td>
				<td valign="top"> The name of the application folder you want to add wheels support to.</td>
			</tr>
		
			<tr class="odd">
				<td valign="top"><code>path</code></td>
				<td valign="top"><code>string</code></td>
				<td valign="top" class="required">No</td>
				<td valign="top"><code>name</code></td>
				<td valign="top"> The path to the folder you want to make wheels enabled apps in(relative to to the wheels Application.cfc)</td>
			</tr>
		
			<tr>
				<td valign="top"><code>keyword</code></td>
				<td valign="top"><code>string</code></td>
				<td valign="top" class="required">No</td>
				<td valign="top"><code>name</code></td>
				<td valign="top"> Used as a trigger in constructing routes for the current application folder. (<code>pattern="keyword/[name]/[controller]/[action]"</code>)</td>
			</tr>
		
	</tbody>
</table>
