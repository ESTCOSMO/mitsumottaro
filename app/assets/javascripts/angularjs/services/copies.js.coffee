angular.module('mitsumottaroApp').factory 'CopyCategory', ($resource) ->
  $resource('/projects/:project_id/categories/:id/copy', { id: '@id', project_id: '@project_id' })

angular.module('mitsumottaroApp').factory 'CopySubCategory', ($resource) ->
  $resource('/projects/:project_id/categories/:category_id/sub_categories/:id/copy', { id: '@id', project_id: '@project_id', category_id: '@category_id' })

angular.module('mitsumottaroApp').factory 'CopyStory', ($resource) ->
  $resource('/projects/:project_id/categories/:category_id/sub_categories/:sub_category_id/stories/:id/copy', { id: '@id', project_id: '@project_id', category_id: '@category_id', sub_category_id: '@sub_category_id' })

