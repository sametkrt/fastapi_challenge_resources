output "queue_urls" {
  value = {
    for k, q in aws_sqs_queue.this : k => q.id
  }
}

output "queue_arns" {
  value = {
    for k, q in aws_sqs_queue.this : k => q.arn
  }
}

output "dlq_urls" {
  value = {
    for k, q in aws_sqs_queue.dlq : k => q.id
  }
}

output "dlq_arns" {
  value = {
    for k, q in aws_sqs_queue.dlq : k => q.arn
  }
}

output "iam_access_keys" {
  value = {
    for k, v in aws_iam_access_key.this : k => {
      access_key_id     = v.id
      secret_access_key = v.secret
    }
  }

  sensitive = true
}

output "iam_secret_arns" {
  value = {
    for k, v in aws_secretsmanager_secret.this : k => v.arn
  }
}
