## What's Appcastr?

Appcastr is a simply utility for Mac developers who publish updates using the Sparkle update system (or any other update system that uses [Appcasting](http://connectedflow.com/appcasting/) to publish updates). Appcastr provides a GUI interface for creating and editing appcast files that is slightly easier & quicker than just editing the raw XML file. Appcastr is currently in the early stages of development and is targeted towards making appcast files for the Sparkle update system. Currently, Appcastr features:

- The ability to create new appcast files and edit existing appcast files. 
- The ability to set the build number, version number, title, download link, size, signature, release notes link and publication date of an update. 
- Fancy Mac OS X Lion features like autosave and versions, which are probably not that important but they're there if you need them. 

Some things that Appcastr doesn't do but should and probably will do in the future:

- Support for multiple version updates in a single appcast file (currently, Appcastr will only read and edit one update item). 
- Support for specifying the minimum operating system version for an update (which would work nicely with supporting multiple version updates).
- Support for specifying delta updates. 