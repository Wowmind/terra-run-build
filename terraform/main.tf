
# Configure cloud run service
resource "google_cloud_run_service" "terrarun" {
  name     = "terrarun"
  location = "us-central1"

  template {
    spec {
      containers {
        image = "gcr.io/${google_project.terra-run-build}/terrarun:${google_build_trigger.terrarun.tag}"
        # Reference the Docker image tag from cloud build
        ports{
          container_port = 8080
        }
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }
}

#create a cloud build trigger
resource "google_cloudbuild_trigger" "terrarun" {
  trigger_template {
    project_id = var.project_id
    repo_name = "terra-run"
    branch_name = "main"
  }
}