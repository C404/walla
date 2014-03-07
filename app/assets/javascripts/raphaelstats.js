$(function () {
  if ($('#myChart').length != 0 ) {
  //Get context with jQuery - using jQuery's .get() method.
  var ctx = $("#myChart").get(0).getContext("2d");
  //This will get the first returned node in the jQuery collection.
  var myNewChart = new Chart(ctx).Line(
    data = {
            labels : ["Sep","Oct","Nov","Dec","Jan","Fev","Mar"],
            datasets : [
              {
                fillColor : "#27AE60",
                strokeColor : "rgba(220,220,220,1)",
                pointColor : "rgba(220,220,220,1)",
                pointStrokeColor : "#fff",
                data : [65,59,90,81,56,55,70]
              },
              {
                fillColor : "#34495e",
                strokeColor : "rgba(151,187,205,1)",
                pointColor : "rgba(151,187,205,1)",
                pointStrokeColor : "#fff",
                data : [28,48,40,19,12,27,32]
              }
            ]
          }
    , Line = {  
                scaleFontColor: "#000",
                datasetStrokeWidth: 5
              }
      );

     $('body').css('background-color', '#2a94d6');
}
});

