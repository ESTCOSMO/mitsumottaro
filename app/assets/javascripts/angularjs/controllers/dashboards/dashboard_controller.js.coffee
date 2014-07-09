angular.module('projectsControllers').controller 'DashboardController', ['$scope', 'Project', 'Category','SubCategory', 'Story', 'TaskPoint', '$routeParams', '$modal', '$window', ($scope, Project, Category, SubCategory, Story, TaskPoint, $routeParams, $modal, $window) ->

  # $scope.project = Project.get({id: $routeParams.id})
  $scope.project = Project.get({id: $scope.projectId})
  $scope.buffer = () ->
    Math.sqrt(sumOfDiffSquareOfProject($scope.project))

  ratio = () ->
    cache = 1.0 + ($scope.buffer() / sumOfProjectPoints("50", $scope.project))
    $scope.cachedRatio = cache
    cache

  $scope.ratio = ratio
  $scope.cachedRatio = 0

  sumOfProjectPoints = (percent, project, args) ->
    if !project.categories
      return 0

    project.categories.reduce (sum, x) ->
      sum + sumOfCategoryPoints(percent, x, args)
    ,0

  $scope.sumOfProjectPoints = sumOfProjectPoints

  sumOfCategoryPoints = (percent, category, args) ->
    if !category.sub_categories
      return 0

    category.sub_categories.reduce (sum, x) ->
      sum + sumOfSubCategoryPoints(percent, x, args)
    ,0

  $scope.sumOfCategoryPoints = sumOfCategoryPoints

  sumOfSubCategoryPoints = (percent, subCategory, args) ->
    if !subCategory.stories
      return 0

    subCategory.stories.reduce (sum, x) ->
      sum + sumOfStoryPoints(percent, x, args)
    ,0

  $scope.sumOfSubCategoryPoints = sumOfSubCategoryPoints

  sumOfStoryPoints = (percent, story, args) ->
    if !story.task_points
      return 0

    if args && args.projectTaskId
      task_points = (task_point for task_point in story.task_points when task_point.project_task_id == args.projectTaskId)
    else
      task_points = story.task_points

    task_points.reduce (sum, x) ->
      sum + (if x["point_#{percent}"] then parseInt(x["point_#{percent}"]) else 0)
    ,0

  $scope.sumOfStoryPoints = sumOfStoryPoints

  sumOfDiffSquareOfProject = (project) ->
    if !project.categories then return 0
    project.categories.reduce (sum, x) ->
      sum + sumOfDiffSquareOfCategory(x)
    , 0

  sumOfDiffSquareOfCategory = (category) ->
    if !category.sub_categories then return 0
    category.sub_categories.reduce (sum, x) ->
      sum + sumOfDiffSquareOfSubCategory(x)
    , 0

  sumOfDiffSquareOfSubCategory = (sub) ->
    if !sub.stories then return 0
    sub.stories.reduce (sum, x) ->
      sum + sumOfDiffSquareOfStory(x)
    , 0

  sumOfDiffSquareOfStory = (story) ->
    if !story.task_points then return 0
    story.task_points.reduce (sum, x) ->
      point50 = if x.point_50 then x.point_50 else 0
      point90 = if x.point_90 then x.point_90 else 0
      sum + ((point90 - point50) ** 2)
    , 0

  findPointByTaskId = (project_task_id, story) ->
    if story.task_points
      task_point = _.find story.task_points, (p) ->
        p.project_task_id == project_task_id

    if task_point
      task_point
    else
      new_point = new TaskPoint
      new_point.story_id = story.id
      new_point.project_task_id = project_task_id
      if story.task_points
        story.task_points.push new_point
      else
        story.task_points = [ new_point ]
      new_point

  $scope.findPointByTaskId = findPointByTaskId

  $scope.bufferedPointOfStoryTask = (project_task_id, story) ->
    point = findPointByTaskId(project_task_id, story)
    if point && (point.point_50 || point.point_50 == 0)
      point.point_50 * ratio()
    else
      null
]

