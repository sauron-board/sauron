
var controllers = angular.module('sauron.controllers', []);

var IndexController = [
  "collection-json",
  '$scope',
  '$rootScope',

  function(cj, $scope, $rootScope){
    $rootScope.theme = $.cookie('sauron-theme') || "lothlorien";

    $rootScope.$watch("theme", function() {
      $.cookie('sauron-theme', $rootScope.theme);
    });

    var socket = io.connect(window.location);
    socket.on('publish', _.debounce(function (data) {
      var coll = _.find($scope.pluginList, function(plugin) {
        return plugin.rel === data.rel;
      });
      cj(coll.href, function(err, newCol) {
        $scope.plugins[coll.rel] = newCol;
        $scope.pluginTemplates[coll.rel] = newCol.template()._template;
      });
    }, 300));

    $scope.plugins = {};
    $scope.pluginTemplates = {};

    cj(window.location+"api", function(error, collection) {
      $scope.pluginList = collection.links;

      _.each(collection.links, function(link) {
        link.follow(function(error, pluginCollection) {
          if(error) return console.error(error);
          $scope.plugins[link.rel] = pluginCollection;
          $scope.pluginTemplates[link.rel] = pluginCollection.template()._template;
        });
      });

    });
  }
];

controllers.controller('IndexController', IndexController);
