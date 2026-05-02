# Lab 4: IAM (Users, Groups, Policies)
# Цель: Управление доступом в AWS
# Отличие: Работа не с инфраструктурой (серверами), а с правами доступа и пользователями

# =============================================================================
# LOCALS
# =============================================================================

locals {
  common_tags = {
    Lab       = "lab4-iam"
    ManagedBy = "Terraform"
  }
}

# =============================================================================
# IAM GROUPS
# =============================================================================

resource "aws_iam_group" "developers" {
  name = "lab4-developers"
  path = "/lab4/"
}

resource "aws_iam_group" "analysts" {
  name = "lab4-analysts"
  path = "/lab4/"
}

resource "aws_iam_group" "admins" {
  name = "lab4-admins"
  path = "/lab4/"
}

# =============================================================================
# IAM USERS (с использованием count)
# =============================================================================

resource "aws_iam_user" "users" {
  count = length(var.users)

  name = "lab4-${var.users[count.index]}"
  path = "/lab4/"

  tags = local.common_tags
}

# =============================================================================
# POLICY DOCUMENTS (data source)
# =============================================================================

data "aws_iam_policy_document" "developer_policy" {
  statement {
    sid    = "DeveloperEC2Access"
    effect = "Allow"

    actions = [
      "ec2:DescribeInstances",
      "ec2:DescribeInstanceStatus",
      "ec2:DescribeInstanceAttribute",
      "ec2:DescribeTags",
    ]

    resources = ["*"]
  }

  statement {
    sid    = "DeveloperS3ReadOnly"
    effect = "Allow"

    actions = [
      "s3:GetObject",
      "s3:ListBucket",
    ]

    resources = [
      "arn:aws:s3:::lab4-*",
      "arn:aws:s3:::lab4-*/*",
    ]
  }
}

data "aws_iam_policy_document" "analyst_policy" {
  statement {
    sid    = "AnalystReadOnly"
    effect = "Allow"

    actions = [
      "cloudwatch:GetMetricData",
      "cloudwatch:ListMetrics",
      "logs:DescribeLogGroups",
      "logs:FilterLogEvents",
    ]

    resources = ["*"]
  }
}

# =============================================================================
# IAM POLICIES
# =============================================================================

resource "aws_iam_policy" "developer_policy" {
  name        = "lab4-developer-policy"
  description = "Policy для разработчиков - доступ к EC2 и S3 (readonly)"
  policy      = data.aws_iam_policy_document.developer_policy.json

  tags = local.common_tags
}

resource "aws_iam_policy" "analyst_policy" {
  name        = "lab4-analyst-policy"
  description = "Policy для аналитиков - доступ к CloudWatch и Logs"
  policy      = data.aws_iam_policy_document.analyst_policy.json

  tags = local.common_tags
}

# =============================================================================
# POLICY ATTACHMENTS TO GROUPS
# =============================================================================

resource "aws_iam_group_policy_attachment" "developers_attach" {
  group      = aws_iam_group.developers.name
  policy_arn = aws_iam_policy.developer_policy.arn
}

resource "aws_iam_group_policy_attachment" "analysts_attach" {
  group      = aws_iam_group.analysts.name
  policy_arn = aws_iam_policy.analyst_policy.arn
}

# Attach ReadOnlyAccess policy to analysts group (AWS managed policy)
resource "aws_iam_group_policy_attachment" "analysts_readonly" {
  group      = aws_iam_group.analysts.name
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

# =============================================================================
# USERS GROUP MEMBERSHIP
# =============================================================================

# First two users go to developers group
resource "aws_iam_user_group_membership" "dev_membership" {
  count = min(2, length(var.users))

  user   = aws_iam_user.users[count.index].name
  groups = [aws_iam_group.developers.name]
}

# Third user goes to analysts group (if exists)
resource "aws_iam_user_group_membership" "analyst_membership" {
  count = length(var.users) >= 3 ? 1 : 0

  user   = aws_iam_user.users[2].name
  groups = [aws_iam_group.analysts.name]
}
