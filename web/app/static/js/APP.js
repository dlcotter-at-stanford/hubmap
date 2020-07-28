/*jshint esversion: 7 */
'use strict';

/*
  Naming Conventions
  - ALLCAPS: modules, constants
  - PascalCase: namespaces, constructors, singletons
  - camelCase: instances, fields
  - _underscored: reserved keywords

  App is the top-level namespace for everything else. It is designed as a
  singleton, meaning the "class" App and the object App are identical and
  unique. The structure of the code that builds the APP object is important:
    var APP = ... --> declaration & assignment
    (function (_public) { ... } )() --> immediately-invoked function expression
    (APP || { }) --> passing itself (or an empty object) to itself as parameter
  The combination of the declaration & assignment to APP and the passing of
  APP as a parameter to a function whose result will be assigned to APP
  serve to export and import, respectively, the variable APP, thus augmenting
  a single global variable that contains all of the application logic. The
  immediately-invoked function expression (IIFE) returns a function that
  captures in a closure the private variables of the application logic. The
  returned variable is the public interface to the app.
*/

var APP = (function (_public) {
  _public.Utils = {
    checkForField: function (spec, field) {
      if (spec[field] === undefined) {
        throw {
          name: "MissingFieldError",
          message: "Object must include '" + field + "' field"
        };
      }
    }
  };

  return _public;
})(APP || { });

