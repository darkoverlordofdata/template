
     ______               __     __
    /_  __/__ __ _  ___  / /__ _/ /____
     / / / -_)  ' \/ _ \/ / _ `/ __/ -_)
    /_/  \__/_/_/_/ .__/_/\_,_/\__/\__/
                 /_/    



#Template

script project template
supports VS Code

### Workflow 
* Use tsc to compile
* Web folder is built to the build/web folder. This involves cating, minifying and compiling to 
to one file per library, or even one file per application.
* Build folder may be published to the project gh-pages
* Build folder may be deployed downstream to android projects, such as cordova or cocoos2d

### Tasks:

Defined in package.json:
* *_vscode_build* interactive build
* *build* builds the primary target 
* *clean* delete prior build
* *doc* create typedoc
* *postinstall* runs bower to get packages for web
* *prebuild* make sure it's a clean build
* *publish* build/web to gh-pages
* *start* serves web/
* *serve* build/web/ in broswer
* *test* run unit tests

### Structure:

      | -- .vscode                for vscode
      |     | -- launch.json      F5 to run
      |     | -- launch.nw.json
      |     | -- launch.server.json
      |     | -- server           simple server
      |     | -- settings.json    ide preferences
      |     + -- tasks.json       npm script runner
      | -- bin                    public tools
      | -- build                  compiled output
      | -- example                example using the lib
      | -- lib                    sources for this project - library or application
      | -- node_modules           npm dependencies
      | -- packages               local repository
      | -- test                   unit tests
      | -- web                    application root. For library, this uses example
      |     | -- index.html       default web page
      |     | -- res              resources
      |     + -- src              transpiler target, respository pre-builts
      |           | -- {lib}
      |           | -- example
      |           + -- ...
      | -- .bowerrc               defines ./packages repository
      | -- travis.yaml*           ci template
      | -- bower.json             module name, packages
      | -- changes.md             change log
      | -- gulpfile.js            npm script runner 
      | -- index.js               require entry point
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
