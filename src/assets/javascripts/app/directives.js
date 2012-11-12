var directives = angular.module('sauron.directives', []);

directives.directive('timeago', [
  function() {
    return {
      require: 'ngModel',
      link: function(scope, elem, attrs, ctrl) {
        elem.timeago();

        scope.$watch(attrs.ngModel, function() {
          elem.timeago("refresh");
        });
      }
    }
  }
]);

directives.directive('timeline', [
  function() {
    return {
      require: 'ngModel',
      link: function($scope, elem, attrs, ctrl) {
        var config = $scope.$eval(attrs.timeline) || {};

        var context = cubism.context()
            .serverDelay(config.serverDelay || 0)
            .clientDelay(config.clientDelay || 0)
            .step(config.step || 1e3)
            .size(config.size || 960);

        var value = 0,
          values = [],
          i = 0,
          last;

        var data = context.metric(function(start, stop, step, callback) {
          start = +start, stop = +stop;
          if (isNaN(last)) last = start;
          while (last < stop) {
            last += step;
            value = ctrl.$modelValue || 0;
            values.push(value);
          }
          callback(null, values = values.slice((start - stop) / step));
        }, config.title || "");

        d3.select(elem.context).call(function(div) {

          div.append("div")
              .attr("class", "axis")
              .call(context.axis().orient("top"));

          div.selectAll(".horizon")
              .data([data])
            .enter().append("div")
              .attr("class", "horizon")
              .call(context.horizon()
                    .extent([-20, 20]));

          div.append("div")
              .attr("class", "rule")
              .call(context.rule());

        });
      }
    }
  }
]);