angular.module('mitsumottaroApp').factory 'SubCategory', ['$resource', ($resource) ->
  $resource('/api/projects/:project_id/categories/:category_id/sub_categories/:id', { id: '@id', project_id: '@project_id', category_id: '@category_id'},{'update': {method: 'PATCH'}})
]

