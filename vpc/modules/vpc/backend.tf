terraform {
    backend "s3" {
        bucket = "myblks3"
        region = "us-east-2"
    }
}
