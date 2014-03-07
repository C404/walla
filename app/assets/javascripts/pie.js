$(function () {
  if ($('#myChart').length != 0 ) {
      var ctx = $("#myPie").get(0).getContext("2d");
      var newPie = new Chart(ctx).Pie(
       data = [
                {
                    value: 30,
                    color:"#F38630"
                },
                {
                    value : 50,
                    color : "#E0E4CC"
                },
                {
                    value : 100,
                    color : "#69D2E7"
                }           
              ]
            ,Line = {  
                scaleFontColor: "#000",
                datasetStrokeWidth: 5
              }
              );
}
});
