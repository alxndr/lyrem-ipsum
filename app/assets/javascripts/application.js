/* global window, require */

require([
  'jquery',
  'views/form_view'
], function($, FormView) {

  window.form_view = new FormView();
  window.form_view.render();

});
