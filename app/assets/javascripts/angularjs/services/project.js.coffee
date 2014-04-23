angular.module('mitsumottaroApp').factory 'Project', ($resource) ->
  class Project
    constructor: ->
      @service = $resource('/api/projects/:id', { id: '@id'})
    create: (attrs) ->
      new @service(project: attrs).$save (project) ->
        attrs.id = project.id
      attrs
    all: ->
      @service.query()

