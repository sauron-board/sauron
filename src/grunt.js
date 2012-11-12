module.exports = function(grunt) {

  process.env.NODE_ENV = "development";

  // Project configuration.
  grunt.initConfig({
    pkg: '<json:package.json>',
    coffeelint: {
      app: ['app/*/*.coffee', 'config/*.coffee', 'config/*/*.coffee']
    },
    mochaTest: {
      unit: ['test/unit/**.test.coffee'],
      component: ['test/component/**.test.coffee'],
      integration: ['test/integration/**.test.coffee']
    },
    mochaTestConfig: {
      unit: {
        options: {
          reporter: 'spec',
          compilers: 'coffee:coffee-script'
        }
      },
      component: {
        options: {
          reporter: 'spec',
          compilers: 'coffee:coffee-script'
        }
      },
      integration: {
        options: {
          reporter: 'spec',
          compilers: 'coffee:coffee-script'
        }
      }
    },
    watch: {
      files: ['app/*/*.coffee', 'test/*/*.coffee'],
      tasks: 'test watch'
    }
  });

  grunt.loadNpmTasks('grunt-mocha-test');
  grunt.loadNpmTasks('grunt-coffeelint');

  // Default task.
  grunt.registerTask('default', 'test watch');

  grunt.registerTask('test', 'coffeelint mochaTest:unit mochaTest:component');

};