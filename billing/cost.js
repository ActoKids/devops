// Load the SDK 
var AWS = require("aws-sdk");
AWS.config.loadFromPath('./config.json');

//create time period variables
var today = new Date;
var end = today.getFullYear() + '-' + today.getMonth()+1 + '-' + today.getDate();
//get yesterday's date
today.setDate(today.getDate()-1);
var start = today.getFullYear() + '-' + today.getMonth()+1 + '-' + today.getDate();

//instantiate costexplorer service
var costexplorer = new AWS.CostExplorer({apiVersion: '2017-10-25', region: "us-east-1"});
var params = {
    Granularity: "DAILY",
    Metrics: ['UnblendedCost'],
    GroupBy: [{
        Type: 'DIMENSION',
        Key: 'SERVICE',
      }],
    TimePeriod:{
        Start:start,
        End:end
    }
}

costexplorer.getCostAndUsage(params, function(err, data) {
    if (err) console.log(err, err.stack);
    else console.log(JSON.stringify(data));
});