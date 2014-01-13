var Backbone = require('backbone');
var $ = require('jquery/dist/jquery')(window);
Backbone.$ = $;

module.exports = Backbone.View.extend({
  initialize: function() {
    this.render();
  },
  render: function() {
    $('body').prepend('JS works too!!!');
  }
});
