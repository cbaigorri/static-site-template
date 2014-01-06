# Grunt Wrapper
module.exports = (grunt) ->

  grunt.initConfig
    # Connect server
    connect:
      server:
        options:
          port: 9001
          base: 'build'
          keepalive: true
          livereload: true
    # Watch
    watch:
      options:
        dateFormat: (time) ->
          grunt.log.writeln 'Watch finished in ' + time + 'ms at ' + (new Date()).toString()
          grunt.log.writeln 'Waiting for changes...'
        livereload: true
      src:
        options:
          livereload: false
        files:[
          'src/**/*.coffee'
          'src/**/*.less'
          'src/**/*.jade'
        ]
        tasks: ['default']
      # Live reload
      livereload:
        options:
          livereload: true
        files: ['build/**/*']
    # Clean
    clean:
      build: ['build']
      release: ['release']
    #Jade
    jade:
      compile:
        options:
          pretty: true
        files:
          'build/index.html': 'src/index.jade'
    # Less
    less:
      development:
        options:
          paths: 'src/less'
        files:
          'build/css/style.css': 'src/less/main.less'
      production:
        options:
          paths: 'src/less'
          compress: true
          cleancss: true
        files:
          'build/css/style.css': 'src/less/main.less'
    # Browserify
    browserify:
      dist:
        files:
          'build/js/bundle.js': [
            'src/js/index.coffee'
          ]
        options:
          transform: ['coffeeify']
    # JSHint
    jshint:
      options:
        browser: true
        globals:
          jQuery: true
      all: [
        'build/bundle.js'
      ]
    # Coffee Lint
    coffeelint:
      options:
        'no_trailing_whitespace':
          'level': 'error'
        'max_line_length':
          'level': 'ignore'
      app: [
        'Gruntfile.coffee'
        'src/index.coffee'
      ]

  grunt.loadNpmTasks 'grunt-contrib-clean'
  grunt.loadNpmTasks 'grunt-contrib-jade'
  grunt.loadNpmTasks 'grunt-contrib-connect'
  grunt.loadNpmTasks 'grunt-contrib-jshint'
  grunt.loadNpmTasks 'grunt-contrib-uglify'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-coffeelint'
  grunt.loadNpmTasks 'grunt-contrib-less'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-contrib-concat'
  grunt.loadNpmTasks 'grunt-browserify'

  grunt.registerTask 'default', ['clean', 'jade', 'less', 'coffeelint', 'browserify']
  grunt.registerTask 'dev', ['default', 'connect', 'watch']
