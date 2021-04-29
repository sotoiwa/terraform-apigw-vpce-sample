def lambda_handler(event, context):
    print('Hello from AWS Lambda')
    return {
        'isBase64Encoded': False,
        'statusCode': 200,
        'headers': {},
        'body': '{"message": "Hello from AWS Lambda!"}'
    }