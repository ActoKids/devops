// Load the SDK 
var AWS = require("aws-sdk");
AWS.config.loadFromPath('./config.json');

var costexplorer = new AWS.CostExplorer({apiVersion: '2017-10-25', region: "us-east-1"});
var params = {
    Granularity: "DAILY",
    Metrics: ['UnblendedCost'],
    GroupBy: [{
        Type: 'DIMENSION',
        Key: 'SERVICE',
      }],
    TimePeriod:{
        Start:"2019-01-10",
        End:"2019-01-23"
    }
}

costexplorer.getCostAndUsage(params, function(err, data) {
    if (err) console.log(err, err.stack);
    else console.log(JSON.stringify(data));
});