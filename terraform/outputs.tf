################################
# VM & BindPlane Server
################################
output "bindplane_vm_name" {
  value = google_compute_instance.bindplane_vm.name
}

output "bindplane_vm_ip" {
  value = google_compute_instance.bindplane_vm.network_interface[0].access_config[0].nat_ip
}

################################
# BindPlane Agent
################################
output "bindplane_agent_name" {
  value = bindplane_configuration.logs_config.name
}

output "bindplane_metrics_agent_name" {
  value = bindplane_configuration.metrics_config.name
}

################################
# BindPlane Sources
################################
output "bindplane_host_metrics_source" {
  value = bindplane_source.host_metrics.name
}

output "bindplane_journald_logs_source" {
  value = bindplane_source.journald_logs.name
}

################################
# BindPlane Processor
################################
output "bindplane_batch_processor" {
  value = bindplane_processor.batch.name
}

################################
# GCS Bucket
################################
output "bindplane_bucket_name" {
  value = google_storage_bucket.bindplane_bucket.name
}

################################
# GCO Dashboard
################################
output "bindplane_gco_dashboard_id" {
  value = google_monitoring_dashboard.bindplane_dashboard.id
}

################################
# GCO Alert
################################
output "bindplane_gco_alert_id" {
  value = google_monitoring_alert_policy.bindplane_alert.id
}

################################
# API Key for Terraform (auto-generated)
################################
output "bindplane_api_key" {
  value       = var.bindplane_api_key
  description = "Automatically generated API key for BindPlane Terraform provider"
  sensitive   = true
}
