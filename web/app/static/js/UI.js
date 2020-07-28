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
  _public.UI = {
    XMLNS: "http://www.w3.org/2000/svg",

    refresh: function () {
      document.getElementById('viz-wrapper').innerHTML += "";
    },
  
    setVisibility: function () {
      // Compare the attributes of the samples against the filtering criteria in
      // the sidebar. Logic that decides whether to draw or not draw sample.
      // Form: (... OR ... OR ...) AND (... OR ... OR ...) AND ...
      // The reason for this logical form is that each sample should show up if
      // it matches any of the checkboxes within a group but only if each group
      // has at least one match
      APP.Domain.samples.forEach(
        function (sample) {
          var checked = { };
          var checkbox_ids = 
            [ "tissue_type_normal", "tissue_type_polyp", "tissue_type_adca",
              "size_small", "size_medium", "size_large",
              "phenotype_sessile", "phenotype_stalk",
              "location_ascending", "location_transverse", "location_descending", "location_rectum"
            ];
          checkbox_ids.forEach( function(checkbox_id) {
            checked[checkbox_id] = document.getElementById(checkbox_id).checked;
          });

          sample.visible =
            // tissue type
            ( (sample.tissue_type === "normal" && checked["tissue_type_normal"])
               ||
              (sample.tissue_type === "polyp"  && checked["tissue_type_polyp"])
               ||
              (sample.tissue_type === "adca"   && checked["tissue_type_adca"]) )
            &&
            // size
            ( (sample.size_cat === "small"  && checked["size_small"])
               ||
              (sample.size_cat === "medium" && checked["size_medium"])
               ||
              (sample.size_cat === "large"  && checked["size_large"]) )
            &&
            // phenotype
            ( (sample.phenotype === "sessile" && checked["phenotype_sessile"])
               ||
              (sample.phenotype === "stalk"   && checked["phenotype_stalk"])
               ||
              (sample.phenotype === "none")
               ||
              (sample.phenotype === "normal") )
            &&
            // location
            ( (sample.location === "ascending"  && checked["location_ascending"])
               ||
              (sample.location === "transverse" && checked["location_transverse"])
               ||
              (sample.location === "descending" && checked["location_descending"])
               ||
              (sample.location === "rectum"     && checked["location_rectum"]) );
        }
      );
    },

    Viz: function (spec) {
      // Public fields & methods
      spec.element = document.getElementById(spec.elementID);

      var clearDistanceLines = function () {
        var distance_lines = spec.element.querySelectorAll('line.distance_line');
        distance_lines.forEach( line => spec.element.removeChild(line) );
      };
      spec.clearDistanceLines = clearDistanceLines;

      var update = function () {
        APP.UI.pins.forEach( function (pin, i) {
          // This implicitly counts on samples and pins matching by order,
          // i.e. pin[n] represents sample[n].
          if (APP.Domain.samples[i].visible) {
            pin.show();
          } else {
            pin.hide();
          }
        });
      };
      spec.update = update;

      return spec;
    },

    Pin: function (subject, sample) {
      // Imports & aliases
      var UI = APP.UI;
      var viz = APP.UI.Viz;

      // Create the return object
      var pin = { };
      pin.id = sample.id;
      pin.cx = viz.horizontal_offset + (subject.colon_length - sample.x) * viz.conversion_factor;
      pin.cy = viz.vertical_offset + sample.y * viz.conversion_factor;
      pin.r = Math.log( sample.length * sample.width  * sample.depth );
      pin.fill = 'gray';
      pin.title = `${ sample.id } \n(${ sample.x }, ${ sample.y }) \n${ sample.length } x ${ sample.width } x ${ sample.depth } (${ (sample.length * sample.width * sample.depth) } mm³) \n${ sample.tissue_type }, ${ sample.phenotype }, ${ sample.location }`;
      pin.distances = [ ];
      sample['distances'].forEach(function (d, i) {
        pin.distances[i] = d * viz.conversion_factor;
      });

      // Create DOM element & set attributes
      var circle = document.createElementNS(UI.XMLNS, 'circle');
      circle.setAttributeNS(UI.XMLNS, 'id',    pin.id);
      circle.setAttributeNS(UI.XMLNS, 'cx',    pin.cx);
      circle.setAttributeNS(UI.XMLNS, 'cy',    pin.cy);
      circle.setAttributeNS(UI.XMLNS, 'r',     pin.r);
      circle.setAttributeNS(UI.XMLNS, 'fill',  pin.fill);
      circle.setAttributeNS(UI.XMLNS, 'title', pin.title);

      // Set the text of the pop-up helper that appears when hovering over a
      // sample (through the "title" attribute of the circle element)
      var title = document.createElementNS(UI.XMLNS, 'title');
      title.innerHTML = pin.title;
      circle.appendChild(title);
      viz.element.appendChild(circle);
      pin.element = circle;

      var hide = function () {
        document.getElementById(pin.id).style.display = "none";
      };
      pin.hide = hide;

      var show = function () {
        document.getElementById(pin.id).style.display = "inline";
      };
      pin.show = show;

      var drawDistanceLines = function () {
        var subject = APP.Domain.subject;

        // Erase already visible distance lines, if any
        viz.clearDistanceLines();

        // Only draw lines to pins that are currently visible
        if (!UI.pins)
          return;

        APP.UI.pins.forEach(function (p, i) {
          // This implicitly counts on samples and pins matching by order, i.e.
          // pin[n] represents sample[n]
          if (!APP.Domain.samples[i].visible)
            return;

          var line = document.createElementNS(UI.XMLNS, 'line');
          line.classList.add('distance_line');
          line.setAttribute('x1', pin.cx);
          line.setAttribute('y1', pin.cy);
          line.setAttribute('x2', p.cx  );
          line.setAttribute('y2', p.cy  );
          line.style = 'stroke:gray; stroke-dasharray: 2; stroke-width:2';
          viz.element.appendChild(line);

          var title = document.createElementNS(UI.XMLNS, 'title');
          title.innerHTML = ( Number(pin.distances[i]) / subject.colon_length).toFixed(1) + ' cm';
          line.appendChild(title);
        });
      };
      pin.drawDistanceLines = drawDistanceLines;

      return pin;
    },

    Section: function (section) {
      // Imports & aliases
      var viz = APP.UI.Viz;
      if (!section.position)
        return section;

      // 2020-07-22 Wed 10:43 AM - The horizontal positions of the different
      // sections are in reverse order in the database, hence the subtraction
      // from the colon length to invert their position on the graphic. Once
      // they're fixed, this code will be a bit simpler.
      section.x1 = viz.horizontal_offset + (APP.Domain.subject.colon_length - section.position) * viz.conversion_factor;
      section.y1 = viz.vertical_offset;
      section.x2 = section.x1;
      section.y2 = viz.frame_height;

      var line = document.createElement('line');
      line.setAttribute('x1', section.x1)
      line.setAttribute('y1', section.y1);
      line.setAttribute('x2', section.x2);
      line.setAttribute('y2', section.y2);
      line.style = 'stroke:gray; stroke-dasharray: 2; stroke-width:2';
      viz.element.appendChild(line);

      return section;
    },

    SectionLabel: function (label) {
      // Imports & aliases
      var viz = APP.UI.Viz;

      if (!label.position)
        return label;

      // 2020-07-22 Wed 10:43 AM - The horizontal positions of the different
      // sections are in reverse order in the database, hence the subtraction
      // from the colon length to invert the position of their labels on the
      // graphic. Once they're fixed, this code will be a bit simpler.
      label.x = viz.horizontal_offset + 4 + (APP.Domain.subject.colon_length - label.position) * viz.conversion_factor;
      label.y = viz.frame_height - 4;

      var textElement = document.createElementNS(APP.UI.XMLNS, 'text');
      textElement.setAttribute('x', label.x);
      textElement.setAttribute('y', label.y);
      textElement.innerHTML = label.name;
      textElement.style = 'font-size: small';
      viz.element.appendChild(textElement);

      return label;
    },

    HorizontalRuler: function (spec) {
      // 2020-07-21 Tue 11:00 PM - rulers, tick marks, and labels can be moved
      // under a <g> group in SVG and shown/hidden as a group

      // Imports & aliases
      var UI = APP.UI;
      var viz = APP.UI.Viz;

      var rule = document.createElementNS(UI.XMLNS, 'line');
      rule.setAttribute("x1", viz.horizontal_offset);
      rule.setAttribute("y1", viz.vertical_offset);
      rule.setAttribute("x2", viz.frame_width);
      rule.setAttribute("y2", viz.vertical_offset);
      rule.style = 'stroke:gray; stroke-width:1';
      viz.element.appendChild(rule);

      for (let cm=1; cm < viz.frame_width / viz.conversion_factor; cm++) {
        // The tertiary formula makes every tenth line twice as big and every
        // hundredth line three times as big)
        var tick = document.createElementNS(UI.XMLNS, 'line');
        tick.setAttribute("x1", viz.horizontal_offset + cm * viz.conversion_factor);
        tick.setAttribute("y1", viz.vertical_offset);
        tick.setAttribute("x2", viz.horizontal_offset + cm * viz.conversion_factor);
        tick.setAttribute("y2", viz.vertical_offset +
                                (cm % 100 == 0 ? 3.0 * viz.conversion_factor :
                                 cm % 10 == 0  ? 2.0 * viz.conversion_factor :
                                 cm % 5 == 0   ? 1.5 * viz.conversion_factor :
                                                       viz.conversion_factor));
        tick.style = 'stroke:gray; stroke-width:1';
        viz.element.appendChild(tick);

        // Draw distance labels
        if (cm % viz.conversion_factor === 0) {
          var text = document.createElementNS(UI.XMLNS, 'text');
          text.setAttribute("x", viz.horizontal_offset + cm * viz.conversion_factor - 7);
          text.setAttribute("y", viz.vertical_offset - 5);
          text.style = 'font-size:small';
          text.innerHTML = cm;
          viz.element.appendChild(text);
        }
      }
    },

    VerticalRuler: function () {
      // Imports & aliases
      var UI = APP.UI;
      var viz = APP.UI.Viz;

      var rule = document.createElementNS(UI.XMLNS, 'line');
      rule.setAttribute("x1", viz.horizontal_offset);
      rule.setAttribute("y1", viz.vertical_offset);
      rule.setAttribute("x2", viz.horizontal_offset);
      rule.setAttribute("y2", viz.frame_height);
      rule.style = 'stroke:gray; stroke-width:1';
      viz.element.appendChild(rule);

      for (let cm=1; cm < viz.frame_width / viz.conversion_factor; cm++) {
        // The tertiary formula makes every tenth line twice as big and every
        // hundredth line three times as big)
        var tick = document.createElementNS(UI.XMLNS, 'line');
        tick.setAttribute("x1", viz.horizontal_offset);
        tick.setAttribute("y1", viz.vertical_offset + cm * viz.conversion_factor);
        tick.setAttribute("x2", viz.horizontal_offset +
                                (cm % 100 == 0 ? 3 * viz.conversion_factor :
                                 cm % 10 == 0 ? 2  * viz.conversion_factor :
                                 cm % 5 == 0 ? 1.5 * viz.conversion_factor :
                                                     viz.conversion_factor));
        tick.setAttribute("y2", viz.vertical_offset + cm * viz.conversion_factor);
        tick.style = "stroke:gray; stroke-width:1";
        viz.element.appendChild(tick);

        // Draw distance labels
        if (cm % viz.conversion_factor === 0) {
          var text = document.createElementNS(UI.XMLNS, 'text');
          text.setAttribute("x", 2);  // slightly offset from frame
          text.setAttribute("y", viz.vertical_offset + cm * viz.conversion_factor + 5);
          text.style = 'font-size:small';
          text.innerHTML = cm;
          viz.element.appendChild(text);
        }
      }
    },

    Table: function (tableElement) {
      // Return variable
      var table = {
        element: tableElement
      };

      var update = function () {
        // Toggle each row's visibility depending on which filters are selected.
        // Initially tried dynamically adding and removing rows - too complex
        // and error-prone; easier just to hide & show them as needed.
        for (var row of table.element.rows)
          if (row.cells.length)
            for (var sample of APP.Domain.samples)
              if (row.cells[0].innerHTML === sample.id) // (1)
                row.style.display = sample.visible ? "" : "none"; // (2)
        // Footnotes:
        // (1) Resist the urge to combine this logical test with the one in the
        //     code to be executed, i.e.:
        //     row.style.display = row.cells[0].innerHTML === sample.id && sample.visible ? '' : 'none'
        //     I did this at first and couldn't understand why the entire table was being hidden.
        //     It's because for most samples and most rows, the first test will fail (and should), since
        //     there are N rows and N samples, thus N^2 comparisons, only one of which is a match. But
        //     by combining the two logical conditions in the variable assigment, you are acting on each
        //     row N^2 times and in almost every case hiding the row when you shouldn't be, not because
        //     the sample is hidden, but because the sample name in the row doesn't match the name of the
        //     sample in the current iteration of the loop. The one row that passes the first logical test
        //     will be hidden by subsequent comparisons to other samples that do not have a matching sample
        //     name. By moving the first logical condition into the *if* check, the row is only acted on once, when the matching sample
        //     is encountered.
        // (2) Do not replace the empty string ('') with 'block'. It will cause the entire row to be inserted
        //     into the first cell of the table (for reasons I don't understand).
      };
      table.update = update;

      var highlightRows = function (sample_id) {
        var rows = table.element.querySelectorAll("table tr");
        rows.forEach( row => row.className = row.children[0].innerHTML === sample_id ? "highlighted" : "");
      };
      table.highlightRows = highlightRows;

      var download = function () {
        var line_array = [], text;

        for (let row of table.element.rows) {
          let cell_array = [];

          if (row.style.display === "none")
            continue;

          for (let cell of row.cells)
            cell_array.push(cell.innerHTML);

          let line = cell_array.join(',');
          line_array.push(line);
        }
        text = line_array.join('\n');

        var a = document.createElement('a');
        a.setAttribute('href', 'data:text/plain;charset=utf-8,' + encodeURIComponent(text));
        a.setAttribute('download', APP.Domain.subject.id + "-" + table.element.getAttribute("content") + '.csv');
        a.style.display = 'none';
        document.body.appendChild(a);
        a.click();
        document.body.removeChild(a);
      };
      table.download = download;

      return table;
    
    }
  };

  return _public;
})(APP || { });

