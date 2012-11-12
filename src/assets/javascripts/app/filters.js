var filters = angular.module('sauron.filters', []);

filters.filter("massageEmail", function() {
  var isEmail = /\S+@\S+\.\S+/
  return function(text) {
    if (isEmail.test(text)) {
      return "mailto:"+text;
    }
    else {
      return text;
    }
  };
});

filters.filter("toDate", function() {
  return function(text) {
    try {
      return (new Date(text)).toISOString();
    }
    catch(e) {
      return text;
    }
  };
});

filters.filter("isValidDate", function() {
  return function(text) {
    try {
      (new Date(text)).toISOString()
      return true;
    }
    catch(e) {
      return false;
    }
  };
});

filters.filter("tablePlugins", function() {
  return function(plugins) {
    if(!plugins) return [];
    return _.filter(plugins, function(plugin) {
      if(!plugin && !plugin._link) return false;
      var render = plugin._link.render;

      return render === "table" || !render;
    });
  };
});

filters.filter("timelinePlugins", function() {
  return function(plugins) {
    if(!plugins) return [];
    return _.filter(plugins, function(plugin) {
      if(!plugin && !plugin._link) return false;
      var render = plugin._link.render;

      return render === "timeline";
    });
  };
});
