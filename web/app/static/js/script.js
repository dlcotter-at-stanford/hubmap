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
  function filterSamples() {
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
    // Start by clearing all rows
    table_rows = document.querySelectorAll('#info > tr');
    for (let i=0; i<table_rows.length; i++) {
      table_rows[i].remove();
    }

    // Populate a fresh row for each sample
    for (let i=0; i<samples.length; i++) {
      // If a sample is already hidden from view, skip to the next one
      if (!samples[i].visible) continue;

      // Build the table from an array of attributes by appending first from cell (td) to row (tr) to table (table)
      table = document.getElementById('info');
      tr = document.createElement('tr');
      attrs = [ samples[i].id, samples[i].tissue_type, samples[i].size, samples[i].size_cat, samples[i].phenotype, samples[i].location ];
      for (let j=0; j<attrs.length; j++) {
        td = document.createElement('td');
        td.innerHTML = attrs[j];
        tr.appendChild(td);
      }
      table.appendChild(tr);
    }
  }

  function updateImage() {
    pins = document.querySelectorAll('svg#viz circle');
    for (let i=0; i<pins.length; i++) {
      pins[i].style.display = samples[i].visible ? 'inline' : 'none';
    }
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
    table_rows = document.querySelectorAll('#info > tr');
    for (let j=0; j<table_rows.length; j++) {
      // Highlight row corresponding to sample
      table_rows[j].className = table_rows[j].children[0].innerHTML === sample_id ? 'highlighted' : '';
    }
  }
  
  // EVENT HANDLING
  pins = document.querySelectorAll('svg#viz circle');
  for (let i=0; i<pins.length; i++) {
    pins[i].addEventListener('mouseover', (function(id) {
      return function(e) {
        drawDistance(id);
      };
    })(pins[i].getAttribute('id')));

    pins[i].addEventListener('mouseover', (function(id) {
      return function(e) {
        highlightRow(id);
      };
    })(pins[i].getAttribute('id')));
  }

  checkboxes = document.querySelectorAll('input[type="checkbox"]');
  for (let i=0; i<checkboxes.length; i++) {
    checkboxes[i].addEventListener('click', filterSamples);
    checkboxes[i].addEventListener('click', updateImage);
    checkboxes[i].addEventListener('click', updateTable);
    checkboxes[i].addEventListener('click', drawDistance);
  }

  // PAGE LOAD
  filterSamples();
  updateImage();
  updateTable();
};
