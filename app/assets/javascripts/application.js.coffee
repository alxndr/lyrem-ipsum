#= require jquery
#= require jquery_ujs
#= require turbolinks
#= require underscore
#= require backbone
##= require backbone.marionette
#= require li
#= require_tree ../templates
#= require_tree ./models
#= require_tree ./collections
#= require_tree ./views
#= require_tree ./routers

$ ->
  window.li = new LI();

