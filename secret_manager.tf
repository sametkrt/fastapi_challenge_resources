resource "aws_secretsmanager_secret" "this" {
  for_each = var.create_iam_secrets ? aws_iam_user.this : {}
  
  name = "${each.value.name}-creds"
  tags = merge(
    var.tags,
    try(var.iam_users[each.key].tags, {})
  )
}

resource "aws_secretsmanager_secret_version" "this" {
  for_each = aws_secretsmanager_secret.this
  
  secret_id = each.value.id
  secret_string = jsonencode({
    access_key = aws_iam_access_key.this[each.key].id
    secret_key = aws_iam_access_key.this[each.key].secret
  })
}
