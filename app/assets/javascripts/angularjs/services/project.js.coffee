angular.module('mitsumottaroApp').factory 'Project', ($resource) ->
  $resource('/api/projects/:id', { id: '@id'})

