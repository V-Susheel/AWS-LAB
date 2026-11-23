resource "aws_cloudwatch_log_group" "fleet_health" {
  name              = "${var.name}-fleet-health"
  retention_in_days = 7
}
