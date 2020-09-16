import json
import boto3   # AWS SDK
import base64  # for receiving images


def lambda_handler(event, _):

    # values from api (POST)
    body = json.loads(event["body"])

    # initializing variables
    imageFeatures = set()
    textFeatures = set()

    if("img" in body):
        # getting features from image
        imgBytes = base64.b64decode(body["img"])

        reko = boto3.client("rekognition")

        res = reko.detect_labels(Image={
            # sending image as bytes
            "Bytes": imgBytes
        })

        for label in res["Labels"]:
            imageFeatures.add(label["Name"])
            for labelParent in label["Parents"]:
                imageFeatures.add(labelParent["Name"])

    if ("text" in body):
        # getting features from text
        comp = boto3.client('comprehend')

        res = comp.detect_entities(Text=body["text"], LanguageCode="ar")
        entities = res["Entities"]  # I don't like caps :)

        for entity in entities:
            if entity["Score"] > 0.50:
                acceptedTypes = ["ORGANIZATION",
                                 "COMMERCIAL_ITEM", "TITLE", "OTHER"]
                if entity["Type"] in acceptedTypes:
                    textFeatures.add(entity["Text"])
    # combine features with no duplicates
    features = list(imageFeatures.union(textFeatures))

    return {
        "statusCode": 200,
        # "headers":{"content-type":"image/png"},
        "body": json.dumps(features)
    }
