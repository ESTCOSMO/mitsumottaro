angular.module('mitsumottaroApp').factory 'MoveHigherCategory', ($resource) ->
  $resource('/api/projects/:project_id/categories/:id/move_higher', { id: '@id', project_id: '@project_id' },{'update': {method: 'PATCH'}})

angular.module('mitsumottaroApp').factory 'MoveLowerCategory', ($resource) ->
  $resource('/api/projects/:project_id/categories/:id/move_lower', { id: '@id', project_id: '@project_id' },{'update': {method: 'PATCH'}})

angular.module('mitsumottaroApp').factory 'MoveHigherSubCategory', ($resource) ->
  $resource('/api/projects/:project_id/categories/:category_id/sub_categories/:id/move_higher', { id: '@id', project_id: '@project_id', category_id: '@category_id' },{'update': {method: 'PATCH'}})

angular.module('mitsumottaroApp').factory 'MoveLowerSubCategory', ($resource) ->
  $resource('/api/projects/:project_id/categories/:category_id/sub_categories/:id/move_lower', { id: '@id', project_id: '@project_id', category_id: '@category_id' },{'update': {method: 'PATCH'}})

angular.module('mitsumottaroApp').factory 'MoveHigherStory', ($resource) ->
  $resource('/api/projects/:project_id/categories/:category_id/sub_categories/:sub_category_id/stories/:id/move_higher', { id: '@id', project_id: '@project_id', category_id: '@category_id', sub_category_id: '@sub_category_id' },{'update': {method: 'PATCH'}})

angular.module('mitsumottaroApp').factory 'MoveLowerStory', ($resource) ->
  $resource('/api/projects/:project_id/categories/:category_id/sub_categories/:sub_category_id/stories/:id/move_lower', { id: '@id', project_id: '@project_id', category_id: '@category_id', sub_category_id: '@sub_category_id' },{'update': {method: 'PATCH'}})

