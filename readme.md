
     ______               __     __
    /_  __/__ __ _  ___  / /__ _/ /____
     / / / -_)  ' \/ _ \/ / _ `/ __/ -_)
    /_/  \__/_/_/_/ .__/_/\_,_/\__/\__/
                 /_/    



#Template

script project template
supports WebStorm and VS Code

### Workflow 
* Mixed typescript. coffeescript, javascript and resources in the lib/ and optional 
example/ folders are watched, transpiled and or copied to the web/ folder. Classes are still in separate
files and there are source maps to facilitate debugging.
* Web folder is built to the build/web folder. This involves cating, minifying and compiling to 
to one file per library, or even one file per application.
* Build folder may be published to the project gh-pages
* Build folder may be deployed downstream to android projects, such as cordova or cocoos2d

### Tasks:

Defined in package.json:
* *android* build android target
* *build* builds the primary target 
* *clean* delete prior build
* *compile* runs closurebuilder.py
* *config* creates build script in package.json 
* *convert* converts the coffeescript outputs for closure
* *deploy* build/web to another folder
* *get* prebuilt libraries from repository
* *jsdoc* create documnetation from closure version
* *manifest* create an appcache manifest in the build/web/ folder
* *publish* build/web to gh-pages
* *resources* copy the resources
* *start* serves web/
* *serve* build/web/ in broswer
* *test* run unit tests
* *transpile* lib to web/src

### Structure:

      | -- .settings              for vscode
      |     | -- launch.json      F5 to run
      |     | -- settings.json    ide preferences
      |     + -- tasks.json       npm script runner
      | -- bin                    public tools
      | -- build                  compiled output
      | -- example                example using the lib
      | -- lib                    sources for this project - library or application
      | -- node_modules           npm dependencies
      | -- packages               local repository
      | -- test                   unit tests
      | -- tools                  private tools
      |     | -- compiler.jar     closure compiler
      |     | -- convert.coffee   coffee2closure script
      |     | -- diff.coffee      diff_match_patch script
      |     + -- server.js        for F5 in vscode
      | -- web                    application root. For library, this uses example
      |     | -- index.html       default web page
      |     | -- main.js*         cocos2d default script
      |     | -- project.json*    cocos2d manifest
      |     | -- frameworks*      cocos2d lib
      |     | -- res              resources
      |     + -- src              transpiler target, respository pre-builts
      |           | -- {lib}
      |           | -- example
      |           + -- ...
      | -- .bowerrc               defines ./packages repository
      | -- travis.yaml*           ci template
      | -- bower.json             module name, packages
      | -- Cakefile               misc tasks
      | -- changes.md             change log
      | -- conf.json*             jsdoc configuration
      | -- csconfig.json*         coffeescript source file list
      | -- gulpfile.js            npm script runner for webstorm ide
      | -- index.js               require entry point
      | -- jsconfig.json          javascript source file list
      | -- LF                     insert \n between source files with cat
      | -- license.md             take your pick - MIT/GPL3 
      | -- package.json           node project info
      + -- tsconfig.json*         typescript project file

                        * = optional

    
# Usage

git clone git@github.com:darkoverlordofdata/template.git myproject
cd myproject
npm install


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
