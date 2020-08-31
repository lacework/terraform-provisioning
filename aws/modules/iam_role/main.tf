resource "random_string" "external_id" {
  length           = var.external_id_length
  override_special = "=,.@:/-"
}

data "aws_iam_policy_document" "lacework_assume_role_policy" {
  version = "2012-10-17"
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${var.lacework_aws_account_id}:root"]
    }

    condition {
      test     = "StringEquals"
      variable = "sts:ExternalId"
      values   = [random_string.external_id.result]
    }
  }
}

resource "aws_iam_role" "lacework_iam_role" {
  count              = var.create ? 1 : 0
  name               = var.iam_role_name
  assume_role_policy = data.aws_iam_policy_document.lacework_assume_role_policy.json
}

# wait for X seconds for the role to be created before trying to query it
resource "time_sleep" "wait_time" {
  create_duration = var.wait_time
  depends_on      = [aws_iam_role.lacework_iam_role]
}

# we use this data source to access the ARN of the generated IAM Role,
# or the provided IAM Role name if the user decides not to create it
data "aws_iam_role" "selected" {
  name       = var.iam_role_name
  depends_on = [time_sleep.wait_time]
}
