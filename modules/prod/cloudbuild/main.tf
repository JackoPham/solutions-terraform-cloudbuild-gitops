resource "google_project_service" "service_cloudbuild" {
    for_each = toset([
        "artifactregistry.googleapis.com",
        "cloudbuild.googleapis.com"
    ])

    service = each.key

    project            = var.project_id
    disable_on_destroy = false
}

resource "google_project_iam_member" "cloudbuild-iam" {
    project = var.project_id
    role    = "roles/iam.serviceAccountUser"
    member  = "serviceAccount:${var.project_number}@cloudbuild.gserviceaccount.com"
}

resource "google_artifact_registry_repository" "source-repository" {
    project=  var.project_id
    # location        = var.region
    repository_id   = var.github_repository
    format          = "DOCKER"
    depends_on      = [google_project_service.service_cloudbuild["artifactregistry.googleapis.com"]]
}

resource "google_cloudbuild_trigger" "api-trigger" {
    name = var.trigger_name
    project =  var.project_id

    github {
        name = var.github_repository
        owner = var.github_owner
        push {
            branch = var.github_branch
        }
    }

    substitutions = {
        _REGISTRY       = google_artifact_registry_repository.source-repository.repository_id
        _REGISTRY_URL   = "${var.region}-docker.pkg.dev"
        _REGION         = var.region
        _PROJECT_NAME   = var.project_id
        _GKE_NAMESPACE  = var.gke_namespace
        _ZONE           = var.main_zone
        _CLUSTER        = var.cluster_name
        _BASTION        = var.bastion
    }

    filename = var.build_file_name
}