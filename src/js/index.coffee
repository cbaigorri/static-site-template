AppView = require './view/appView.coffee'

Backbone = require 'backbone'
$ = require('jquery/dist/jquery')(window)
Backbone.$ = $

url = require 'url'
parts = url.parse window.location
console.log parts, 'unknown stuff'

appView = new AppView()
