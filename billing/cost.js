let AWS = require("aws-sdk")

//create time period variables
let today = new Date
let month = (today.getUTCMonth() + 1) < 10 ? ('0' + (today.getUTCMonth() + 1)) : (today.getUTCMonth() + 1);
let start = today.getUTCFullYear() + '-' + month + '-' + today.getUTCDate()
let end = today.getUTCFullYear() + '-' + month + '-' + (today.getUTCDate() + 1);

//instantiate costexplorer service
let costexplorer = new AWS.CostExplorer({apiVersion: '2017-10-25', region: "us-east-1"});
let params = {
        Granularity: "DAILY",
        Metrics: ['BlendedCost'],
        GroupBy: [{
            Type: 'DIMENSION',
            Key: 'SERVICE',
        }],
        TimePeriod:{
            Start:start,
            End:end
        }
    }

exports.handler = (event, context, callback) => {
    
    let getCostAndUsagePromise = costexplorer.getCostAndUsage(params).promise();
    getCostAndUsagePromise.then(
        (data) => {
            callback(null, JSON.stringify(data));
        },
        (err) => {
            console.log(err);
            callback(err);
        }
    );
};
