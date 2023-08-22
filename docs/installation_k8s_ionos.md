# Installation eines Kubernetes Cluster in der IONOS Cloud

Diese Anleitung basiert auf einem [IONOS managed K8s Cluster](https://cloud.ionos.de/).
Dies dient nur einer einfach Demonstration und ist auch für andere Infrastrukturen
und Provider anwendbar.

## Inhaltsverzeichnis

- [Inhaltsverzeichnis](#inhaltsverzeichnis)
- [Installation von Terraform](#installation-von-terraform)
- [Abfrage gültiger K8s Versionen](#abfrage-gültiger-k8s-versionen)
- [Terraform Dateien](#terraform-dateien)
- [K8s Cluster bereitstellen](#k8s-cluster-bereitstellen)
- [K8s Cluster löschen](#k8s-cluster-löschen)

## Installation von Terraform

- [Download und Installation von Terraform](https://developer.hashicorp.com/terraform/downloads)
- [Dokumentation der IONOS Terraform API](https://registry.terraform.io/providers/ionos-cloud/ionoscloud/latest/docs)

## Abfrage gültiger K8s Versionen

Die verfügbaren K8s Versionen können in der IONOS Cloud-Administration
eingesehen oder per REST-API abgefragt werden.

- [Dokumentation der API](https://api.ionos.com/docs/cloud/v6/#tag/Kubernetes/operation/k8sVersionsGet)

Beispiel einer Abfrage mit Hilfe von curl und [jq](https://jqlang.github.io/jq/):

```shell
curl --silent --show-error -u "<username>:<password>" https://api.ionos.com/cloudapi/v6/k8s/versions | jq
```

```json
[
  "1.27.4",
  "1.26.7",
  "1.26.6",
  "1.26.5",
  "1.26.4",
  "1.25.12",
  "1.25.11",
  "1.25.10",
  "1.25.9",
  "1.25.6",
  "1.25.5",
  "1.24.16",
  "1.24.15",
  "1.24.14",
  "1.24.13",
  "1.24.10",
  "1.24.9",
  "1.24.8",
  "1.24.6"
]
```

## Terraform Dateien

1. Die drei Dateien in ein Verzeichnis kopieren
   - `variables.tf` - notwendige Variablen
   - `vdc.tf` - virtuelles Rechenzentrum in dem die K8s Worker-Nodes
   betrieben werden
   - `k8sCluster.tf` - Das K8s Cluster mit der Konfiguration der
   Compute-Leistung
1. Benutzername und Passwort in `variables.tf` setzen. Alternativ ist dies auch
via [Environment Variablen](https://registry.terraform.io/providers/ionos-cloud/ionoscloud/latest/docs#usage)
möglich.
1. Benötigte Compute-Ressourcen in `k8sCluster.tf` konfigurieren
1. Bei Bedarf die [verfügbare](#abfrage-gültiger-k8s-versionen)
bzw. benötigte K8s Version in `k8sCluster.tf` konfigurieren

```terraform
// variables.tf

variable "ionos_user" {
  description = "Username for basic authentication of API"
  default     = "<username>"
}

variable "ionos_password" {
  description = "Password for basic authentication of API"
  default     = "<password>"
}
```

```terraform
// vdc.tf

terraform {
  required_providers {
    ionoscloud = {
      source = "ionos-cloud/ionoscloud"
      version = "~> 6.4.0"
    }
  }
}

provider "ionoscloud" {
  username = "${var.ionos_user}"
  password = "${var.ionos_password}"
}

///////////////////////////////////////////////////////////
// Virtual Data Center
///////////////////////////////////////////////////////////

resource "ionoscloud_datacenter" "publicK8s" {
  name        = "publicK8s-VDC"
  location    = "de/txl"
  description = "VDC managed by Terraform - do not edit manually"
  sec_auth_protection = false
}
```

```terraform
// k8sCluster.tf

///////////////////////////////////////////////////////////
// K8s Cluster
///////////////////////////////////////////////////////////

resource "ionoscloud_k8s_cluster" "publicCluster" {
  name        = "publicCluster"
  k8s_version = "1.26.7"
  maintenance_window {
    day_of_the_week = "Monday"
    time            = "09:30:00Z"
  }
}

///////////////////////////////////////////////////////////
// K8s Node Pool
///////////////////////////////////////////////////////////

resource "ionoscloud_k8s_node_pool" "nodepool-1" {
  name        = "nodepool-1"
  k8s_version = "1.26.7"
  maintenance_window {
    day_of_the_week = "Sunday"
    time            = "10:30:00Z"
  }
  datacenter_id     = ionoscloud_datacenter.publicK8s.id
  k8s_cluster_id    = ionoscloud_k8s_cluster.publicCluster.id
  cpu_family        = "INTEL_SKYLAKE"
  availability_zone = "AUTO"
  storage_type      = "HDD"
  node_count        = 2
  cores_count       = 2
  ram_size          = 4096
  storage_size      = 10
//   labels = {
//     foo = "bar"
//   }
//   annotations = {
//     foo = "bar"
//   }
}

data "ionoscloud_k8s_cluster" "publicCluster" {
  depends_on = [
    ionoscloud_k8s_cluster.publicCluster
  ]
  name = "publicCluster"
}

resource "local_file" "kubeconfig" {
  content = yamlencode(jsondecode(data.ionoscloud_k8s_cluster.publicCluster.kube_config))
  filename = "kubeconfig.yaml"
}
```

## K8s Cluster bereitstellen

```shell
terraform init
terraform plan
terraform apply
```

Die Erstellung benötigt mehrere Minuten Zeit (> 5 Minuten).

In den Ansichten für Datacenter und K8s Cluster in der IONOS Cloud-Administration
können die Status verfolgt werden.

Terraform generiert nach erfolgreichem Abschluss eine `kubeconfig.yaml`.
Diese enthält die Zugangsdaten für das erstellte K8s Cluster.

## K8s Cluster löschen

```shell
terraform destroy
```
