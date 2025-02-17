
data "google_project" "project" {
    project_id = var.project
}

resource "google_project_service" "service" {
    for_each = toset([
        "artifactregistry.googleapis.com",
        # "run.googleapis.com"
    ])

    service = each.key

    project            = var.project
    disable_on_destroy = false
}

# resource "google_project_iam_member" "cloudbuild-run" {
#     project = var.project
#     role    = "roles/run.admin"
#     member  = "serviceAccount:${data.google_project.project.number}@cloudbuild.gserviceaccount.com"
# }

resource "google_project_iam_member" "cloudbuild-iam" {
    project = var.project
    role    = "roles/iam.serviceAccountUser"
    member  = "serviceAccount:${data.google_project.project.number}@cloudbuild.gserviceaccount.com"
}

resource "google_artifact_registry_repository" "tuna-sample-repository" {
    project=  var.project
    # location        = var.region
    repository_id   = var.github_repository
    format          = "DOCKER"
    depends_on      = [google_project_service.service["artifactregistry.googleapis.com"]
 ]
}

resource "google_cloudbuild_trigger" "sample-api-trigger" {
    name = "sample-api"
    project =  var.project

    github {
        name = var.github_repository
        owner = var.github_owner
        push {
            branch = var.github_branch
        }
    }

    substitutions = {
        _REGISTRY       = google_artifact_registry_repository.tuna-sample-repository.repository_id
        _REGISTRY_URL   = "${var.region}-docker.pkg.dev"
        _REGION         = var.region
        _PROJECT_NAME   = var.project
        _GKE_NAMESPACE  = "tuna-tech-namespace"
        _ZONE           = var.zone
        _CLUSTER        = "tuna-cluster"
        _BASTION        = "tuna-bastion"
    }

    filename = "cloudbuild.yaml"
}