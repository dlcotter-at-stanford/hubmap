window.onload = function() {
  //// SAMPLES
  // Samples live at a global scope and are accessed by the various functions, some of which change them.
  // Right now they are JSON output by the server-side code, but now that the same data is also output as
  // SVG circles, it would make sense eventually to use JavaScript to get the sample data from the SVG
  // elements, rather than have the data output to the same page twice.

  // Calculate size, size category (small/medium/large), and distance from other samples for each sample
  for (let i=0; i<samples.length; i++) {
    samples[i].size = samples[i].length * samples[i].width * samples[i].depth;
    samples[i].size_cat = samples[i].size < 50 ? 'small' : samples[i].size < 100 ? 'medium' : 'large';
    samples[i].distance = [];
    for (let j=0; j<samples.length; j++) {
      samples[i].distance[j] = (function(a,b) {
        // two-dimensional distance function, i.e. Pythagorean formula
        return Math.sqrt( Math.pow((a.x - b.x), 2) + Math.pow((a.y - b.y), 2) );
      })(samples[i], samples[j]);
    }
  }

  // SELECTION LOGIC
  function setVisibility() {
    // Compare the attributes of the samples against the filtering criteria in the sidebar.
    // Logic that decides whether to draw or not draw sample.
    // Form: (... OR ... OR ...) AND (... OR ... OR ...) AND ... (... OR ... OR ...) AND ...
    // The reason for this logical form is that each sample should show up if
    // it matches any of the checkboxes within a group but only if each group
    // has at least one match
    for (let i=0; i<samples.length; i++) {
      samples[i].visible =
        // tissue type
        ( (samples[i].tissue_type.toLowerCase() === 'normal' && document.getElementById('tissue_type_normal').checked) ||
          (samples[i].tissue_type.toLowerCase() === 'polyp'  && document.getElementById('tissue_type_polyp').checked) ||
          (samples[i].tissue_type.toLowerCase() === 'adca'   && document.getElementById('tissue_type_adca').checked) )
        &&
        // size
        ( (samples[i].size_cat.toLowerCase() === 'small'  && document.getElementById('size_small').checked) ||
          (samples[i].size_cat.toLowerCase() === 'medium' && document.getElementById('size_medium').checked) ||
          (samples[i].size_cat.toLowerCase() === 'large'  && document.getElementById('size_large').checked) )
        &&
        // phenotype
        ( (samples[i].phenotype.toLowerCase() === 'normal'  && document.getElementById('phenotype_normal').checked) ||
          (samples[i].phenotype.toLowerCase() === 'sessile' && document.getElementById('phenotype_sessile').checked) ||
          (samples[i].phenotype.toLowerCase() === 'stalk'   && document.getElementById('phenotype_stalk').checked) )
        &&
        // location
        ( (samples[i].location.toLowerCase() === 'ascending'  && document.getElementById('location_ascending').checked) ||
          (samples[i].location.toLowerCase() === 'transverse' && document.getElementById('location_transverse').checked) ||
          (samples[i].location.toLowerCase() === 'descending' && document.getElementById('location_descending').checked) ||
          (samples[i].location.toLowerCase() === 'rectum'     && document.getElementById('location_rectum').checked) );
    }
  }

  function updateTable() {
    // Purpose  : Toggle each row's visibility depending on which filters are selected.
    // Structure: A three-level *for* loop
    // Workings : At the innermost level of the *for* loop, a decision is made whether to hide
    //            or show the current row by comparing the first cell in the row, which should
    //            always be the sample name, to the sample name in the "samples"
    //            object.
    // Notes    : * I have created 'table', 'row', and 'sample' variables to hold the current
    //            iteration's object at each level in the loop (rather than using potentially
    //            confusing array-indexing syntax). Unfortunately, JavaScript doesn't have a
    //            for-each construct like many other scripting languages, so I'm having to do
    //            it in a separate line.
    //            * Previously, I tried dynamically adding and removing rows by creating a row
    //            object, creating cell objects, appending them to the row object, and appending
    //            it to the table. I abandoned this approach because, aside from the complexity
    //            of the code required to do this, this approach has the significant downside of
    //            requiring the JavaScript code to add table columns in the same order as the tables
    //            themselves did originally; and since both the number and contents of the tables
    //            can be expected to change frequently during development, this would quickly
    //            become a maintenance headache.
    // Ideas    : Dynamically figure out which cell to look at for the sample name based on the
    //            column headers; 
    tables = document.querySelectorAll('footer table');
    for (let i=0; i<tables.length; i++) {
      table = tables[i];

      for (let j=0; j<table.rows.length; j++) {
        row = table.rows[j];

        if (row.cells.length === 0)
          continue;

        for (let k=0; k<samples.length; k++) {
          sample = samples[k];

          if (row.cells[0].innerHTML === sample.id /*(1)*/) { 
            row.style.display = sample.visible ? '' : 'none'; /*(2)*/
          }
        }
      }
    }
    // Footnotes:
    // (1) Resist the urge to combine this logical test with the one in the code to be executed, i.e.:
    //     row.style.display = row.cells[0].innerHTML === sample.id && sample.visible ? '' : 'none'
    //     I did this at first and couldn't understand why the entire table was being hidden.
    //     It's because for most samples and most rows, the first test will fail (and should), since
    //     there are N rows and N samples, thus N^2 comparisons, only one of which is a match. But
    //     by combining the two logical conditions in the variable assigment, you are acting on each
    //     row N^2 times and in almost every case hiding the row when you shouldn't be: not because
    //     the sample is hidden, but because the sample name in the row doesn't match the name of the
    //     sample in the current iteration of the loop. The one row that passes the first logical test
    //     will be hidden by subsequent comparisons to other samples that do not have a matching sample
    //     name. By moving the first logical condition into the *if* check, the row is only acted on once, when the matching sample
    //     is encountered. Forgive the long explanation, but it took a long time to reason this one out.
    // (2) Do not replace the empty string ('') with 'block'. It will cause the entire row to be inserted
    //     into the first cell of the table (for reasons I don't understand).
  }

  function updateImage() {
    for (let i=0; i<samples.length; i++) {
      var circle = document.createElement('circle');
      circle.setAttribute('id', samples[i].id);
      circle.setAttribute('tissue_type', samples[i].tissue_type);
      circle.setAttribute('phenotype', samples[i].phenotype);
      circle.setAttribute('location', samples[i].location);
      circle.setAttribute('length', samples[i].length);
      circle.setAttribute('width', samples[i].width);
      circle.setAttribute('depth', samples[i].depth);
      circle.setAttribute('cx', samples[i].x);
      circle.setAttribute('cy', samples[i].y);
      circle.setAttribute('r', (samples[i].length * samples[i].width * samples[i].depth) ** (1/3) );
      circle.setAttribute('fill', 'gray');

      // Set the text of the pop-up helper that appears when hovering over a
      // sample (through the "title" attribute of the circle element)
      var title = document.createElement('title');
      title.innerHTML = `${ samples[i].id } \n(${ samples[i].x }, ${ samples[i].y }) \n${ samples[i].length } x ${ samples[i].width } x ${ samples[i].depth } (${ (samples[i].length * samples[i].width * samples[i].depth) } mm³) \n${ samples[i].tissue_type }, ${ samples[i].phenotype }, ${ samples[i].location }`;

      circle.appendChild(title);
      viz.appendChild(circle);
    }

    circles = document.querySelectorAll('svg#viz circle');
    for (let i=0; i<samples.length; i++) {
      circles[i].style.display = samples[i].visible ? 'inline' : 'none';
    }

    document.getElementById('viz-wrapper').innerHTML += ""; // refresh
  }

  function drawDistance(sample_id) {
    viz = document.getElementById('viz');
    for (let i=0; i<samples.length; i++) {
      if (samples[i].id !== sample_id) {
        continue;
      }

      distance_lines = viz.querySelectorAll('line.distance_line');
      for (let j=0; j<distance_lines.length; j++) {
        viz.removeChild(distance_lines[j]);
      }

      for (let j=0; j<samples.length; j++) {
        if (!samples[j].visible) {
          continue;
        }

        line = document.createElementNS('http://www.w3.org/2000/svg', 'line');
        line.classList.add('distance_line');
        line.setAttribute('x1', samples[i].x);
        line.setAttribute('y1', samples[i].y);
        line.setAttribute('x2', samples[j].x);
        line.setAttribute('y2', samples[j].y);
        line.style = 'stroke:gray; stroke-dasharray: 2; stroke-width:2';
        viz.appendChild(line);

        title = document.createElementNS('http://www.w3.org/2000/svg', 'title');
        title.innerHTML = ( Number(samples[i].distance[j]) / 108.0 ).toFixed(1) + ' cm'; //108 is A014's colon length
        line.appendChild(title);
      }
    }
  }

  function highlightRow(sample_id) {
    // Highlight the row in the table corresponding to sample and reset all other rows to default style
    table_rows = document.querySelectorAll('table tr');
    for (let j=0; j<table_rows.length; j++) {
      // Highlight row corresponding to sample
      table_rows[j].className = table_rows[j].children[0].innerHTML === sample_id ? 'highlighted' : '';
    }
  }
  
  function downloadCSV(table_id) {
    // Purpose: Push a comma-separated value file containing the currently selected rows of the table
    //          to the user
    csv_line_array = Array();

    table = document.getElementById(table_id); // style = display:''
    for (let i=0; i<table.rows.length; i++) {
      cell_array = Array();
      if (table.rows[i].style.display === 'none') {
        continue;
      }

      for (let j=0; j<table.rows[i].cells.length; j++) {
        cell_array.push(table.rows[i].cells[j].innerHTML);
      }
      line = cell_array.join(',');
      csv_line_array.push(line);
    }
    csv_text = csv_line_array.join('\n');

    var element = document.createElement('a');
    element.setAttribute('href', 'data:text/plain;charset=utf-8,' + encodeURIComponent(csv_text));
    element.setAttribute('download', 'clinical.csv');
    element.style.display = 'none';
    document.body.appendChild(element);
    element.click();
    document.body.removeChild(element);
  }

  function attachEvents() {
    pins = document.querySelectorAll('svg#viz circle');
    for (let i=0; i<pins.length; i++) {
      pins[i].addEventListener('mouseover', (function(id) {
        return function(e) {
          drawDistance(id);
        };
      })(pins[i].getAttribute('id'))); /*(1)*/

      pins[i].addEventListener('mouseover', (function(id) {
        return function(e) {
          highlightRow(id);
        };
      })(pins[i].getAttribute('id'))); /*(1)*/

      // (1) Both these event listeners use a combination of an "immediately invoked function
      //     expression" (i.e. an IIFE, i.e. an "iffy") and a closure to return an anonymous
      //     function that captures the id of the element that caused it to be called. This is
      //     important because the the event object passed to the handling function does not
      //     contain any information about the object that caused it to fire; thus if we did not
      //     bundle this information in the function assigned to the event, the function would have
      //     have no way of knowing which element it should (in this case) highlight.
    }

    checkboxes = document.querySelectorAll('input[type="checkbox"]');
    for (let i=0; i<checkboxes.length; i++) {
      checkboxes[i].addEventListener('click', setVisibility);
      checkboxes[i].addEventListener('click', updateImage);
      checkboxes[i].addEventListener('click', updateTable);
      checkboxes[i].addEventListener('click', drawDistance);
    }

    csv_links = document.querySelectorAll('footer .tab label a.download-link');
    for (let i=0; i<csv_links.length; i++) {
      csv_links[i].addEventListener('click', (function(id) {
        return function(e) {
          downloadCSV(id);
        };
      })(csv_links[i].getAttribute('table_id')));
    }
  }

  function drawRulers() {
    /* Assumptions: the average colon is 1.5m (~5ft) long; our viewport is
       1500px wide; therefore, the conversion ratio between centimeters and
       pixels should be 1500px/150cm or 10px/cm. */
    viz = document.getElementById('viz');

    var frame_width = 1500;
    var frame_height = 400;
    var conversion_factor = 10;  // 10 pixels per centimeter
    var horizontal_offset = 20;
    var vertical_offset = 20;

    // Draw horizontal ruler
    line = document.createElementNS('http://www.w3.org/2000/svg', 'line');
    line.classList.add('ruler_line');
    line.setAttribute('x1', horizontal_offset);
    line.setAttribute('y1', frame_height - vertical_offset);
    line.setAttribute('x2', frame_width);
    line.setAttribute('y2', frame_height - vertical_offset);
    line.style = 'stroke:gray; stroke-width:1';
    viz.appendChild(line);

    for (let cm=1; cm < frame_width/conversion_factor; cm++) {
      // Draw horizontal tick marks (the tertiary formula makes every tenth line
      // twice as big and every hundredth line three times as big)
      line = document.createElementNS('http://www.w3.org/2000/svg', 'line');
      line.classList.add('ruler_line');
      line.setAttribute('x1', horizontal_offset + cm * conversion_factor);
      line.setAttribute('y1', frame_height - vertical_offset);
      line.setAttribute('x2', horizontal_offset + cm * conversion_factor);
      line.setAttribute('y2', (frame_height - vertical_offset) -
                              (cm % 100 == 0 ? 3 * conversion_factor :
                               cm % 10 == 0 ? 2 * conversion_factor :
                               cm % 5 == 0 ? 1.5 * conversion_factor :
                               conversion_factor));
      line.style = 'stroke:gray; stroke-width:1';
      viz.appendChild(line);

      // Draw distance labels
      if (cm % conversion_factor == 0) {
        text = document.createElementNS('http://www.w3.org/2000/svg', 'text');
        text.setAttribute('x', horizontal_offset + cm * conversion_factor - 7);  // -7 pixels helps center the text
        text.setAttribute('y', frame_height - 2);  // slightly away from bottom of frame
        text.style = 'font-size:small';
        text.innerHTML = cm;
        viz.appendChild(text);
      }
    }

    // Draw vertical ruler
    line = document.createElementNS('http://www.w3.org/2000/svg', 'line');
    line.classList.add('ruler_line');
    line.setAttribute('x1', horizontal_offset);
    line.setAttribute('y1', frame_height - vertical_offset);
    line.setAttribute('x2', horizontal_offset);
    line.setAttribute('y2', 0);
    line.style = 'stroke:gray; stroke-width:1';
    viz.appendChild(line);

    // Draw vertical tick marks
    for (let cm=1; cm < frame_width / conversion_factor; cm++) {
      line = document.createElementNS('http://www.w3.org/2000/svg', 'line');
      line.classList.add('ruler_line');
      line.setAttribute('x1', horizontal_offset);
      line.setAttribute('y1', frame_height - vertical_offset - cm * conversion_factor);
      line.setAttribute('x2', horizontal_offset +
                              (cm % 100 == 0 ? 3 * conversion_factor :
                               cm % 10 == 0 ? 2 * conversion_factor :
                               cm % 5 == 0 ? 1.5 * conversion_factor :
                               conversion_factor));
      line.setAttribute('y2', frame_height - vertical_offset - cm * conversion_factor);
      line.style = 'stroke:gray; stroke-width:1';
      viz.appendChild(line);

      // Draw distance labels
      if (cm % conversion_factor == 0) {
        text = document.createElementNS('http://www.w3.org/2000/svg', 'text');
        text.setAttribute('x', 2);  // slightly offset from frame
        text.setAttribute('y', frame_height - vertical_offset - cm * conversion_factor + 5);
        text.style = 'font-size:small';
        text.innerHTML = cm;
        viz.appendChild(text);
      }
    }
  }

  // PAGE LOAD
  setVisibility();
  updateImage();
  updateTable();
  attachEvents();
  drawRulers();
};
