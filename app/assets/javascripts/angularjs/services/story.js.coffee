angular.module('mitsumottaroApp').factory 'Story', ($resource) ->
  $resource('/api/projects/:project_id/categories/:category_id/sub_categories/:sub_category_id/stories/:id', { id: '@id', project_id: '@project_id', category_id: '@category_id', sub_category_id: '@sub_category_id'},{'update': {method: 'PATCH'}})
