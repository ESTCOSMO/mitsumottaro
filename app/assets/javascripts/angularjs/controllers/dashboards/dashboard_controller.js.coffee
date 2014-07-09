angular.module('projectsControllers').controller 'DashboardController', ['$scope', 'Project', 'Category','SubCategory', 'Story', 'TaskPoint', 'MoveHigherCategory', 'MoveLowerCategory', 'MoveHigherSubCategory', 'MoveLowerSubCategory', 'MoveHigherStory', 'MoveLowerStory', 'CopyCategory', 'CopySubCategory', 'CopyStory', '$routeParams', '$sce', '$modal', '$window', ($scope, Project, Category, SubCategory, Story, TaskPoint, MoveHigherCategory, MoveLowerCategory, MoveHigherSubCategory, MoveLowerSubCategory, MoveHigherStory, MoveLowerStory, CopyCategory, CopySubCategory, CopyStory, $routeParams, $sce, $modal, $window) ->
  $scope.editable = true
  $scope.project = Project.get({id: $routeParams.id})
  $scope.trustAsHtml = (html_code) -> $sce.trustAsHtml(html_code)
  $scope.buffer = ->
    cache = Math.sqrt(sumOfDiffSquareOfProject($scope.project))
    $scope.cachedBuffer = cache
    cache

  ratio = ->
    cache = 1.0 + ($scope.cachedBuffer / $scope.cachedSumOfProjectPointsOf50)
    $scope.cachedRatio = cache
    cache

  sumOfProjectPointsOf50 = -> 
    cache = sumOfProjectPoints("50", $scope.project)
    $scope.cachedSumOfProjectPointsOf50 = cache
    cache

  $scope.sumOfProjectPointsOf50 = sumOfProjectPointsOf50
  $scope.cachedSumOfProjectPointsOf50 = 0
  $scope.ratio = ratio
  $scope.cachedRatio = 0
  $scope.cachedBuffer = 0
  $scope.$watch("ratio()")
  $scope.$watch("buffer()")
  $scope.$watch("sumOfProjectPointsOf50()")

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

  $scope.updateCategoryName = (project, category) ->
    try
      Category.get {project_id: project.id, id: category.id} , (c, getResponseHeaders) ->
        c.name = category.name
        c.$update {project_id: project.id, id: category.id}
    catch error
      $window.alert "サーバーエラーが発生しました。画面をリロードしてください。"

  $scope.removeCategory = (project, category) ->
    try
      Category.get { project_id: project.id, id: category.id } , (c, getResponseHeaders) ->
        c.$remove {project_id: project.id, id: category.id }, (r, deleteResponse) ->
          idx = project.categories.indexOf(category)
          project.categories.splice(idx, 1)
    catch error
      $window.alert "サーバーエラーが発生しました。画面をリロードしてください。"

  $scope.updateSubCategoryName = (project, category, sub_category) ->
    try
      SubCategory.get {project_id: project.id, category_id: category.id, id: sub_category.id} , (sc, getResponseHeaders) ->
        sc.name = sub_category.name
        sc.$update {project_id: project.id, category_id: category.id, id: sub_category.id }
    catch error
      $window.alert "サーバーエラーが発生しました。画面をリロードしてください。"

  $scope.removeSubCategory = (project, category, sub_category) ->
    try
      SubCategory.get {project_id: project.id, category_id: category.id, id: sub_category.id} , (sc, getResponseHeaders) ->
        sc.$remove {project_id: project.id, category_id: category.id, id: sub_category.id }, (r, deleteResponse) ->
          idx = category.sub_categories.indexOf(sub_category)
          category.sub_categories.splice(idx, 1)
    catch error
      $window.alert "サーバーエラーが発生しました。画面をリロードしてください。"

  $scope.updateStoryName = (project, category, sub_category, story) ->
    try
      Story.get {project_id: project.id, category_id: category.id, sub_category_id: sub_category.id, id: story.id} , (s, getResponseHeaders) ->
        s.name = story.name
        s.$update {project_id: project.id, category_id: category.id, sub_category_id: sub_category.id, id: story.id }
    catch error
      $window.alert "サーバーエラーが発生しました。画面をリロードしてください。"

  $scope.removeStory = (project, category, sub_category, story) ->
    try
      Story.get {project_id: project.id, category_id: category.id, sub_category_id: sub_category.id, id: story.id} , (s, getResponseHeaders) ->
        s.$remove {project_id: project.id, category_id: category.id, sub_category_id: sub_category.id, id: story.id }, (result, deleteResponse) ->
          idx = sub_category.stories.indexOf(story)
          sub_category.stories.splice(idx, 1)
    catch error
      $window.alert "サーバーエラーが発生しました。画面をリロードしてください。"

  $scope.updatePoint = (project, category, sub_category, story, point, point_type) ->
    try
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
    catch error
      $window.alert "サーバーエラーが発生しました。画面をリロードしてください。"

  $scope.createCategory = (project) ->
    try
      category = new Category
      category.project_id = project.id
      category.name = "(新しい項目)"
      category.$save (c, postResponseHeaders) ->
        if project.categories
          project.categories.push c
        else
          project.categories = [ c ]
    catch error
      $window.alert "サーバーエラーが発生しました。画面をリロードしてください。"

  $scope.createSubCategory = (project, category) ->
    try
      subCategory = new SubCategory
      subCategory.project_id = project.id
      subCategory.category_id = category.id
      subCategory.name = "(新しい項目)"
      subCategory.$save (sc, postResponseHeaders) ->
        if category.sub_categories
          category.sub_categories.push sc
        else
          category.sub_categories = [ sc ]
    catch error
      $window.alert "サーバーエラーが発生しました。画面をリロードしてください。"

  $scope.createStory = (project, category, subCategory) ->
    try
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
    catch error
      $window.alert "サーバーエラーが発生しました。画面をリロードしてください。"

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
      point.point_50 * $scope.cachedRatio
    else
      null

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
    try
      resource = createMakeHigherLowerResource(true, project, category, sub_category, story)
      resource.$update (updated, postHeaders) ->
        if story
          moveHigher(sub_category.stories, story)
        else if sub_category
          moveHigher(category.sub_categories, sub_category)
        else
          moveHigher(project.categories, category)
    catch error
      $window.alert "サーバーエラーが発生しました。画面をリロードしてください。"

  $scope.moveLower = (project, category, sub_category, story) ->
    resource = createMakeHigherLowerResource(false, project, category, sub_category, story)
    try
      resource.$update (updated, postHeaders) ->
        if story
          moveLower(sub_category.stories, story)
        else if sub_category
          moveLower(category.sub_categories, sub_category)
        else
          moveLower(project.categories, category)
    catch error
      $window.alert "サーバーエラーが発生しました。画面をリロードしてください。"

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

  # for copy items
  $scope.copyItem = {
    errors: [],
    source: {},
    destination: {},
    modal: null,
    initialize: ->
      this.errors = []
      this.source = {}
      this.destination = {}
      this.modal = {}
    ,
    showModal: (project, category, subCategory, story) ->
      this.initialize()
      src = this.source
      src.project = project
      src.category = category
      src.subCategory = subCategory
      src.story = story
      dst = this.destination
      if story
        dst.name = "#{story.name} (コピー)"
      else if subCategory
        dst.name = "#{subCategory.name} (コピー)"
      else if category
        dst.name = "#{category.name} (コピー)"

      this.modal = $modal.open { templateUrl: 'item-copy-modal', scope: $scope }
    ,

    submitCopy: (success, fail) ->
      try
        src = this.source
        dst = this.destination
        if src.story
          if dst.subCategory
            fn = this.submitCopyStory.bind(this)
          else
            this.errors = ["コピー先の中項目を選んでください。"]
            return false
        else if src.subCategory
          if dst.category
            fn = this.submitCopySubCategory.bind(this)
          else
            this.errors = ["コピー先の大項目を選んでください。"]
            return false
        else if src.category
          fn = this.submitCopyCategory.bind(this)
        else
          this.errors = ["エラーが発生しました。"]
          return false

        fn(success, fail)
      catch error
        $window.alert "サーバーエラーが発生しました。画面をリロードしてください。"
    ,
    submitCopyStory: (success, fail) ->
      src = this.source
      dst = this.destination
      resource = new CopyStory
      resource.project_id = src.project.id
      resource.category_id = src.category.id
      resource.sub_category_id = src.subCategory.id
      resource.id = src.story.id
      resource.dst_item_form = { category_id: dst.category.id, sub_category_id: dst.subCategory.id, name: dst.name , type: 'story' }

      success_fn = success || this.defaultOnSuccessOfCopyFn.bind(this)
      fail_fn = fail || this.defaultOnErrorOfCopyFn.bind(this)

      resource.$save(success_fn, fail_fn)
    ,
    submitCopySubCategory: (success, fail) ->
      src = this.source
      dst = this.destination
      resource = new CopySubCategory
      resource.project_id = src.project.id
      resource.category_id = src.category.id
      resource.id = src.subCategory.id
      resource.dst_item_form = { category_id: dst.category.id, name: dst.name, type: 'sub_category' }

      success_fn = success || this.defaultOnSuccessOfCopyFn.bind(this)
      fail_fn = fail || this.defaultOnErrorOfCopyFn.bind(this)
      resource.$save(success_fn, fail_fn)
    ,
    submitCopyCategory: (success, fail) ->
      src = this.source
      dst = this.destination
      resource = new CopyCategory
      resource.project_id = src.project.id
      resource.id = src.category.id
      resource.dst_item_form = { name: dst.name, type: 'category' }

      success_fn = success || this.defaultOnSuccessOfCopyFn.bind(this)
      fail_fn = fail || this.defaultOnErrorOfCopyFn.bind(this)
      resource.$save(success_fn, fail_fn)
    ,
    defaultOnSuccessOfCopyFn: (result, postHeaders) ->
      $window.location.reload()
    ,
    defaultOnErrorOfCopyFn: (result, postHeader) ->
      if result.data
        this.errors = result.data
      else
        this.errors = ["サーバーエラーが発生しました。"]
  }

  $scope.remarksUpdater = {
    editingItem: null,
    origValue: null,
    project: null,
    category: null,
    subCategory: null,
    story: null,
    modal: null,
    errors: [],
    initialize: ->
      this.project = null
      this.editingItem = null
      this.origValue = null
      this.categoryId = null
      this.subCategoryId = null
      this.storyId = null
      this.errors = []
      this.modal = null
    ,
    showModal: (item, projectId, categoryId, subCategoryId, storyId) ->
      this.initialize()
      this.projectId = projectId
      this.categoryId = categoryId
      this.subCategoryId = subCategoryId
      this.storyId = storyId
      this.editingItem = item
      this.origValue = item.remarks

      this.modal = $modal.open { templateUrl: 'remarks-modal', scope: $scope }
    ,
    reset: ->
      this.editingItem.remarks = this.origValue
      true
    update: ->
      try
        if this.storyId
          prms = {project_id: this.projectId, category_id: this.categoryId, sub_category_id: this.subCategoryId, id: this.storyId}
          remarks = this.editingItem.remarks
          success_fn = this.defaultOnSuccessOfCopyFn.bind(this)
          fail_fn = this.defaultOnErrorOfCopyFn.bind(this)
          Story.get prms, (resource) ->
            resource.remarks = remarks
            resource.$update prms, success_fn, fail_fn
        else if this.subCategoryId
          prms = { project_id: this.projectId, category_id: this.categoryId, id: this.subCategoryId }
          remarks = this.editingItem.remarks
          success_fn = this.defaultOnSuccessOfCopyFn.bind(this)
          fail_fn = this.defaultOnErrorOfCopyFn.bind(this)
          SubCategory.get prms, (resource) ->
            resource.remarks = remarks
            resource.$update prms, success_fn, fail_fn
        else if this.categoryId
          prms = { project_id: this.projectId, id: this.categoryId }
          remarks = this.editingItem.remarks
          success_fn = this.defaultOnSuccessOfCopyFn.bind(this)
          fail_fn = this.defaultOnErrorOfCopyFn.bind(this)

          Category.get prms, (resource) ->
            resource.remarks = remarks
            resource.$update prms, success_fn, fail_fn
        else
          this.errors = ["エラーが発生しました。"]
      catch error
        $window.error "サーバーエラーが発生しました。画面をリロードしてください。"
    ,
    defaultOnSuccessOfCopyFn: (result, postHeaders) ->
      this.modal.close()
    ,
    defaultOnErrorOfCopyFn: (result, postHeader) ->
      if result.data
        this.errors = result.data
      else
        this.errors = ["サーバーエラーが発生しました。"]
  }
]

