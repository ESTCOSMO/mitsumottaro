angular.module 'projectsControllers', ['ui.bootstrap']
angular.module 'mitsumottaroApp', ['ngResource','ngRoute','projectsControllers']
angular.module('mitsumottaroApp').config ($httpProvider) ->
  authToken = $("meta[name=\"csrf-token\"]").attr("content")
  headers = $httpProvider.defaults.headers
  headers.common["X-CSRF-TOKEN"] = authToken
  headers.patch = headers.patch || {}
  headers.patch['Content-Type'] = 'application/json'

