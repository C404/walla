$(function () {
  if ($('#myChart').length != 0 ) {
    var ctx = $("#myBar").get(0).getContext("2d");
    var myBar = new Chart(ctx).Bar(data = {
                labels : ["incendie","etranger","probleme","mal","moto","voiture"],
                datasets : [
                  {
                    fillColor : "#dedede",
                    strokeColor : "rgba(220,220,220,1)",
                    data : [65,59,90,61,56,85]
                  }
                ]
              },Line = {  
                        scaleFontColor: "#000",
                        datasetStrokeWidth: 5
                      });

}
});
