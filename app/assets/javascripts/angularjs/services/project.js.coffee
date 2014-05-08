angular.module('mitsumottaroApp').factory 'Project', ['$resource', ($resource) ->
  $resource('/api/projects/:id', { id: '@id'})
]
