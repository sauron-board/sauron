'use strict';

// Declare app level module which depends on filters, and services
var deps = [
  'ui',
  'collection-json',
  'sauron.services',
  'sauron.directives',
  'sauron.filters',
  'sauron.controllers'
];

var app = angular.module('sauron', deps);
