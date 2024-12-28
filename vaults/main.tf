provider "aws" {
  region = "us-east-1"
}

provider "vault" {
  address = "http://18.206.170.161:8200"
  skip_child_token = true

  auth_login {
    path = "auth/approle/login"

    parameters = {
      role_id = "664cf257-688a-a15c-6136-7e7f6c80918c"
      secret_id = "996e07f2-12e9-3aa6-651b-329c4f88654f"
    }
  }
}

data "vault_kv_secret_v2" "example" {
  mount = "kv"
  name  = "test-sec"
}
