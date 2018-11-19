"use strict";

var worker;
var code_editor;
var examples = {
    'Hello World':
        'IDHU EPADI IRUKU "Hello World"',
    'Primes till 20':
        'I AM CHITTI 2.0\n' +
        'MEHHH! FIRST n PRIMES\n' +
        'IDHU EPADI IRUKU "PRIMES TILL 20"\n' +
        '2 SOLRAN X SEIRAN\n' +
        'NOORU THADAVA SONNA MAADIRI X < 20\n' +
        '  2 SOLRAN D SEIRAN\n' +
        '  1 SOLRAN R SEIRAN\n' +
        '  NOORU THADAVA SONNA MAADIRI D < X\n' +
        '    R*(X % D) SOLRAN R SEIRAN\n' +
        '    D+1 SOLRAN D SEIRAN\n' +
        '  MAGIZHCHI\n' +
        '  \n' +
        '  MALAI DA ANNAMALAI R <> 0\n' +
        '    IDHU EPADI IRUKU X\n' +
        '  KATHAM, KATHAM\n' +
        '  X+1 SOLRAN X SEIRAN\n' +
        'MAGIZHCHI',
    'Fizz Buzz':
        'MEHHH! FIZZU...BUZZU...\n' +
        '1 SOLRAN X SEIRAN\n' +
        'NOORU THADAVA SONNA MAADIRI X < 20\n' +
        '  MALAI DA ANNAMALAI X % 3 == 0\n' +
        '    IDHU EPADI IRUKU "Fizz"\n' +
        '  KATHAM, KATHAM\n' +
        '  MALAI DA ANNAMALAI X % 5 == 0\n' +
        '    IDHU EPADI IRUKU "Buzz"\n' +
        '  KATHAM, KATHAM  \n' +
        '  MALAI DA ANNAMALAI (X % 3) * (X % 5) <> 0\n' +
        '    IDHU EPADI IRUKU X\n' +
        '  KATHAM, KATHAM\n' +
        '  X+1 SOLRAN X SEIRAN\n' +
        'MAGIZHCHI',
    'Magic 8-Ball':
        'MEHHH! SIMPLER MAGIC 8-BALL\n' +
        'IDHU EPADI IRUKU "Think of a question before reading the next line: "\n' +
        'BILLA % 3 SOLRAN DICE SEIRAN\n' +
        'MALAI DA ANNAMALAI DICE == 0\n' +
        '  IDHU EPADI IRUKU "Outlook not so good."\n' +
        'KATHAM, KATHAM\n' +
        'MALAI DA ANNAMALAI DICE == 1\n' +
        '  IDHU EPADI IRUKU "Concentrate and ask again."\n' +
        'KATHAM, KATHAM\n' +
        'MALAI DA ANNAMALAI DICE == 2\n' +
        '  IDHU EPADI IRUKU "As I see it, yes."\n' +
        'KATHAM, KATHAM',
};


function init () {
    // If Service worker is not supported, then abort!
    if (!('serviceWorker' in navigator)) {
        alert("Your browser does not seem to support Webworkers. Try Firefox, Chrome or IE10+.");
        return;
    }
    var input=document.getElementById ("input");
    code_editor = CodeMirror.fromTextArea(input, {
        lineNumbers: true,
        theme: "lesser-dark",
        mode: "punchscript"
    });
    $("#output-area").hide(0);

    /* Handling clicking the Run button */
    $('#runbutton').click(function(e) {
        go();
        return false;
    });
    
    /* Populate drop-down with examples */
    var dropdown = $("#inputExamples");
    $.each(examples, function(k,v) { dropdown[0].add(new Option(k,k)); } );
    dropdown.change(function() {
        var title = $('option:selected', this).text();
        code_editor.setValue(examples[title]);
    });
}

// Run the input code
function go () {
    var input = $("#input");
    var output_area = $("#output-area");
    var output = $("#output");
    var error = $("#errorarea");
    var inputcode = code_editor.getValue();   
    var lines = inputcode.split(/\r|\r\n|\n/);
    var linecount = lines.length;
    
    console.log("Executing " + linecount + " lines of Punchscript...");
    if (worker) {
        worker.terminate();
    }
    worker = new Worker ("js/punch.bc.js");
    
    /* Handle response from OCaml */
    worker.onmessage = function (m) {
        if (typeof m.data == 'string') {
            var result_code = m.data.slice(0,1);
            var result_body = m.data.slice(2,-1);
            
            if(result_code == "0") {
                output_area.show("fast", function() {
                    output_area[0].scrollIntoView();
                    output.val(result_body);
                    error.hide();
                });
            }
            else {
                var parts = result_body.split(":", 3);
	        var line  = parseInt(parts[0]);
	        var col   = parseInt(parts[1]);
	        var msg   = parts[2];
                
                output_area.show("fast", function() {
                    output_area[0].scrollIntoView();
                    output.val("");
                    error.html("Line:" + line + "<br>Column:" + col + "<br><br><i>" + msg + "</i>");
	            error.show();
                })
                
            }
        }
    }

    /* Send Punchscript code to OCaml */
    worker.postMessage({"input": inputcode});
    /* Prevent scroll */
    return false;
}

jQuery(function($) {
    init();
});
