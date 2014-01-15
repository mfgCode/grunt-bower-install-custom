grunt-bower-install-custom
==========================

This task will add references to css/js files into the bower section from an bower-install-custom.json file.
It will warn about modules where it finds files.

Purpose
--------------------------

If you use `grunt-bower-task` and `grunt-bower-install` with a correct specification of `main` in .bower.json (etc.)
will be inserted into the html source code of your webpage. You can either add the missing files manually or use
this grunt task to add those that are specified automatically.

The advantage is that over time the `main` value will be filled and this script can inform you about these changes.

Usage
==========================

Configure
