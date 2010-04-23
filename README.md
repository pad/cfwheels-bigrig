# BigRig

This is a pre-alpha release with some critical limitations. Don't use BigRig if you expect it to work for your own projects at this point.

For now, there is some initial configuration to get this all working. Mostly this is working towards a proof of concept for running multiple Wheels applications on a single server.

## Installation
Drop zip in plugins folder(you can download the latest tag and rename it to just BigRig-someversionnumberfromtag.zip)

Create a new folder to hold your rigs in your server's webroot(assuming that is where wheels is installed) - these parent folders will be referred to as BigRig folders.

Add a Wheels application(or Wheels applications) to your newly created BigRig folder, each with their own folder(myrigs/blog, myrigs/calendar, etc...).

Fix the Wheels.cfc in both the models and controllers folders for your applications so the relative path in the cfinclude points to your wheels install.

Add a call to addRig(name="#bigRigFolderName#") to your config/routes.cfm file to give your apps the default routes.

Any routes, settings etc in your rigs currently need to be moved to the main config/routes|settings|etc.cfm files... routes have some extra parameters that need to be set in order to work(see wiki). Looking into a solution for this still.

## Known Issues and Limitations

Datasources must be shared with all apps, or set independently in each model(hoping a better solution for this will present itself).

Static files are still being figured out.

There is at least one major bug with the model caching(which makes BigRig unusable when running Wheels in production mode) at the moment. Basically it tries initializing the Model.cfc as full ORM objects, looking for a table in your DB. Working on a clean way to fix this.