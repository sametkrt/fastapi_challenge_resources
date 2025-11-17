resource "aws_iam_user" "this" {
  for_each = var.iam_users

  name = "${each.value.name}-sqs-user-${data.aws_region.this.region}"
  tags = merge(
    var.tags,
    try(each.value.tags, {})
  )
}

resource "aws_iam_access_key" "this" {
  for_each = aws_iam_user.this

  user = each.value.name
}

resource "aws_iam_user_policy" "this" {
  for_each = var.iam_users

  name   = coalesce(each.value.policy_name, "${each.key}-sqs-policy-${data.aws_region.this.region}")
  user   = aws_iam_user.this[each.key].name
  policy = each.value.policy_json
}
