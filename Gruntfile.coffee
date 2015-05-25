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
      preview:
        options:
          port: 9002
          bases: ['release']
          keepalive: true
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
        files: ['src/**/*.{js,coffee,less,html,jade}']
        tasks: ['compile']
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
      build:
        options:
          pretty: true
          # you can provide specfic content to a template by using the src, dest params
          data: (src, dest) ->
            require './data/content.json'
        files: [
          expand: true
          src: 'pages/**/*.jade'
          dest: 'build/'
          cwd: 'src/views'
          ext: '.html'
          rename: (src, dest) ->
            dest = dest.split('/')
            dest.shift()
            src + dest.join('/')
        ]
      release:
        options:
          pretty: false
          # you can provide specfic content to a template by using the src, dest params
          data: (src, dest) ->
            require './data/content.json'
        files: [
          expand: true
          src: 'pages/**/*.jade'
          dest: 'release/'
          cwd: 'src/views'
          ext: '.html'
          rename: (src, dest) ->
            dest = dest.split('/')
            dest.shift()
            src + dest.join('/')
        ]

    # Less
    less:
      build:
        options:
          paths: 'src/less'
          compress: false
          cleancss: false
        files:
          'build/css/style.css': 'src/less/main.less'
      release:
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
            expand: true
            cwd: 'build/'
            src: ['*.html']
            dest: 'reports/'
            ext: '-report.txt'
        ]

    # Copy
    copy:
      build:
        expand: true
        cwd: 'src/'
        src: ['**/*.{html,png,jpg,gif,svg,css,js,json,woff,woff2,ttf,eot,txt}']
        dest: 'build/'
      release:
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
        files: [
          expand: true
          src: '**/*.html'
          dest: 'release/'
          cwd: 'release/'
        ]

    # Compress HTML
    htmlmin:
      dist:
        options:
          removeComments: true
          collapseWhitespace: true
          removeCommentsFromCDATA: true
        files: [
          expand: true
          src: '**/*.html'
          dest: 'release/'
          cwd: 'release/'
        ]

    # Compress Images
    imagemin:
      release:
        options:
          optimizationLevel: 7
          progressive: true
          interlaced: true
          pngquant: true
        files: [
          expand: true
          cwd: 'release/'
          src: ['**/*.{png,jpg,gif}']
          dest: 'release/'
        ]
    # Build number

    # Deploy
    rsync:
      options:
        args: ["--verbose"]
        exclude: [
        ]
        recursive: true
        ssh: true
        privateKey: '/path/to/your.pem'
      prod:
        options:
          src: "release/"
          dest: "/srv/www/"
          host: "user@0.0.0.0"


  # This is required for the accessibility task
  grunt.loadTasks 'tasks'

  # Dependencies
  require('matchdep').filterDev('grunt-*').forEach(grunt.loadNpmTasks)

  # Test
  grunt.registerTask 'test', ['compile', 'htmllint', 'csslint', 'accessibility']
  # Compile
  grunt.registerTask 'compile', ['clean:build', 'copy:build','jade:build', 'less:build', 'coffeelint', 'browserify']
  # Development
  grunt.registerTask 'dev', ['compile', 'express', 'watch']
  # Release Preview
  grunt.registerTask 'preview', ['express:preview', 'express-keepalive']
  # Release
  grunt.registerTask 'release', ['compile', 'clean:release', 'copy:release', 'less:release', 'processhtml', 'uglify', 'htmlmin', 'imagemin', 'clean:releaseExtras']
  # Deploy
  grunt.registerTask 'deploy', ['release', 'rsync:prod']
