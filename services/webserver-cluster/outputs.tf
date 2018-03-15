/*output "address" {
  value = "${aws_db_instance.example.address}"
}

output "port" {
  value = "${aws_db_instance.example.port}"
}
*/
// same as the example code
output "asg_name" {
  value = "${aws_autoscaling_group.example.name}"
}

output "elb_dns_name" {
  value = "${aws_elb.example.dns_name}"
}

output "elb_security_group_id" {
  value = "${aws_security_group.elb.id}"
}
