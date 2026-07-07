import argparse
import boto3
from botocore.exceptions import ClientError


def create_presigned_url(bucket: str, key: str, region: str, expires_in: int) -> str:
    s3_client = boto3.client("s3", region_name=region)

    try:
        return s3_client.generate_presigned_url(
            ClientMethod="get_object",
            Params={
                "Bucket": bucket,
                "Key": key,
            },
            ExpiresIn=expires_in,
        )
    except ClientError as error:
        raise SystemExit(f"Failed to generate presigned URL: {error}") from error


def main():
    parser = argparse.ArgumentParser(description="Generate an S3 presigned URL.")
    parser.add_argument("--bucket", required=True, help="S3 bucket name")
    parser.add_argument("--key", required=True, help="S3 object key")
    parser.add_argument("--region", default="ap-southeast-1", help="AWS region")
    parser.add_argument("--expires-in", type=int, default=300, help="Expiration in seconds")
    args = parser.parse_args()

    url = create_presigned_url(
        bucket=args.bucket,
        key=args.key,
        region=args.region,
        expires_in=args.expires_in,
    )
    print(url)


if __name__ == "__main__":
    main()
