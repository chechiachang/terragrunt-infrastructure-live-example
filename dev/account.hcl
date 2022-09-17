locals {
  # TODO: Update with the actual information of each account
  # The user friendly name of the AWS account. Usually matches the folder name.
  account_name = basename(get_terragrunt_dir())
  # The 12 digit ID number of your AWS account.
  account_id = ""
}
