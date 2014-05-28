Backbone = require 'backbone'
$ = require 'jquery'
Backbone.$ = $


AppView = require './view/appView.coffee'
TestView = require './view/testView.js'

url = require 'url'
parts = url.parse window.location
console.log parts, 'unknown stuff'

appView = new AppView()
testView = new TestView()
