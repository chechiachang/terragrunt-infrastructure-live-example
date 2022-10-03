terraform {
  //source = "/Users/che-chia/workspace/_chechia/terragrunt-infrastructure-modules//aws/modules/account-baseline-root"
  source = "git::https://github.com/chechiachang/terragrunt-infrastructure-modules.git//aws/modules/account-baseline-root?ref=v0.0.4"

  # This module deploys some resources (e.g., AWS Config) across all AWS regions, each of which needs its own provider,
  # which in Terraform means a separate process. To avoid all these processes thrashing the CPU, which leads to network
  # connectivity issues, we limit the parallelism here.
  extra_arguments "parallelism" {
    commands  = get_terraform_commands_that_need_parallelism()
    arguments = ["-parallelism=2"]
  }
}

include {
  path = find_in_parent_folders()
}

inputs = {
  # If you've already created an AWS Organization in your root account, you'll be able to import it later in this guide
  create_organization = true

  # The child AWS accounts to create in this AWS organization
  child_accounts = {
    logs = {
      email = "root-accounts+logs@chechia.net"

      # Mark this account as the logs account, used to aggregate all AWS Config and CloudTrail data.
      is_logs_account = true
    },
    security = {
      email = "root-accounts+security@chechia.net"
    },
    shared = {
      email = "root-accounts+shared@chechia.net"
    },
    dev = {
      email = "root-accounts+dev@chechia.net"
    },
    stage = {
      email = "root-accounts+stage@chechia.net"
    },
    prod = {
      email = "root-accounts+prod@chechia.net"
    },
    test = {
      email = "chechiachang999+terraform-test@gmail.com"
    }
    test-security = {
      email = "chechiachang999+terraform-test-security@gmail.com"
    }
  }

  # The IAM users to create in this account. Since this is the root account, you should only create IAM users for a
  # small handful of trusted admins.
  #
  # NOTE: Make sure to include the IAM user you created manually here! We'll import the user into Terraform state in
  # the next step of this guide, allowing you to manage this user as code going forward.
  users = {
    Administrator = {
      groups               = ["full-access"]
      pgp_key              = "keybase:chechiachang"
      create_login_profile = true
      create_access_keys   = true
    },
    Accounting = {
      groups               = ["billing"]
      pgp_key              = "keybase:chechiachang"
      create_login_profile = true
      create_access_keys   = false # accounting always use web console, won't use access key
    }
  }
}
