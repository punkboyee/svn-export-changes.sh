svn-export-changes.sh
=====================

This is a branch for incrementally deployment of webapp(j2ee) project (especially for bug-fixs), exported files could be put to WAR packages.

A general j2ee project structure:
--src # for java sources
--resouces # for resource files, i.e. framework configurations(spring etc. config and properties (logging, i18n, etc.
--WebContent # for referenced libs, compiled sources, etc.

When wrapping a WAR package, files under src and resources go to the WEB-INF/classes directory, compiled. This script specially deal with this to make it easier when you try to deploy a patch for wars.

=====================
Bash script for exporting svn files from a range of revisions

It can sometimes be a pain to export just modified files from SVN on the MAC/*nix machines. 

TortoiseSVN on windows has [a simple method for this]
(http://verysimple.com/2007/09/06/using-tortoisesvn-to-export-only-newmodified-files/)

This script is for everyone else.

Usage
--

Download this and chmod 755 it. Add it to your bin if you so desire, then it's as simple as 

`svn-export-changes repo-location`

The script will pull the changes to that repository between the HEAD and PREV and put it in a directory called 'export' (relative to the script location)

You can pass in a range of revisions and a location to export to.

`svn-export-changes repo-location revision-from revision-to export-directory`

That's it.

Portions taken from [this post](http://www.electrictoolbox.com/subversion-export-changed-files-cli/). Thanks to Chris Hope.




*"...there's a bash for that..."*
