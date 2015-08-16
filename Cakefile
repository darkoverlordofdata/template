###
#+--------------------------------------------------------------------+
#| Cakefile
#+--------------------------------------------------------------------+
#| Copyright DarkOverlordOfData (c) 2014-2015
#+--------------------------------------------------------------------+
#|
#| workflow
#|
#| workflow is free software; you can copy, modify, and distribute
#| it under the terms of the MIT License
#|
#+--------------------------------------------------------------------+
#
# Tasks:
#
# build   - compile app to build/
# deploy  - deploy build/web/ to location
# get     - get dependencies from bower repository
# help    - display this message
# publish - publish build/web/ to gh-pages
# serve   - open build/web in browser
# test    - open web/ in browser with live reload
#
# | -- bin                    public tools
# | -- build                  compiled output
# | -- example                example using the lib
# | -- lib                    sources for this project - library or application
# | -- node_modules           npm dependencies
# | -- packages               local repository
# | -- test                   unit tests
# | -- tools                  private tools
# | -- web                    application root. For library, this uses example
# |     | -- index.html       default web page
# |     | -- main.js          optional cocos2d default script
# |     | -- project.json     optional cocos2d manifest
# |     | -- frameworks       optional cocos2d lib
# |     | -- res              optional cocos2d resources
# |     + -- (src | packages) compiled lib target, respository pre-built
# |           | -- {lib}
# |           | -- example
# |           + -- ...
# | -- .bowerrc               defines ./packages repository
# | -- bower.json             module name, packages
# | -- Cakefile               this workflow
# | -- package.json           node project info
# + -- tsconfig.json          optional typescript project file
#
###


fs = require('fs')

option '-c', '--compile [LEVEL]', 'closure compiler level'
option '-v', '--version [VERSION]', 'version to bump: major|minor|patch'

option '-h', '--host [HOST]', 'serve server hostname'
option '-p', '--port [PORT]', 'serve server port'
option '-l', '--log [LOG]', 'serve server loggging style (default: dev)'
option '-r', '--release', 'release mode'

###
 * cocos
 *
 * run cocos to build android apk
###
task 'cocos', '', (options) ->

  require('child_process').exec """
    cd web && cocos compile -p android --ndk-mode debug --android-studio
  """, (err, out) ->
    throw err if err
    console.log out
  

###
 * prebuild make
 *
 * before build step
 * re-write the build script
###
task 'prebuild:make', 'compile app to build', (options) ->

  options.compile ?= 'ADVANCED_OPTIMIZATIONS'

  files = getCocos2dFiles(true).join(' LF ')
  c0 = """
    cp -f lib/src/cclib-rt.js web/src/alienzone/cclib-rt.js
    cp -f web/index.html build/web/index.html
    cp -f web/license.md build/web/license.md
    cp -f web/readme.md build/web/readme.md
    cp -f web/main.js build/web/main.js
    cp -f web/project.json build/web/project.json
    cp -f web/manifest.json build/web/manifest.json
    cp -f web/license.js build/web/license.js
  """.split('\n').join(' && ')

  if options.compile?
    c1 = "cat #{files} | java -jar tools/compiler.jar --jscomp_error=checkTypes --warning_level=QUIET --compilation_level #{options.compile} --js_output_file build/web/main.js"
  else
    c1 = """
      cp -fr web/src build/web/src
      mkdir build/web/frameworks
      cp -fr web/frameworks/cocos2d-html5 build/web/frameworks/cocos2d-html5
    """.split('\n').join(' && ')
     
  project = require('./package.json')  
  
  project['scripts']['build'] = "#{c0} && #{c1}"
  require('fs').writeFileSync('./package.json', JSON.stringify(project, null, '  '))
  

###
 * postbuild update
 *
 * after build step
 * update the cocos2d project file
###
task 'postbuild:update', 'update cocos2d project file', (options) ->
  
  project = require('./build/web/project.json')
  delete project['modules']
  delete project['jsList']
  delete project['engineDir']
  fs.writeFileSync('./build/web/project.json', JSON.stringify(project))
  
###
 * preandroid make
 *
 * before build step
 * re-write the build script
###
task 'preandroid:make', 'compile app to android project', (options) ->

  options.compile ?= 'WHITESPACE_ONLY'

  files = getCocos2dFiles(false).join(' LF ')
  c0 = """
    cp -f lib/src/cclib-rt.js web/src/alienzone/cclib-rt.js
    cp -f web/main.js ./web/frameworks/runtime-src/proj.android-studio/app/assets/main.js
    cp -f web/project_android.json ./web/frameworks/runtime-src/proj.android-studio/app/assets/project.json
  """.split('\n').join(' && ')

  if options.compile?
    c1 = "cat #{files} | java -jar tools/compiler.jar --warning_level=QUIET --compilation_level #{options.compile} --js_output_file ./web/frameworks/runtime-src/proj.android-studio/app/assets/alienzone.js"
  else
    c1 = """
      cp -fr web/src ./web/frameworks/runtime-src/proj.android-studio/app/assets/src
    """.split('\n').join(' && ')
     
  project = require('./package.json')  
  
  project['scripts']['android'] = "#{c0} && #{c1}"
  require('fs').writeFileSync('./package.json', JSON.stringify(project, null, '  '))
  
###
 * get patch
 *
 * get dependencies
###
task 'get:patch', 'get dependencies from bower repository', (options) ->

  patch "web/src/jmatch3/jmatch3.js", "tools/patch/jmatch3.js.patch"
  patch "web/src/tween.ts/tween.min.js", "tools/patch/tween.min.js.patch"


###
 * version bump
 *
 * bump the version number
 * write the version source file
 *
 * cake -v patch version
 * cake -v minor version
 * cale -v major version
###
task 'version:bump', 'bump the version', (options) ->

  options.version ?= 'patch'

  project = require('./package.json')
  ###
   *
   * Q but doesn't npm already do thsi?
   * A if fails from the ide because I track my workspace in git
  ###
  project.version = require('semver').inc(project.version, options.version)
  fs.writeFileSync('./package.json', JSON.stringify(project, null, '    '))

  liquid = require('liquid.coffee')
  tpl = fs.readFileSync('./lib/src/build.ts.tpl', 'utf8')
  fs.writeFileSync('./lib/src/build.ts', liquid.Template.parse(tpl).render(VERSION: project.version))

###
 * Patch
 *
 * @see https://code.google.com/p/google-diff-match-patch/
 *
 * @param {string} source filename
 * @param {string} changes patch filename
###
patch = (source, changes) ->
  DiffMatchPatch = require('./tools/diff_match_patch/javascript/diff_match_patch_uncompressed.js').diff_match_patch
  dmp = new DiffMatchPatch()

  orig = fs.readFileSync(source, 'utf8')
  delta = fs.readFileSync(changes, 'utf8')
  results = dmp.patch_apply(dmp.patch_fromText(delta), orig)
  fs.writeFileSync(source, results[0])

###
 *
 * Get Cocos2d Files
 *
 * get list of source files for cocos2d projects
 *
 * @param {boolean} standalone - include cocos2d libraries + main
 * @return {Array<string>} list of file names
###
getCocos2dFiles = (standalone=false) ->

  cocos2d = require("./web/project.json")

  root = "./web/#{cocos2d.engineDir}"
  if standalone # include the framework
    moduleConfig = require("#{root}/moduleConfig.json")
    files = ["#{root}/#{moduleConfig.bootFile}"]
    for module in cocos2d.modules
      for name, value of moduleConfig.module[module]
        for file in moduleConfig.module[value]
          files.push("#{root}/#{file}") unless moduleConfig.module[file]?
  else files = []

  for file in cocos2d.jsList
    files.push("./web/#{file}")

  files.push("./web/main.js") unless standalone
  return files

