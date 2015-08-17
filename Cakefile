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
# | -- .settings              for vscode
# |     | -- launch.json      F5 to run
# |     | -- settings.json    ide preferences
# |     + -- tasks.json       npm script runner
# | -- bin                    public tools
# | -- build                  compiled output
# | -- example                example using the lib
# | -- lib                    sources for this project - library or application
# | -- node_modules           npm dependencies
# | -- packages               local repository
# | -- test                   unit tests
# | -- tools                  private tools
# |     | -- compiler.jar     closure compiler
# |     | -- convert.coffee   coffee2closure script
# |     | -- diff.coffee      diff_match_patch script
# |     + -- server.js        for F5 in vscode
# | -- web                    application root. For library, this uses example
# |     | -- index.html       default web page
# |     | -- main.js*         cocos2d default script
# |     | -- project.json*    cocos2d manifest
# |     | -- frameworks*      cocos2d lib
# |     | -- res              resources
# |     + -- src              transpiler target, respository pre-builts
# |           | -- {lib}
# |           | -- example
# |           + -- ...
# | -- .bowerrc               defines ./packages repository
# | -- travis.yaml*           ci template
# | -- bower.json             module name, packages
# | -- Cakefile               misc tasks
# | -- changes.md             change log
# | -- conf.json*             jsdoc configuration
# | -- csconfig.json*         coffeescript source file list
# | -- gulpfile.js            npm script runner for webstorm ide
# | -- index.js               require entry point
# | -- jsconfig.json          javascript source file list
# | -- LF                     insert \n between source files with cat
# | -- license.md             take your pick - MIT/GPL3 
# | -- package.json           node project info
# + -- tsconfig.json*         typescript project file
#
###


fs = require('fs')

# projectTypes enum:
JavaScript    = 0   # javascript
TypeScript    = 1   # typescript
CoffeeScript  = 2   # coffeescript
BabelScript   = 3   # es6

option '-c', '--compile [LEVEL]', 'closure compiler level'
option '-v', '--version [VERSION]', 'version to bump: major|minor|patch'


###
 * config
 *
 * write out the tasks
###
task 'config', 'setup cake config', (options) ->


  # get project config
  project = require('./package.json')
  csconfig = if fs.existsSync('./csconfig.json') then require('./csconfig.json') else files: []
  jsconfig = if fs.existsSync('./jsconfig.json') then require('./jsconfig.json') else files: []
  tsconfig = if fs.existsSync('./tsconfig.json') then require('./tsconfig.json') else files: []

  projectType = if tsconfig.files.length>0 then TypeScript else if csconfig.files.length>0 then CoffeeScript else JavaScript
  isCocos2d = fs.existsSync('./web/project.json')

  scripts =
    ###
    # VS Code ctrl-shift-b
    ###
    _vscode_build: do ->
      switch projectType
        when TypeScript then "tsc --watch"
        when CoffeeScript then "coffee -o web/src/#{project.name} -wcm lib "

    ###
    # Build the android asset folder
    ###
    android: do ->
      options.compile ?= 'WHITESPACE_ONLY'

      if isCocos2d
        files = getCocos2dFiles(false).join(' LF ')
        step1 = """
          cp -f lib/src/cclib-rt.js web/src/#{project.name}/cclib-rt.js
          cp -f web/main.js ./web/frameworks/runtime-src/proj.android-studio/app/assets/main.js
          cp -f web/project_android.json ./web/frameworks/runtime-src/proj.android-studio/app/assets/project.json
        """.split('\n').join(' && ')

        if options.compile?
          step2 = "cat #{files} | java -jar tools/compiler.jar --warning_level=QUIET --compilation_level #{options.compile} --js_output_file ./web/frameworks/runtime-src/proj.android-studio/app/assets/#{project.name}.js"
        else
          step2 = """
            cp -fr web/src ./web/frameworks/runtime-src/proj.android-studio/app/assets/src
          """.split('\n').join(' && ')

        return "#{step1} && #{step2}"
      else # TBD - cordova?
        return ''

    ###
    # build the project
    #
    # * Cocos2d?
    #   * Compiled?
    # * CoffeeScript
    # * Typescript?
    ###
    build: do ->
      options.compile ?= 'ADVANCED_OPTIMIZATIONS'

      if isCocos2d
        files = getCocos2dFiles(true).join(' LF ')
        step1 = """
          cp -f lib/src/cclib-rt.js web/src/alienzone/cclib-rt.js
          cp -f web/index.html build/web/index.html
          cp -f web/main.js build/web/main.js
          cp -f web/project.json build/web/project.json
          cp -f web/manifest.json build/web/manifest.json
          """.split('\n').join(' && ')

        if options.compile?
          step2 = "cat #{files} | java -jar packages/closure-compiler/lib/vendor/compiler.jar --jscomp_error=checkTypes --warning_level=QUIET --compilation_level #{options.compile} --js_output_file build/web/main.js"
        else
          step2 = """
            cp -fr web/src build/web/src
            mkdir build/web/frameworks
            cp -fr web/frameworks/cocos2d-html5 build/web/frameworks/cocos2d-html5
            """.split('\n').join(' && ')

        return "#{step1} && #{step2}"
      else if projectType is CoffeeScript
        step1 = """
          cp -rf lib build
          cp -rf web/src build/web/src
          cp -f lib/ash.d.ts build/ash.d.ts
          cp -f web/example.html build/web/example.html
          cp -f web/favicon.png build/web/favicon.png
          cp -f web/example_build.html build/web/index.html
          cp -f web/main.js build/web/main.js
          """.split('\n').join(' && ')

        files = require('./csconfig.json').files.join(" LF ")
        step2 = "cat #{files} | coffee -cs > build/#{project.name}.js"
        step3 = "cat #{files} | coffee -cs | java -jar tools/compiler.jar --compilation_level WHITESPACE_ONLY --js_output_file build/#{project.name}.min.js"

        return "#{step1} && #{step2} && #{step3}"
      else
        step1 = """
          cp -rf lib build
          cp -rf web/src build/web/src
          cp -f web/example.html build/web/example.html
          cp -f web/favicon.png build/web/favicon.png
          cp -f web/example_build.html build/web/index.html
          cp -f web/main.js build/web/main.js
          """.split('\n').join(' && ')

        files = require('./jsconfig.json').files.join(" LF ")
        step2 = "cat #{files} > build/#{project.name}.js"
        step3 = "cat #{files} | java -jar tools/compiler.jar --compilation_level WHITESPACE_ONLY --js_output_file build/#{project.name}.min.js"
        
    ###
    # delete the prior build items
    ###
    clean: "rm -rf build/*"

    ###
    # build using the closure-compiler
    ###
    closurebuild: """
      python  packages/google-closure-library/closure/bin/build/closurebuilder.py \
        --root=packages/google-closure-library/ \
        --root=./goog/lib \
        --root=./goog/example \
        --input=./goog/example/index.js \
        --namespace=#{project.name} \
        --output_mode=compiled \
        --compiler_jar=packages/closure-compiler/lib/vendor/compiler.jar \
        --compiler_flag='--compilation_level=ADVANCED_OPTIMIZATIONS' \
        --compiler_flag='--define=goog.userAgent.ASSUME_WEBKIT=true' \
        --compiler_flag='--create_source_map=web/#{project.name}.js.map' \
        --compiler_flag='--warning_level=QUIET' \
        --compiler_flag='--language_in=ECMASCRIPT5' \
        > web/#{project.name}.min.js
    """

    ###
    # run this config task
    ###
    config: "cake config"

    ###
    # copy the output to downstream project
    ###
    deploy: """
      cp -rf web/res web/frameworks/runtime-src/proj.android-studio/app/assets
      cp -rf web/src web/frameworks/runtime-src/proj.android-studio/app/assets
      cp -f web/main.js web/frameworks/runtime-src/proj.android-studio/app/assets
      cp -f web/project.json web/frameworks/runtime-src/proj.android-studio/app/assets
    """

    ###
    # collect dependencies for closure compiler
    ###
    depswriter: """
      python packages/google-closure-library/closure/bin/build/depswriter.py \
        --root_with_prefix='goog/example ../../../../goog/example' \
        --root_with_prefix='goog/lib ../../../../goog/lib' \
        --root_with_prefix='web ../../../../web' \
        > web/#{project.name}.dep.js
    """

    ###
    # ensure the folder structure
    ###
    folder: """
      mkdir build/web
      mkdir build/lib
      cp -fr lib/src build/lib
      cp -fr web/res build/web
    """

    ###
    # process bower dependencies
    ###
    get: "bower-installer cake get"

    ###
    # publish gh-pages
    ###
    publish: "gulp gh-pages"

    ###
    # create documentation
    ###
    jsdoc: """
      jsdoc goog/lib -r \
        --template ../jaguarjs-jsdoc \
        --configure ./conf.json \
        --readme ./readme.md \
        --destination ./build/web
    """

    ###
    # create appcache manifest for build
    ###
    manifest: "gulp manifest"

    ###
    # update the cocos2d project file?
    ###
    postbuild: "cp -f web/project_build.json build/web/project.json"

    ###
    # get the dependencies
    ###
    postinstall: "bower install  npm run get"

    ###
    # prepare for android build
    ###
    preandroid: """
      npm run predeploy
      npm run transpile
      npm run resources
      cp -fr web/res ./web/frameworks/runtime-src/proj.android-studio/app/assets
    """

    ###
    # prepare for build
    ###
    prebuild: """
      npm run clean -s
      npm run transpile
      npm run resources
      npm run folders
    """

    ###
    # convert output for closure
    ###
    preclosurebuild: "coffee tools/convert.coffee"

    ###
    # remove prior deployment
    ###
    predeploy: """
      rm -rf web/frameworks/runtime-src/proj.android-studio/app/assets/res
      rm -rf web/frameworks/runtime-src/proj.android-studio/app/assets/src
      rm -f web/frameworks/runtime-src/proj.android-studio/app/assets/main.js
      rm -f web/frameworks/runtime-src/proj.android-studio/app/assets/project.json
    """

    ###
    # copy the resources
    ###
    resources: "cp -rf lib/res web/res"

    ###
    # run the dev version of the app
    ###
    start: "node ./tools/server.js web"

    ###
    # run the build version of the app
    ###
    serve: "node ./tools/server.js build/web"

    ###
    # run the unit tests
    ###
    test: "NODE_ENV=test mocha --reporter nyan"

    ###
    # transpile
    ###
    transpile: do ->
      switch projectType
        when TypeScript then "tsc"
        when CoffeeScript then "coffee -o web/src/ash -cm lib && coffee -o web/src/example -cm example"


  # fix multiline  script
  for name, script of scripts
    project.scripts[name] = script.split('\n').join(' && ')

  # update the npm package
  fs.writeFileSync('./package.json', JSON.stringify(project, null, '  '))



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
 * get patch
 *
 * get dependencies
###
task 'get', 'get dependencies from bower repository', (options) ->

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
task 'version', 'bump the version', (options) ->

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

  return [] unless fs.existsSync("./web/project.json")

  cocos2d = require("./web/project.json")

  root: "./web/#{cocos2d.engineDir}"
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


