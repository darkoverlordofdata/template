
     ______               __     __
    /_  __/__ __ _  ___  / /__ _/ /____
     / / / -_)  ' \/ _ \/ / _ `/ __/ -_)
    /_/  \__/_/_/_/ .__/_/\_,_/\__/\__/
                 /_/    



#Template

script project template
supports WebStorm and VS Code


     Tasks:
    
     build   - create build/web
     deploy  - deploy to location
     dist    - create build bundles
     get     - gets packages dependencies in bower
     help    - display this message
     publish - publish gh-pages
     serve   - open build\web\ in browser
     test    - open web\ in browser
    
     project
     | -- .settings              VS Code folder
     | -- bin                    tools
     | -- build                  output folder for zip
     | -- example                example using the lib
     | -- lib                    defines this packages
     | -- node_modules           npm dependencies
     | -- packages               bower external packages
     | -- test                   unit tests
     | -- tools                  other tools
     | -- web                    source
     |     | -- index.html       default web page
     |     | -- main.js          cocos2d boot
     |     | -- manifest.json    android 'save to home screen'
     |     | -- project.json     cocos2d manifest
     |     | -- frameworks       cocos2d lib
     |     | -- res              resources
     |     + -- (src | packages) packages
     |           | -- {lib}
     |           | -- example
     |
     | -- .bowerrc               define ./packages
     | -- .gitignore             build, node_modules, tmp, packages
     | -- bower.json             module name, packages
     | -- csconfig.json          coffee-script project config
     | -- gulpfile.coffee        this workflow
     | -- gulpfile.json          gulpfile configuration
     | -- license.md
     | -- packages.json          output packages name
     + -- readme.md
    
     coffee -o .. -cb gulpfile.coffee
    



pick a license:

# MIT License

Copyright (c) 2015 Bruce Davidson &lt;darkoverlordofdata@gmail.com&gt;

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

# GPLv3 License

Copyright (c) 2015 Bruce Davidson <darkoverlordofdata@gmail.com>

This file is part of {{template}}.

{{template}} is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

{{template}} is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Alien Zone.  If not, see <http://www.gnu.org/licenses/>.
