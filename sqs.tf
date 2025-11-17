#######################################
# SQS Main Queues
#######################################

resource "aws_sqs_queue" "this" {
  for_each = var.queues

  name = each.value.name

  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.dlq[each.key].arn
    maxReceiveCount     = try(each.value.max_receive_count, 5)
  })

  tags = merge(
    var.tags,
    try(each.value.tags, {})
  )
}

#######################################
# SQS Dead-Letter Queues
#######################################

resource "aws_sqs_queue" "dlq" {
  for_each = var.queues

  name = each.value.dlq_name

  tags = merge(
    var.tags,
    try(each.value.dlq_tags, {})
  )
}



