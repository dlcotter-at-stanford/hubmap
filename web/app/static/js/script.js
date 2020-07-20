window.onload = function() {
  var samples = page.domain.samples;
  var subject = page.domain.subject;
  
  //// GLOBALS
  // subject: parent of samples; holds colon-level information
  // samples: array generated in the <script> block in the HTML template 
  var viz = document.getElementById("viz");
  var frame_width       = 1500;
  var frame_height      = 400;
  var conversion_factor = 10;  // 10 pixels per centimeter
  var horizontal_offset = 20;
  var vertical_offset   = 20;

  // Calculate sample size, size category (small/medium/large), and distance
  // from other samples for each sample.
  for (let i=0; i<samples.length; i++) {
    samples[i].size = samples[i].length * samples[i].width * samples[i].depth;
    samples[i].size_cat = samples[i].size < 50  ? "small"
                        : samples[i].size < 100 ? "medium"
                        : "large";
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
    // Compare the attributes of the samples against the filtering criteria in
    // the sidebar. Logic that decides whether to draw or not draw sample.
    // Form: (... OR ... OR ...) AND (... OR ... OR ...) AND ...
    // The reason for this logical form is that each sample should show up if
    // it matches any of the checkboxes within a group but only if each group
    // has at least one match
    for (let i=0; i<samples.length; i++) {
      let sample = samples[i];
      let checked = { };
      let checkbox_ids = 
        [ "tissue_type_normal", "tissue_type_polyp", "tissue_type_adca",
          "size_small", "size_medium", "size_large",
          "phenotype_sessile", "phenotype_stalk",
          "location_ascending", "location_transverse", "location_descending", "location_rectum"
        ];
      checkbox_ids.forEach( checkbox_id => checked[checkbox_id] = document.getElementById(checkbox_id).checked );

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
          (sample.phenotype === "none" ))
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
  }

  function drawRulers() {
    // Draw horizontal ruler
    var line = document.createElementNS("http://www.w3.org/2000/svg", "line");
    line.classList.add("ruler_line");
    line.setAttribute("x1", horizontal_offset);
    line.setAttribute("y1", vertical_offset);
    line.setAttribute("x2", frame_width);
    line.setAttribute("y2", vertical_offset);
    line.style = "stroke:gray; stroke-width:1";
    viz.appendChild(line);

    for (let cm=1; cm < frame_width/conversion_factor; cm++) {
      // Draw horizontal tick marks (the tertiary formula makes every tenth
      // line twice as big and every hundredth line three times as big)
      let line = document.createElementNS("http://www.w3.org/2000/svg", "line");
      line.classList.add("ruler_line");
      line.setAttribute("x1", horizontal_offset + cm * conversion_factor);
      line.setAttribute("y1", vertical_offset);
      line.setAttribute("x2", horizontal_offset + cm * conversion_factor);
      line.setAttribute("y2", vertical_offset +
                              (cm % 100 == 0 ? 3.0 * conversion_factor :
                               cm % 10 == 0  ? 2.0 * conversion_factor :
                               cm % 5 == 0   ? 1.5 * conversion_factor :
                                                     conversion_factor));
      line.style = "stroke:gray; stroke-width:1";
      viz.appendChild(line);

      // Draw distance labels
      if (cm % conversion_factor == 0) {
        let text = document.createElementNS("http://www.w3.org/2000/svg", "text");
        text.setAttribute("x", horizontal_offset + cm * conversion_factor - 7);
        text.setAttribute("y", vertical_offset - 5);
        text.style = "font-size:small";
        text.innerHTML = cm;
        viz.appendChild(text);
      }
    }

    // Draw vertical ruler
    line = document.createElementNS("http://www.w3.org/2000/svg", "line");
    line.classList.add("ruler_line");
    line.setAttribute("x1", horizontal_offset);
    line.setAttribute("y1", vertical_offset);
    line.setAttribute("x2", horizontal_offset);
    line.setAttribute("y2", frame_height);
    line.style = "stroke:gray; stroke-width:1";
    viz.appendChild(line);

    // Draw vertical tick marks
    for (let cm=1; cm < frame_width / conversion_factor; cm++) {
      let line = document.createElementNS("http://www.w3.org/2000/svg", "line");
      line.classList.add("ruler_line");
      line.setAttribute("x1", horizontal_offset);
      line.setAttribute("y1", vertical_offset + cm * conversion_factor);
      line.setAttribute("x2", horizontal_offset +
                              (cm % 100 == 0 ? 3 * conversion_factor :
                               cm % 10 == 0 ? 2  * conversion_factor :
                               cm % 5 == 0 ? 1.5 * conversion_factor :
                                                   conversion_factor));
      line.setAttribute("y2", vertical_offset + cm * conversion_factor);
      line.style = "stroke:gray; stroke-width:1";
      viz.appendChild(line);

      // Draw distance labels
      if (cm % conversion_factor == 0) {
        let text = document.createElementNS("http://www.w3.org/2000/svg", "text");
        text.setAttribute("x", 2);  // slightly offset from frame
        text.setAttribute("y", vertical_offset + cm * conversion_factor + 5);
        text.style = "font-size:small";
        text.innerHTML = cm;
        viz.appendChild(text);
      }
    }
  }

  function drawSections() {
    // Draw vertical lines to show section boundaries of colon
    var sections = [ "rectum" ,"descending" ,"transverse" ,"ascending" ,"colon" ];

    for (let i=0; i<sections.length; i++) {
      // Set up a couple of helper variables to make syntax simpler later
      let section = page.domain.subject[sections[i]];
      let prev_section = i > 0 ? page.domain.subject.sections[sections[i-1]] : 0;

      // null/undefined guard
      if (!section)
        continue;

      let line = document.createElement("line");
      line.setAttribute("x1", horizontal_offset + section * conversion_factor);
      line.setAttribute("y1", vertical_offset);
      line.setAttribute("x2", horizontal_offset + section * conversion_factor);
      line.setAttribute("y2", frame_height);
      line.style = "stroke:gray; stroke-dasharray: 2; stroke-width:2";
      viz.appendChild(line);

      let text = document.createElementNS("http://www.w3.org/2000/svg", "text");
      // Left-justify the labels in their respective sections. If we"re not at
      // the first section in the array and we"re not missing the previous line,
      // then use the previous line as the guide.
      text.setAttribute("x", horizontal_offset + 4 + prev_section * conversion_factor);
      text.setAttribute("y", frame_height - 4);
      text.innerHTML = sections[i].substring(0, sections[i].indexOf("_"));
      text.style = "font-size:small";
      viz.appendChild(text);
    }
  }

  function drawPins() {
    for (let i=0; i<samples.length; i++) {
      let circle = document.createElement("circle");
      circle.setAttribute("id", samples[i].id);
      circle.setAttribute("tissue_type", samples[i].tissue_type);
      circle.setAttribute("phenotype", samples[i].phenotype);
      circle.setAttribute("location", samples[i].location);
      circle.setAttribute("length", samples[i].length);
      circle.setAttribute("width", samples[i].width);
      circle.setAttribute("depth", samples[i].depth);
      circle.setAttribute("cx", horizontal_offset + (subject.sections[4].position - samples[i].x) * conversion_factor);
      circle.setAttribute("cy", vertical_offset + samples[i].y * conversion_factor);
      circle.setAttribute("r", Math.log ( (samples[i].length * samples[i].width * samples[i].depth) ) );
      circle.setAttribute("fill", "gray");

      // Set the text of the pop-up helper that appears when hovering over a
      // sample (through the "title" attribute of the circle element)
      let title = document.createElement("title");
      title.innerHTML = samples[i].id + '\n'
                      + '(' + samples[i].x + ', ' + samples[i].y + ')' + '\n'
                      + samples[i].length + ' x ' + samples[i].width + ' x ' + samples[i].depth + ' '
                      + '(' + (samples[i].length * samples[i].width * samples[i].depth) + ' mm³)' + '\n'
                      + samples[i].tissue_type + ', ' + samples[i].phenotype + ', ' + samples[i].location;

      circle.appendChild(title);
      viz.appendChild(circle);
    }
  }

  function drawDistance(sample_id) {
    for (let i=0; i<samples.length; i++) {
      // Only draw lines from this sample to others (not all to all)
      if (samples[i].id !== sample_id) {
        continue;
      }

      // Clear existing distance lines
      distance_lines = viz.querySelectorAll("line.distance_line");
      for (let j=0; j<distance_lines.length; j++) {
        viz.removeChild(distance_lines[j]);
      }

      // Only draw lines to samples that are currently visible
      for (let j=0; j<samples.length; j++) {
        if (!samples[j].visible) {
          continue;
        }

        line = document.createElementNS("http://www.w3.org/2000/svg", "line");
        line.classList.add("distance_line");
        line.setAttribute("x1", horizontal_offset + samples[i].x * conversion_factor);
        line.setAttribute("y1", vertical_offset   + samples[i].y * conversion_factor);
        line.setAttribute("x2", horizontal_offset + samples[j].x * conversion_factor);
        line.setAttribute("y2", vertical_offset   + samples[j].y * conversion_factor);
        line.style = "stroke:gray; stroke-dasharray: 2; stroke-width:2";
        viz.appendChild(line);

        title = document.createElementNS("http://www.w3.org/2000/svg", "title");
        title.innerHTML = ( Number(samples[i].distance[j]) / subject["colon_length"]).toFixed(1) + " cm"; // fix: 108 is A014"s colon length
        line.appendChild(title);
      }
    }
  }

  function updatePins() {
    for (let i=0; i<samples.length; i++) {
      var pin = viz.getElementById(samples[i].id);

      if (pin) {
        pin.style.display = samples[i].visible ? "" : "none";
      }
    }
  }

  function updateTable() {
    // Purpose  : Toggle each row"s visibility depending on which filters are selected.
    // Structure: A three-level *for* loop
    // Workings : At the innermost level of the *for* loop, a decision is made whether to hide
    //            or show the current row by comparing the first cell in the row, which should
    //            always be the sample name, to the sample name in the "samples"
    //            object.
    // Notes    : * I have created "table", "row", and "sample" variables to hold the current
    //            iteration"s object at each level in the loop (rather than using potentially
    //            confusing array-indexing syntax). Unfortunately, JavaScript doesn"t have a
    //            for-each construct like many other scripting languages, so I"m having to do
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
    tables = document.querySelectorAll("footer table");
    for (let i=0; i<tables.length; i++) {
      table = tables[i];

      for (let j=0; j<table.rows.length; j++) {
        row = table.rows[j];

        if (row.cells.length === 0)
          continue;

        for (let k=0; k<samples.length; k++) {
          sample = samples[k];

          if (row.cells[0].innerHTML === sample.id /*(1)*/) { 
            row.style.display = sample.visible ? "" : "none"; /*(2)*/
          }
        }
      }
    }
    // Footnotes:
    // (1) Resist the urge to combine this logical test with the one in the code to be executed, i.e.:
    //     row.style.display = row.cells[0].innerHTML === sample.id && sample.visible ? "" : "none"
    //     I did this at first and couldn"t understand why the entire table was being hidden.
    //     It"s because for most samples and most rows, the first test will fail (and should), since
    //     there are N rows and N samples, thus N^2 comparisons, only one of which is a match. But
    //     by combining the two logical conditions in the variable assigment, you are acting on each
    //     row N^2 times and in almost every case hiding the row when you shouldn"t be: not because
    //     the sample is hidden, but because the sample name in the row doesn"t match the name of the
    //     sample in the current iteration of the loop. The one row that passes the first logical test
    //     will be hidden by subsequent comparisons to other samples that do not have a matching sample
    //     name. By moving the first logical condition into the *if* check, the row is only acted on once, when the matching sample
    //     is encountered. Forgive the long explanation, but it took a long time to reason this one out.
    // (2) Do not replace the empty string ("") with "block". It will cause the entire row to be inserted
    //     into the first cell of the table (for reasons I don't understand).
  }

  function highlightRow(sample_id) {
    // Highlight the row in the table corresponding to sample and reset all other rows to default style
    table_rows = document.querySelectorAll("table tr");
    for (let j=0; j<table_rows.length; j++) {
      table_rows[j].className = table_rows[j].children[0].innerHTML === sample_id ? "highlighted" : "";
    }
  }
  
  function downloadCSV(table_id) {
    // Purpose: Push a comma-separated value file containing the currently
    // selected rows of the table to the user.
    var table
       ,csv_line_array
       ,cell_array
       ,line
       ,csv_text
       ,element;

    table = document.getElementById(table_id);
    csv_line_array = Array();
    for (let i=0; i<table.rows.length; i++) {
      cell_array = Array();

      // Don't put hidden rows in export
      if (table.rows[i].style.display === "none") {
        continue;
      }

      // Do put all visible rows in export
      for (let j=0; j<table.rows[i].cells.length; j++) {
        cell_array.push(table.rows[i].cells[j].innerHTML);
      }
      line = cell_array.join(",");
      csv_line_array.push(line);
    }
    csv_text = csv_line_array.join("\n");

    // Create an invisible link, click it, and remove it
    element = document.createElement("a");
    element.setAttribute("href", "data:text/plain;charset=utf-8," + encodeURIComponent(csv_text));
    element.setAttribute("download", table_id + '-' + subject['id'] + '.csv'); //fix
    element.style.display = "none";
    document.body.appendChild(element);
    element.click();
    document.body.removeChild(element);
  }

  function attachEvents() {
    pins = document.querySelectorAll("svg#viz circle"); // viz.querySelectorAll("circle")
    for (let i=0; i<pins.length; i++) {
      pins[i].addEventListener("mouseover",
        function() {
          drawDistance(this.id);
          highlightRow(this.id);
        });
    }

    checkboxes = document.querySelectorAll("input[type='checkbox']");
    for (let i=0; i<checkboxes.length; i++) {
      checkboxes[i].addEventListener("click",
        function() {
          setVisibility();
          updatePins();
          updateTable();
          document.getElementById("viz-wrapper").innerHTML += ""; // refresh
        });
    }

    csv_links = document.querySelectorAll("footer .tab label a.download-link");
    for (let i=0; i<csv_links.length; i++) {
      csv_links[i].addEventListener("click", (function(id) {
        return function(e) {
          downloadCSV(id);
        };
      })(csv_links[i].getAttribute("table_id")));
    }
  }

  // PAGE LOAD
  // Determine sample visibility based on filter selection
  setVisibility();

  // Draw the elements of the visualization
  drawRulers();
  drawSections();
  drawPins();

  // Populate the table
  updateTable();

  document.getElementById("viz-wrapper").innerHTML += ""; // refresh

  // Attach events to filters, pins, links, etc.
  attachEvents();
};

