angular.module("mitsumottaroApp").config ["$routeProvider", ($routeProvider) ->
 $routeProvider.
   when '/projects/:id/dashboard', {
     controller: 'DashboardController'
     templateUrl: '/assets/dashboard.html'
   }
]
