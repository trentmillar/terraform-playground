data "aws_iam_policy_document" "service_link" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["backup.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "service_role" {
  name               = "example"
  assume_role_policy = data.aws_iam_policy_document.service_link.json
}

resource "aws_iam_role_policy_attachment" "service_role_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForBackup"
  role       = aws_iam_role.service_role.name
}

## daily Plan

resource "aws_backup_vault" "daily" {
  name = "daily"
}

resource "aws_backup_plan" "daily" {
  name = "daily"

  rule {
    rule_name         = "daily"
    target_vault_name = aws_backup_vault.daily.name
    schedule          = "cron(55 * * * ? *)"

    lifecycle {
      delete_after = 7
    }
  }
}

resource "aws_backup_selection" "daily" {
  iam_role_arn = /* "arn:aws:iam::${data.aws_caller_identity.current_identity.account_id}:role/service-role/AWSBackupDefaultServiceRole" */ aws_iam_role.service_role.arn
  name         = "daily"
  plan_id      = aws_backup_plan.daily.id

  selection_tag {
    type  = "STRINGEQUALS"
    key   = "backup-policy"
    value = "daily"
  }
}

# Quarterly Plan

/* resource "aws_backup_vault" "quarterly" {
  name = "quarterly"
}

resource "aws_backup_plan" "quarterly" {
  name = "quarterly"

  rule {
    rule_name         = "quarterly"
    target_vault_name = aws_backup_vault.quarterly.name
    schedule          = "cron(0 0 L 3,6,9,12 * *)"

    lifecycle {
      cold_storage_after = 365
    }
  }
}

resource "aws_backup_selection" "quarterly" {
  iam_role_arn = aws_iam_role.service_role.arn
  name         = "quarterly"
  plan_id      = aws_backup_plan.quarterly.id

  selection_tag {
    type  = "STRINGEQUALS"
    key   = "BackupQuarterly"
    value = "true"
  }
} */