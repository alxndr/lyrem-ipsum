/* global console, require, describe, it, expect */

console.log("spec file");
require([
  'views/form_view',
  'jasmine'
], function(FormView, jasmine) {

  console.log("test suite running", jasmine);

  describe("FormView", function() {
    console.log("in describe");

    it("should exist", function() {
      console.log("in it");
      expect(FormView).toBeDefined();
    });

  });

});
