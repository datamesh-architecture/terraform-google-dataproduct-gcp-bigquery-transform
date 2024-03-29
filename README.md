# Data Mesh Terraform module "GCP BigQuery Transform"

This open source Terraform module provisions the necessary services to provide a data product on the Google Cloud Platform.

![Overview](https://www.datamesh-architecture.com/images/terraform-dataproduct-gcp-bigquery-transform.png)

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
    teamId = "<domain_team>"
    name = "<data_product_name>"
    input = {
      source_table = "<bigquery_source_table>"
    }
}
```

Create a directory `sql` for *.sql.tftpl files which contains queries for creating BigQuery Views based on the `source_table`.

## Endpoint data

## Examples

See [examples repository](https://github.com/datamesh-architecture/terraform-dataproduct-examples).

## Authors

This terraform module is maintained by [Christine Koppelt](https://www.innoq.com/en/staff/christine-koppelt/), [Jochen Christ](https://www.innoq.com/en/staff/jochen-christ/), and [Simon Harrer](https://www.innoq.com/en/staff/dr-simon-harrer/).

## License

MIT License.
