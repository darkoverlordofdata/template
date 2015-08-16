module.exports =

  ###
   * Version - source code version
   *
   *  template  liquid template file
   *  source    file to create
   *  path      file to create
   *  key       liquid variable name
  ###
  "version":
    "template": "build.ts.tpl"
    "source": "build.ts"
    "path": "./lib/src"
    "key": "VERSION"

  ###
   * Build
   *
   *  library   true = library | false = application
   *  compile   true = compile | false = copy individual sources
   *  dest      destination folder
   *  sources   list of source files
   *  resources resource source files
   *  files     list of untransformed or resource file
  ###
  "build":
    "library": false
    "compile": true
    "dest": "build"
    "sources": [
      "web/src/**/*.*"
    ]
    "resources": [
      "lib/res/**/*.*"
    ]
    "files": [
      "web/res/**/*.*"
      "web/index.html"
      "web/license.md"
      "web/readme.md"
    ]

  ###
   * Deploy - copy build files
   *
   *  path    deployment path
   *  skip    drop this many leading path levels on destination
  ###
  "deploy":
    "path": "web/frameworks/runtime-src/alienzone/web/src/main/assets/"
    "skip": 2

  ###
   * Dependencies
   *
   * Repository pre built  libraries
   * name : path
  ###
  "dependencies":
    "localstoragedb": "localstoragedb.js"
    "jmatch3": "jmatch3.js"
    "tween.ts": "build/tween.min.js"
    "ash": "build/ash.js"

  ###
   * Patch
   *
   * Patch fixes to apply to dependencies
   * after copying from repositories
  ###
  "patch":
    "tween": 
      "tween.min.js": [["window.TWEEN=", "window['TWEEN']="]]


    "jmatch3":
      "jmatch3.js": [
        ["exports.jMatch3 =", "exports['jMatch3'] ="]
        [
          "Grid.directions = {\n        up: {\n            x: 0,\n            y: -1\n        },\n        down: {\n            x: 0,\n            y: 1\n        },\n        right: {\n            x: 1,\n            y: 0\n        },\n        left: {\n            x: -1,\n            y: 0\n        }\n    };"
          "Grid.directions = {};\n    Grid.directions['up'] = {};\n    Grid.directions['up'].x = 0;\n    Grid.directions['up'].y = -1;\n    Grid.directions['down'] = {};\n    Grid.directions['down'].x = 0;\n    Grid.directions['down'].y = 1;\n    Grid.directions['right'] = {};\n    Grid.directions['right'].x = 1;\n    Grid.directions['right'].y = 0;\n    Grid.directions['left'] = {};\n    Grid.directions['left'].x = -1;\n    Grid.directions['left'].y = 0;"
        ]
      ]
