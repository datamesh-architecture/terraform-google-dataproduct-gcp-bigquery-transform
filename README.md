# terraform-dataproduct-gcp-bigquery-transform

This open source Terraform module provisions the necessary services to provide a data product on the Google Cloud Platform.

![Overview](https://www.datamesh-architecture.com/images/google-cloud-bigquery.png)

## Services
* Google BigQuery
* Google Cloud Functions

## Usage
```
module "bigquery_datenprodukt" {
    source = "git@github.com:datamesh-architecture/terraform-dataproduct-gcp-bigquery-transform"
    gcp = {
      project = "<gcp_project>"
      region  = "<gcp_region>"
    }
    domain = "<data_product_domain>"
    name = "<data_product_name>"
    input = {
      source_table = "<bigquery_source_table>"
      transform = "<sql_transformation_script>"
    }
}
```

## Endpoint data

## Examples

See [examples repository](https://github.com/datamesh-architecture/terraform-dataproduct-examples).

## Authors

This terraform module is maintained by [Christine Koppelt](https://www.innoq.com/en/staff/christine-koppelt/), [Jochen Christ](https://www.innoq.com/en/staff/jochen-christ/), and [Simon Harrer](https://www.innoq.com/en/staff/dr-simon-harrer/).

## License

MIT License.
