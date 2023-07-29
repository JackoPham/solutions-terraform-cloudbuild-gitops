
resource "google_cloudbuild_trigger" "sample-api-trigger" {
    name = "sample-api"
    project =  var.project
    # location        = var.region

    github {
        name = var.github_repository
        owner = var.github_owner
        push {
            branch = var.github_branch
        }
    }

    substitutions = {
        _REGISTRY       = google_artifact_registry_repository.my-repository.repository_id
        _REGISTRY_URL   = "${var.region}-docker.pkg.dev"
    }

    filename = "cloudbuild.yaml"

    
}