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

  {% if subjects %}
    var APP = (function (_public) {
      return {
        Domain: {
        {% for subject in subjects["data"] %}
          {% if subject.subject_bk == subject_id %}
            subject: {
              id            : "{{ subject.subject_bk }}",
              disease_status: "{{ subject.disease_status }}",
              colon_length  : {{ subject.colon_length        if subject.colon_length        else "undefined" }},
              sections      : [ { name: "rectum"    , position: {{ subject.rectum_position     if subject.rectum_position     else "undefined" }} },
                                { name: "descending", position: {{ subject.descending_position if subject.descending_position else "undefined" }} },
                                { name: "transverse", position: {{ subject.transverse_position if subject.transverse_position else "undefined" }} },
                                { name: "ascending" , position: {{ subject.ascending_position  if subject.ascending_position  else "undefined" }} } ]
            },
          {% endif %}
        {% endfor %}

          {% if tables and tables["clinical"] %}
            samples: [
              {% for sample in tables["clinical"]["data"] %}
                { id          : "{{ sample.sample_bk }}",
                  length      : {{ sample.size_length if sample.size_length else "undefined" }},
                  width       : {{ sample.size_width  if sample.size_width  else "undefined" }},
                  depth       : {{ sample.size_depth  if sample.size_depth  else "undefined" }},
                  x           : {{ sample.x_coord }},
                  y           : {{ sample.y_coord }},
                  tissue_type : "{{ sample.stage.lower() if sample.stage else 'none' }}",
                  phenotype   : "{{ sample.phenotype.lower() if sample.phenotype else 'none' }}",
                  location    : "{{ sample.organ_piece.lower() if sample.organ_piece else 'none' }}",
                  atacseq_bulk: {{ "true" if sample.bulk_atac else "false" }},
                  atacseq_sn  : {{ "true" if sample.sn_atac_seq else "false" }},
                  lipidomics  : {{ "true" if sample.lipidomics else "false" }},
                  metabolomics: {{ "true" if sample.metabolomics else "false" }},
                  proteomics  : {{ "true" if sample.proteomics else "false" }},
                  rnaseq_bulk : {{ "true" if sample.rna_seq else "false" }},
                  rnaseq_sn   : {{ "true" if sample.sn_rna_seq else "false" }},
                  wgs         : {{ "true" if sample.dna_wes else "false" }} },
              {% endfor %}
            ]
          {% endif %}
        }
      }
    })(APP || { });
  {% endif %}

  // Imports & aliases
  var domain = APP.Domain;

  // Private variables & functions (not inherited)
  var distance = function pythagorean (s, t) {
    return Math.sqrt( (s.x - t.x) ** 2 + (s.y - t.y) ** 2);
  };

  // Public variables
  // Enrich raw sample data with some calculated fields
  domain.samples.forEach(function (s) {
    s.size = (s.length || 1) * (s.width || 1) * (s.depth || 1);
    s.size_cat = s.size < 50 ? "small" : s.size < 100 ? "medium" : "large";
    s.distances = [ ];
    domain.samples.forEach(function (t, i) {
      s.distances[i] = distance(s, t);
    });
  });

