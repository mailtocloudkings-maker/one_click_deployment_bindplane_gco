resource "google_monitoring_dashboard" "bindplane_dashboard" {
  dashboard_json = jsonencode({
    displayName = "BindPlane Logs & Metrics"
    widgets = [
      {
        title = "BindPlane CPU Metrics"
        xyChart = {
          dataSets = [
            {
              timeSeriesQuery = {
                timeSeriesFilter = {
                  metric = "compute.googleapis.com/instance/cpu/utilization"
                  resourceType = "gce_instance"
                }
              }
            }
          ]
        }
      }
    ]
  })
}
