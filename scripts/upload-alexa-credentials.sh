#!/bin/bash
set -e

# Upload Alexa CLI credentials to S3
#
# Prerequisites:
#   brew install buddyh/tap/alexacli
#   alexacli auth                    # opens browser at http://127.0.0.1:8080
#                                    # log in to your Amazon account
#                                    # token is saved to ~/.alexa-cli/config.json
#   alexacli auth status --verify    # confirm it worked
#
# If browser auth fails (e.g. alexa-cookie-cli download issue):
#   1. Get a refresh token manually (see README)
#   2. alexacli auth <your-refresh-token>
#
# Usage: ./scripts/upload-alexa-credentials.sh

AWS_PROFILE="${AWS_PROFILE:-personal}"
AWS_REGION="${AWS_REGION:-us-east-2}"
STACK_NAME="openclaw-personal"

echo "📤 Uploading Alexa CLI credentials"
echo ""

# Verify alexacli is authenticated
CONFIG_PATH="$HOME/.alexa-cli/config.json"
if [ ! -f "$CONFIG_PATH" ]; then
    echo "❌ No Alexa CLI config found at $CONFIG_PATH"
    echo ""
    echo "   First authenticate locally:"
    echo "     alexacli auth"
    echo ""
    echo "   This opens a browser at http://127.0.0.1:8080 for Amazon login."
    echo "   After login, your refresh token is saved automatically."
    echo ""
    echo "   Then verify:"
    echo "     alexacli auth status --verify"
    exit 1
fi

# Quick sanity check
if ! alexacli auth status > /dev/null 2>&1; then
    echo "⚠️  alexacli auth status failed — token may be expired"
    echo "   Re-run: alexacli auth"
    echo "   Continuing upload anyway..."
    echo ""
fi

# Get S3 bucket name from CloudFormation
BUCKET=$(aws cloudformation describe-stacks \
    --stack-name $STACK_NAME \
    --profile $AWS_PROFILE \
    --region $AWS_REGION \
    --query 'Stacks[0].Outputs[?OutputKey==`SessionBackupBucketName`].OutputValue' \
    --output text)

if [ -z "$BUCKET" ] || [ "$BUCKET" = "None" ]; then
    echo "❌ Could not find S3 bucket. Is the stack deployed?"
    exit 1
fi

echo "  S3 Bucket: $BUCKET"

# Upload config.json
aws s3 cp "$CONFIG_PATH" "s3://$BUCKET/alexa-credentials/config.json" \
    --profile $AWS_PROFILE --region $AWS_REGION
echo "  ✅ Uploaded config.json"

echo ""
echo "🎉 Done! Credentials will be restored on next container start."
echo ""
echo "   Test locally:"
echo "     alexacli devices"
echo "     alexacli speak \"Hello from OpenClaw\" --announce"
echo ""
echo "   Note: Token valid ~14 days. Re-run 'alexacli auth' + this script when expired."
