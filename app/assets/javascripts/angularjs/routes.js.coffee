angular.module("mitsumottaroApp").config ["$routeProvider", ($routeProvider) ->
 $routeProvider.
   when '/projects/:id', {
     controller: 'ProjectsController'
     templateUrl: '/assets/dashboard.html'
   }
]
