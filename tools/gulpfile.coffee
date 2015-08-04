###
#+--------------------------------------------------------------------+
#| tools/gulpfile.coffee
#+--------------------------------------------------------------------+
#| Copyright DarkOverlordOfData (c) 2014-2015
#+--------------------------------------------------------------------+
#|
#| gulp-workflow
#|
#| gulp-workflow is free software; you can copy, modify, and distribute
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
# | -- lib                    sources for this project
# | -- node_modules           npm dependencies
# | -- packages               repository
# | -- test                   unit tests
# | -- tools                  private tools
# |     | -- config.json      this workflow config
# |     | -- gulpfile.coffee  this workflow source
# |     | -- server.js        superstatic configured to preview this project
# |     + -- ...
# | -- web                    app root
# |     | -- index.html       default web page
# |     | -- main.js          default script
# |     | -- manifest.json    android 'save to home screen'
# |     | -- project.json     cocos2d manifest
# |     | -- frameworks       cocos2d lib
# |     | -- res              resources
# |     + -- (src | packages) compiled lib target, respository pre-built
# |           | -- {lib}
# |           | -- example
# |           + -- ...
# | -- .bowerrc               define ./packages repository
# | -- .gitignore             build, node_modules, tmp, packages
# | -- bower.json             module name, packages
# | -- gulpfile.js            this workflow
# | -- jsconfig.json          javascript project config
# | -- license.md
# | -- package.json           node project info
# | -- readme.md
# + -- tsconfig.json          typescript project file
#
# coffee -o .. -cb gulpfile.coffee
#
###

###
 * load dependencies
###
fs          = require('fs')
del         = require('del')
path        = require('path')
gulp        = require('gulp')
bump        = require('gulp-bump')
copy        = require('gulp-copy')
gutil       = require('gulp-util')
coffee      = require('gulp-coffee')
concat      = require('gulp-concat')
filter      = require('gulp-filter')
rename      = require('gulp-rename')
change      = require('gulp-change')
flatten     = require('gulp-flatten')
gh_pages    = require('gulp-gh-pages')
manifest    = require('gulp-manifest')
webserver   = require('gulp-webserver')
bowerDeps   = require('gulp-bower-deps')
maps        = require('gulp-sourcemaps')
json        = require('gulp-json-editor')
replace     = require('gulp-batch-replace')
closure     = require('gulp-closure-compiler')
###
 * load project configuration
###
project     = require('./package.json')
bower       = require('./bower.json')
repository  = if fs.existsSync('./.bowerrc') then JSON.parse(fs.readFileSync('./.bowerrc', 'utf8')).directory else'packages'
config      = if fs.existsSync('./tools/config.json') then require('./tools/config.json') else false
jsconfig    = if fs.existsSync('./jsconfig.json') then require('./jsconfig.json') else false
cocos2d     = if fs.existsSync('./web/project.json') then require('./web/project.json') else false
packages    = if cocos2d then 'src' else 'packages'

gulp.task 'build', ['_build']
gulp.task 'dist', ['_dist']
gulp.task 'serve', ['_serve']
gulp.task 'test', ['_test']
gulp.task 'get', ['_get']
gulp.task 'publish', ['_publish']
gulp.task 'deploy', ['_deploy']
gulp.task 'default', ['help']
gulp.task 'help', ->
  console.log """
    gulpfile:

    # build   - compile app to build/
    # deploy  - deploy build/web/ to location
    # get     - get dependencies from bower repository
    # help    - display this message
    # publish - publish build/web/ to gh-pages
    # serve   - open build/web in browser
    # test    - open web/ in browser with live reload

    """


###
 * Task _build
 *
 * create the outputs
 * bump the version number
 * write the version source file
###
gulp.task '_build', ['_version'], ->
  return gulp.src(["#{config.build.dest}/web/**/*.*"])
  .pipe(manifest(
      hash: true
      timestamp: true
      preferOnline: false
      network: ['*']
      filename: 'manifest.appcache'
      exclude: 'manifest.appcache'
    ))
  .pipe(gulp.dest("#{config.build.dest}/web"))


###
 * Dist
 *
 * bundle up the source code
 * create a minified distribution
###
gulp.task '_dist', ['_bundle'], ->
  return gulp.src("#{config.build.dest}/#{project.name}.min.js")
    .pipe(closure(getClosureOptions()))
    .pipe(gulp.dest("#{config.build.dest}/"))


###
 * Serve
 *
 * serve the build folder
###
gulp.task '_serve', ->
  gulp.src("./#{config.build.dest}/web")
  .pipe webserver(
    livereload: false
    open: true
  )
  return

###
 * Test
 *
 * serve the dev folder
###
gulp.task '_test', ->
  gulp.src("./web")
  .pipe webserver(
    livereload: true
    open: true
  )
  return

###
 * Get
 *
 * get dependencies
 * apply patches
###
gulp.task '_get', ['_dependencies'], ->

  for dest, patch of config.patch
    for file, patch of patch
      "web/#{packages}/#{dest}/#{file}"
      gulp.src("web/#{packages}/#{dest}/#{file}")
      .pipe(replace(patch))
      .pipe(gulp.dest("web/#{packages}/#{dest}"))


###
 * Publish
 *
 * publish to github gh-pages
###
gulp.task '_publish', ->
  return gulp.src("./#{config.build.dest}/web/**/*.*")
  .pipe(gh_pages())


###
 * Deploy
 *
 * copy the build
###
gulp.task '_deploy', ->
  files = ("#{config.build.dest}/file" for file in config.build.files)
  gulp.src(["#{config.build.dest}/web/#{packages}/**/*.*"].concat(files))
    .pipe(copy(config.deploy.path, prefix: config.deploy.skip))



### P R I V A T E  T A S K S ###
###
 * Task _clean
 *
 * delete the build files
###
gulp.task '_clean', (next) ->
  del [config.build.dest], next
  return


gulp.task '_version', ['_bump'], ->

  ### reload the project config ###
  delete require.cache[path.resolve('./package.json')];
  project = require('./package.json')
  return gulp.src(config.version.path+'/'+config.version.source)
    .pipe(change((content) ->
      tmpl = fs.readFileSync(config.version.path+'/'+config.version.template, 'utf8')
      return tmpl.replace("{{ #{config.version.key} }}", project.version)
    ))
    .pipe(gulp.dest(config.version.path))

###
 * Task _bump
 *
 * bump the version number
###
gulp.task '_bump', ['_cocos2d'], ->
  return gulp.src('./package.json')
  .pipe(bump())
  .pipe(gulp.dest('./'))

###
 * Task _cocos2d
 *
 * fix the cocos2d project.json
###
gulp.task '_cocos2d', ['_copy'], ->

  if cocos2d and config.build.compile
    return gulp.src("web/project.json")
      .pipe(json((json) ->
        delete json["modules"]
        delete json["jsList"]
        return json
      )).pipe(gulp.dest("#{config.build.dest}/web"))

###
 * Task _copy
 *
 * create the outputs
 * copy lib/res to web
 * copies the web folder to the build folder
###
gulp.task '_copy', ['_compile','_resources'], ->

  # start with misc files
  source = (file for file in config.build.files)

  if !config.build.compile
    source = source.concat(config.build.sources)
    # copy cocos2 framework and entry point
    if cocos2d
      source.push("web/#{cocos2d.engineDir}/**/**.*")
      source.push("web/main.js")

  return gulp.src(source).pipe(copy(config.build.dest))


###
 * Task _res
 * ensure the web/res folder
###
gulp.task '_resources', ['_clean'], ->
  return gulp.src(config.build.resources).pipe(copy("web", prefix: 1))


###
 * Task _compile
 * compile sources to build dest
###
gulp.task '_compile', ['_clean'], ->
  if config.build.compile
    if cocos2d
      return gulp.src(getCocos2dFiles(true))
      .pipe(closure(getClosureOptions()))
      .pipe(gulp.dest("#{config.build.dest}/web"))
    else
      return gulp.src(config.build.sources)
      .pipe(closure(getClosureOptions()))
      .pipe(gulp.dest("#{config.build.dest}/web"))
  else return null

###
 * Task _dependencies
 * copy the dependencies from the repository
###
gulp.task '_dependencies', ->

  ###
   * build the dependencies hash
  ###
  dependencies = do ->
    dependencies =
      directory: repository
      deps: {}
    for name, version of bower.dependencies
      dependencies.deps[name] =
        version: version
        files: config.packages[name]
    return dependencies

  gulp.src(bowerDeps(dependencies).deps)
  .pipe(flatten())
  .pipe(rename( (path) ->
      path.dirname += '/'+ path.basename.split('.')[0]
      return
    ))
  .pipe(gulp.dest("web/#{packages}/"))

###
* Task _bundle
* bundle up the javascript into 1 file
###
gulp.task '_bundle', ['_concat'], ->
  return gulp.src("build/#{project.name}.js")
  .pipe(rename("#{project.name}.min.js"))
  .pipe(gulp.dest(config.build.dest))

###
* Task _concat
* bundle up the javascript into 1 file
###
gulp.task '_concat', ->
  return gulp.src(jsconfig.files ? "web/#{packages}/#{project.name}/**/*.js")
  .pipe(maps.init())
  .pipe(concat("#{project.name}.js"))
  .pipe(maps.write("."))
  .pipe(gulp.dest(config.build.dest))


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

  files.push("./web/main.js")
  return files

###
 *
 * Get Closure Options
 *
 * prepares the options for closure compiler
 *
 * @param {string} level - compiler level
 * @param {boolean} dbg - pretty print compiler output
 * @return {!Object} compiler options
###
getClosureOptions = (level='minify', dbg=false) ->
  options =
    "compilerPath": "packages/closure-compiler/compiler.jar"
    "fileName": "main.js"
    "compilerFlags":
      "compilation_level": switch level
        when 'advanced' then "ADVANCED_OPTIMIZATIONS"
        when 'simple' then "SIMPLE_OPTIMIZATIONS"
        when 'minify' then "WHITESPACE_ONLY"

      "warning_level": "QUIET"


  options.compilerFlags.formatting = 'pretty_print' if dbg
  return options
