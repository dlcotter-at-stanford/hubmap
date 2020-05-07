window.onload = function() {
  // Calculate size for each sample and average size for the set
  sum = 0;
  for (let i=0; i<samples.length; i++) {
    samples[i].size = samples[i].length * samples[i].width * samples[i].depth;
    samples[i].size_cat = samples[i].size < 50 ? 'small' : samples[i].size < 100 ? 'medium' : 'large';
    // Figure out how big to draw the circle on the canvas by first calculating the volume of the
    // sample and then taking the cube root. This is not precisely accurate - it returns the length
    // of one side of a cube rather than the radius of a sphere, but the formula is much simpler and
    // sufficiently close to the spherical radius.
    samples[i].radius = Math.pow(samples[i].size, 1/3);
    sum += samples[i].size;
  }
  samples.avg_size = sum / samples.length;

  //// DISTANCE
  // Two-dimensional distance function, i.e. Pythagorean formula
  // Note that whatever objects are passed in must have fields "x" and "y"
  var dist = function(a, b) {
    return Math.sqrt( Math.pow((a.x - b.x), 2) + Math.pow((a.y - b.y), 2) );
  }

  // Create a distance matrix that we can use to calculate and store the distances between all
  // the points in advance so that they are easily displayed with a bit of hide/show code. It
  // will be a two-dimensional array with the distance between the i-th and j-th sample stored
  // at dist_mtx[i][j].
  var dist_mtx = []; 

  // Populate distance matrix with two-level for loop
  for (let i = 0; i < samples.length; i++) {
    dist_mtx[i] = [];
    for (let j = 0; j < samples.length; j++) {
      dist_mtx[i].push(dist(samples[i], samples[j]))
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

  function updateCanvas() {
    context.clearRect(0, 0, canvas.width, canvas.height);

    for (let i=0; i<samples.length; i++) {
      // Take no action for hidden samples
      if (!samples[i].visible) continue;

      // Display pin
      context.beginPath();
      samples[i].pin = new Path2D();
      samples[i].pin.arc(samples[i].x, samples[i].y, samples[i].radius, 0, 2 * Math.PI);
      context.fillStyle = 'gray';
      context.fill(samples[i].pin);
       
      // Highlight the row in the table corresponding to sample when the mouse moves over it.
      // Note this event listener is attached to the canvas but carries with it certain variables
      // in scope when this block of code executes, e.g. i and samples[i].pin.
      canvas.addEventListener('mousemove', (e) => {
        if (context.isPointInPath(samples[i].pin, e.offsetX, e.offsetY)) {
          table_rows = document.querySelectorAll('#info > tr');
          for (let j=0; j<table_rows.length; j++) {
            if (table_rows[j].children[0].innerHTML === samples[i].id) {
              // Highlight row corresponding to sample
              table_rows[j].className = 'highlighted';
            } else {
              // Reset all other rows to default
              table_rows[j].className = '';
            }
          }
        }
      });
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

  // Page-load actions
  var canvas = document.getElementById('canvas');
  var context = canvas.getContext('2d');

  // Event handling & canvas updating
  checkboxes = document.querySelectorAll('input[type="checkbox"]');
  for (let i=0; i<checkboxes.length; i++) {
    checkboxes[i].addEventListener('click', filterSamples);
    checkboxes[i].addEventListener('click', updateCanvas);
    checkboxes[i].addEventListener('click', updateTable);
  }

  filterSamples();
  updateCanvas();
  updateTable();
};
