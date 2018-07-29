#output "vpc_id" {
#  value = "${module.vpc.vpc_id}"
#}

output "public_route_table_ids" {
  value = "${module.vpc.public_route_table_ids}"
}

