resource "proxmox_virtual_environment_role" "this" {
  role_id = "csi"

  privileges = [
    "VM.Audit",
    "VM.Config.Disk",
    "Datastore.Allocate",
    "Datastore.AllocateSpace",
    "Datastore.Audit"
  ]
}

resource "proxmox_virtual_environment_user" "this" {
  user_id = "kubernetes-csi@pve"
  acl {
    path      = "/"
    propagate = true
    role_id   = proxmox_virtual_environment_role.this.role_id
  }
}
