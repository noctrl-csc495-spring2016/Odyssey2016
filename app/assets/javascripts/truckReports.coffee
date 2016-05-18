window.App ||= {};
App.exportFiles =-> $("a, span, i, div").tooltip()
$(document).on "page:change", ->App.exportFiles

var submitButton = $(document).getElementById("exportButton");
var select = $(document).getElementById("pickupday");

// Attaches an onClick listener to the export button
submitButton.addEventListener("click", exportFiles);
//This function is called everytime the user clicks the export button
function exportFiles()
{
  //Used iframes to be able to download multiple files

    var iframe1 = $(document).createElement('iframe');

    //Url is built using the selected value in the dropdown menu
    url = "/reports/truck.pdf?pickupday=" + select.value;
    iframe1.style.display = "none";
    iframe1.src = url ;
    $(document).body.appendChild(iframe1);

    var iframe2 = $(document).createElement('iframe');

    //Url is build using the selected value in the dropdown menu
    url = "/reports/truck.csv?pickupday=" + select.value;
    iframe2.style.display = "none";
    iframe2.src = url ;
    $(document).body.appendChild(iframe2);
}
