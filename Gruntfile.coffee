# Grunt Wrapper
module.exports = (grunt) ->

  grunt.initConfig
    # Express
    express:
      server:
        options:
          port: 9001
          bases: ['build']
          livereload: true
    # # Connect server
    # connect:
    #   server:
    #     options:
    #       port: 9001
    #       base: 'build'
    #       keepalive: true
    #       livereload: true

    # Watch
    watch:
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
          dateFormat: (time) ->
            grunt.log.writeln 'Watch finished in ' + time + 'ms at ' + (new Date()).toString()
            grunt.log.writeln 'Waiting for changes...'
          livereload: true
        files: ['build/**/*']

    # Clean
    clean:
      build: ['build']
      release: ['release']
      releaseExtras: ['release/css/style.css', 'release/js/bundle.js']

    #Jade
    jade:
      development:
        options:
          pretty: true
        files:
          'build/index.html': 'src/index.jade'
      production:
        options:
          pretty: false
        files:
          'release/index.html': 'relase/index.jade'

    # Less
    less:
      development:
        options:
          paths: 'src/less'
          compress: false
          cleancss: false
        files:
          'build/css/style.css': 'src/less/main.less'
      production:
        options:
          paths: 'src/less'
          compress: true
          cleancss: true
        files:
          'release/css/style.min.css': 'src/less/main.less'

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

    # HTML Lint
    htmllint:
      all: ['build/**/*.html']
    # CSS Lint
    # See rules: https://github.com/stubbornella/csslint/wiki/Rules
    csslint:
      options:
        csslintrc: '.csslintrc'
      default:
        src: ['build/css/**/*.css']

    # Accessibility
    accessibility:
      options:
        accessibilityLevel: 'WCAG2A'
      test:
        files: [
            expand: false
            cwd: 'build/'
            src: ['*.html']
            dest: 'reports/'
            ext: '-report.txt'
        ]

    # Copy
    copy:
      main:
        expand: true
        cwd: 'build/'
        src: '**'
        dest: 'release/'

    # Ugilfy
    uglify:
      release:
        files:
          'release/js/bundle.min.js': ['release/js/bundle.js']

    # Process HTML
    processhtml:
      dist:
        options:
          process: true
        files:
          'release/index.html': ['release/index.html']

    # Compress HTML
    htmlmin:
      dist:
        options:
          removeComments: true
          collapseWhitespace: true
          removeCommentsFromCDATA: true
        files:
          'release/index.html': 'relase/index.html'

    # Compress Images
    imagemin:
      release:
        files: [
          expand: true
          cwd: 'release/'
          src: ['**/*.{png,jpg,gif}']
          dest: 'release/'
        ]
    # Build number


  # This is required for the accessibility task
  grunt.loadTasks 'tasks'

  # Dependencies
  require('matchdep').filterDev('grunt-*').forEach(grunt.loadNpmTasks)

  # Test
  grunt.registerTask 'test', ['compile', 'htmllint', 'csslint', 'accessibility']
  # Compile
  grunt.registerTask 'compile', ['clean:build', 'jade:development', 'less:development', 'coffeelint', 'browserify']
  # Development
  grunt.registerTask 'dev', ['compile', 'express', 'watch']
  # Release
  grunt.registerTask 'release', ['compile', 'clean:release', 'copy', 'less:production', 'processhtml', 'uglify', 'htmlmin', 'imagemin', 'clean:releaseExtras']
