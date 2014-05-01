angular.module('projectsControllers').controller 'ProjectsController', ['$scope', 'Project', 'Category','SubCategory', 'Story', 'TaskPoint', 'MoveHigherCategory', 'MoveLowerCategory', 'MoveHigherSubCategory', 'MoveLowerSubCategory', 'MoveHigherStory', 'MoveLowerStory', '$routeParams', '$sce', ($scope, Project, Category, SubCategory, Story, TaskPoint, MoveHigherCategory, MoveLowerCategory, MoveHigherSubCategory, MoveLowerSubCategory, MoveHigherStory, MoveLowerStory, $routeParams, $sce) ->
  $scope.project = Project.get({id: $routeParams.id})
  $scope.saveCategory = saveCategory
  $scope.trustAsHtml = (html_code) -> $sce.trustAsHtml(html_code)
  $scope.buffer = () ->
    (sumOfDiffSquareOfProject($scope.project) ** (1.0 / 2)) / 2.0
  $scope.ratio = () ->
    1.0 + ($scope.buffer() / sumOfProjectPoints("50", $scope.project))


  saveCategory = (value) ->
    Category.get {project_id: $scope.project.id, id: value.id}, (c, getResponseHeaders) ->
      c.name = value.name
      c.$update (updatedCat, putResponseHeaders) ->
        $scope.project = Project.get({id: $routeParams.id})

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
      sum + ((x.point_90 - x.point_50) ** 2)
    , 0

  $scope.updateCategoryName = (project, category) ->
    Category.get {project_id: project.id, id: category.id} , (c, getResponseHeaders) ->
      c.name = category.name
      c.$update {project_id: project.id, id: category.id}

  $scope.updateSubCategoryName = (project, category, sub_category) ->
    SubCategory.get {project_id: project.id, category_id: category.id, id: sub_category.id} , (sc, getResponseHeaders) ->
      sc.name = sub_category.name
      sc.$update {project_id: project.id, category_id: category.id, id: sub_category.id }

  $scope.updateStoryName = (project, category, sub_category, story) ->
    Story.get {project_id: project.id, category_id: category.id, sub_category_id: sub_category.id, id: story.id} , (s, getResponseHeaders) ->
      s.name = story.name
      s.$update {project_id: project.id, category_id: category.id, sub_category_id: sub_category.id, id: story.id }

  $scope.updatePoint = (project, category, sub_category, story, point, point_type) ->
    newpoint = new TaskPoint
    newpoint["point_#{point_type}"] = point["point_#{point_type}"]
    newpoint.project_id = project.id
    newpoint.category_id = category.id
    newpoint.sub_category_id = sub_category.id
    newpoint.story_id = story.id
    newpoint.project_task_id = point.project_task_id
    newpoint.$save (saved, postHeaders) ->
      index = story.task_points.indexOf(point)
      story.task_points[index].id = saved.id

  $scope.createCategory = (project) ->
    category = new Category
    category.project_id = project.id
    category.name = "(新しい項目)"
    category.$save (c, postResponseHeaders) ->
      if project.categories
        project.categories.push c
      else
        project.categories = [ c ]

  $scope.createSubCategory = (project, category) ->
    subCategory = new SubCategory
    subCategory.project_id = project.id
    subCategory.category_id = category.id
    subCategory.name = "(新しい項目)"
    subCategory.$save (sc, postResponseHeaders) ->
      if category.sub_categories
        category.sub_categories.push sc
      else
        category.sub_categories = [ sc ]

  $scope.createStory = (project, category, subCategory) ->
    story = new Story
    story.project_id = project.id
    story.category_id = category.id
    story.sub_category_id = subCategory.id
    story.name = "(新しい項目)"
    story.$save (s, postResponseHeaders) ->
      if subCategory.stories
        subCategory.stories.push s
      else
        subCategory.stories.push [s]

  $scope.findPointByTaskId = (project_task_id, story) ->
    if story.task_points
      task_point = _.find story.task_points, (p) ->
        p.project_task_id == project_task_id

    if task_point
      task_point
    else
      new_point = new TaskPoint
      new_point.story_id = story.id
      new_point.project_task_id = project_task_id
      new_point.point_50 = 0
      new_point.point_90 = 0
      if story.task_points
        story.task_points.push new_point
      else
        story.task_points = [ new_point ]
      new_point

  $scope.countOfStoriesInCategory = (category) ->
    if category.sub_categories
      category.sub_categories.reduce((sum, sc) ->
        sum + sc.stories.length
      , 0)
    else
      0

  createMakeHigherLowerResource = (isHigher, project, category, sub_category, story) ->
    if story
      resource = if isHigher then new MoveHigherStory else new MoveLowerStory
      resource.project_id = project.id
      resource.category_id = category.id
      resource.sub_category_id = sub_category.id
      resource.id = story.id
    else if sub_category
      resource = if isHigher then new MoveHigherSubCategory else new MoveLowerSubCategory
      resource.project_id = project.id
      resource.category_id = category.id
      resource.id = sub_category.id
    else
      resource = if isHigher then new MoveHigherCategory else new MoveLowerCategory
      resource.project_id = project.id
      resource.id = category.id
    resource

  $scope.moveHigher = (project, category, sub_category, story) ->
    resource = createMakeHigherLowerResource(true, project, category, sub_category, story)
    resource.$update (updated, postHeaders) ->
      if story
        moveHigher(sub_category.stories, story)
      else if sub_category
        moveHigher(category.sub_categories, sub_category)
      else
        moveHigher(project.categories, category)

  $scope.moveLower = (project, category, sub_category, story) ->
    resource = createMakeHigherLowerResource(false, project, category, sub_category, story)
    resource.$update (updated, postHeaders) ->
      if story
        moveLower(sub_category.stories, story)
      else if sub_category
        moveLower(category.sub_categories, sub_category)
      else
        moveLower(project.categories, category)

  moveHigher = (collection, current) ->
    orig_position = parseInt(current.position)
    if orig_position > 1
      prev = collection.filter((item) -> parseInt(item.position) == (orig_position - 1))[0]
      current.position = orig_position - 1
      prev.position = orig_position

  moveLower = (collection, current) ->
    orig_position = parseInt(current.position)
    if orig_position < collection.length
      next = collection.filter((item) -> parseInt(item.position) == (orig_position + 1))[0]
      current.position = orig_position + 1
      next.position = orig_position

  $scope.categoriesOrder = (a) -> parseInt(a.position)
  $scope.subCategoriesOrder = (a) -> parseInt(a.position)
  $scope.storiesOrder =  (a) -> parseInt(a.position)

  $scope.ignoreEnterKey = (e) ->
    code = if e.keyCode then e.keyCode else e.which
    if code == 13
      e.preventDefault()
]
