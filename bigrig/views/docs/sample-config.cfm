<p>With BigRig, you could support a complex configuration like this - with all of the <strong>mvc</strong> folders being wheels enabled:</p>

<style>
#content ul { list-style: none; margin: 0; padding: 0 0 0 15px; border-left: solid 1px #eee; }
</style>

&lt;server>
<ul>
	<li>&lt;webroot>
		<ul>
			<li>&lt;apps> - (extra app folder next to wheels install - requires a mapping)
				<ul>
					<li>&lt;blog>
						<ul>
							<li><strong>&lt;controllers></strong></li>
							<li><strong>&lt;models></strong></li>
							<li><strong>&lt;views></strong></li>
						</ul>
					</li>
					<li>&lt;calendar>
						<ul>
							<li><strong>&lt;controllers></strong></li>
							<li><strong>&lt;models></strong></li>
							<li><strong>&lt;views></strong></li>
						</ul>
					</li>
				<li>&lt;etc> - (as many individual, wheels-enabled app folders as you want/need)</li>
				</ul>
			</li>
			<li>...</li>
			<li><strong>&lt;controllers></strong></li>
			<li><strong>&lt;models></strong></li>
			<li><strong>&lt;views></strong></li>
			<li>...</li>
			<li>&lt;wheels></li>
		</ul>
	</li>
	<li>&lt;ecommerce> - (app folder is outside of webroot, requires a mapping)
		<ul>
			<li>&lt;registration>
				<ul>
					<li><strong>&lt;controllers></strong></li>
					<li><strong>&lt;models></strong></li>
					<li><strong>&lt;views></strong></li>
				</ul>
			</li>
			<li>&lt;cart>
				<ul>
					<li><strong>&lt;controllers></strong></li>
					<li><strong>&lt;models></strong></li>
					<li><strong>&lt;views></strong></li>
				</ul>
			</li>
		</ul>
	</li>
	<li>&lt;etc> - (more folders with multiple apps in them - provided each root folder has a mapping)</li>
</ul>

<p>
<br/>
Mappings are the main limitation of BigRig. Yes, I know most won't want that. If you have a solution that doesn't require mappings, please share.</p>
</p>