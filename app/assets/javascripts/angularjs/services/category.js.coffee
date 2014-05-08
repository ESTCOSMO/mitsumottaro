angular.module('mitsumottaroApp').factory 'Category', ($resource) ->
  $resource('/api/projects/:project_id/categories/:id', { id: '@id', project_id: '@project_id'},{'update': {method: 'PATCH'}})

