output "name" {
  value = google_container_cluster.tuna_cluster.name
  description = "The Kubernetes cluster name."
}