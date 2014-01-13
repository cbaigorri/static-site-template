AppView = require './view/appView.coffee'
TestView = require './view/testView.js'

Backbone = require 'backbone'
$ = require('jquery/dist/jquery')(window)
Backbone.$ = $

url = require 'url'
parts = url.parse window.location
console.log parts, 'unknown stuff'

appView = new AppView()
testView = new TestView()
