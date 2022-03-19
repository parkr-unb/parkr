var AWS = require('aws-sdk');
AWS.config.update({region: process.env.REGION});

async function sendParkrEmail(destinationEmailAddress, emailBody) {
    var params = {
      Destination: {
        ToAddresses: [destinationEmailAddress]
      },
      Message: {
        Body: {
          Text: {
           Charset: "UTF-8",
           Data: emailBody
          }
         },
         Subject: {
          Charset: 'UTF-8',
          Data: 'You\'ve Received a Parking Ticket'
         }
        },
      Source: 'tickets@parkrtickets.ca',
      ReplyToAddresses: [
         'tickets@parkrtickets.ca',
      ],
    };

    var messageId = null
    var error = null

    // Create the promise and SES service object
    var sendPromise = new AWS.SES({apiVersion: '2010-12-01'}).sendEmail(params).promise();
    await sendPromise
        .then(data => messageId = data.MessageId)
        .catch(err => {
            console.error(err, err.stack);
            error = err
        });

    return {
        messageId: messageId,
        error: error
    }
}


/**
 * @type {import('@types/aws-lambda').APIGatewayProxyHandler}
 */
exports.handler = async (event) => {
    console.log(`EVENT: ${JSON.stringify(event)}`);
    var emailBody = `A parking infraction has occurred to the vehicle associated with this email address.

Please find your parking ticket information below.

${event.arguments.emailBody}



Courtesy of Parkr`

    const result = await sendParkrEmail(event.arguments.emailAddress, emailBody)
    return {
        messageId: result.messageId,
        message: null,
        error: result.error
    };
};
