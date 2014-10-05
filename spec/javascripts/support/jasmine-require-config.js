/* global require */

(function() {
  'use strict';

  require.config({
    baseUrl: '/assets',
    paths: {
      'jasmine':      '../__jasmine__/jasmine',
      'jasmine-html': '../__jasmine__/jasmine-html'
    },
    shim: {
      'jasmine': {
        "exports": 'jasmine'
      },
      'jasmine-html': {
        "deps": ['jasmine'],
        "exports": 'jasmine'
      }
    }
  });
})();
