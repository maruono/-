angular.module 'starter', [
  'ionic'
  'starter.controllers'
  'starter.services'
]

.run ($ionicPlatform) ->
  $ionicPlatform.ready ->
    if window.cordova and window.cordova.plugins and window.cordova.plugins.Keyboard
      cordova.plugins.Keyboard.hideKeyboardAccessoryBar true
      cordova.plugins.Keyboard.disableScroll true
    if window.StatusBar
      StatusBar.styleDefault()
    return
  return

.config ($stateProvider, $urlRouterProvider) ->
  $stateProvider
    .state('tab',
    url: '/tab'
    abstract: true
    templateUrl: 'templates/tabs.html')
    
    .state('tab.test',
    url: '/test'
    views: 'test':
      templateUrl: 'templates/test.html'
      controller: 'TestCtrl')
      
    .state('tab.dash',
    url: '/dash'
    views: 'tab-dash':
      templateUrl: 'templates/tab-dash.html'
      controller: 'DashCtrl')
    
    .state('tab.chats',
    url: '/chats'
    views: 'tab-chats':
      templateUrl: 'templates/tab-chats.html'
      controller: 'ChatsCtrl')
    
    .state 'tab.account',
    url: '/account'
    views: 'tab-account':
      templateUrl: 'templates/tab-account.html'
      controller: 'AccountCtrl'
    
  $urlRouterProvider.otherwise '/tab/account'
  return
