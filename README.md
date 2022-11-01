# nextflow-vulcan

A metagenomics analysis pipeline written in [nextflow](1).

## Local Setup and testing

Make sure that `nextflow` is installed on your system, if not visit the [nextflow installation](2). You can verify nextflow that is installed or to check the current version by running `nextflow -version` and to update to the latest version you can run `nextflow self-update`. As of writing we are using version `22.10.0` so please use that version or greater.

### Download development/test data

The data used for development and testing is stored on AWS S3 bucket. To download to `data/` directory, run `make download-data`; this assueme you have configured the AWS CLI using the defualt profile; to configure a named profile please refer to the [AWS docs](3); then you can add your named profile to a `.env` file and it will get loaded when you run make.

### Pull the latest docker image

You can pull the latest docker image by running `make pull-image` this will pull from docker registry.  If you update the dockerfile in development you can run `make build-image` this will build the image locally.

[1]: https://www.nextflow.io/
[2]: https://www.nextflow.io/docs/latest/getstarted.html#
[3]: https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-profiles.html