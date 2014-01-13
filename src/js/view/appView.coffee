Backbone = require 'backbone'
$ = require('jquery/dist/jquery')(window)
Backbone.$ = $

module.exports = Backbone.View.extend
  initialize: () ->
    @render()
  render: () ->
    $('body').prepend '<p>Woooooooooooo!!!</p>'
