#######################################
# IAM Users + Access Keys (for_each)
#######################################

resource "aws_iam_user" "this" {
  for_each = var.iam_users

  name = each.value.name
  tags = merge(
    var.tags,
    try(each.value.tags, {})
  )
}

resource "aws_iam_access_key" "this" {
  for_each = aws_iam_user.this

  user = each.value.name
}

#######################################
# IAM Policies – shared docs
#######################################

# Producer – only send to job-processing-queue
data "aws_iam_policy_document" "producer_sqs" {
  statement {
    sid    = "SendJobsToProcessingQueue"
    effect = "Allow"
    actions = [
      "sqs:SendMessage",
      "sqs:GetQueueUrl",
      "sqs:GetQueueAttributes",
    ]

    resources = [
      # assumes queues["job_processing"] exists in the SQS part of the module
      aws_sqs_queue.this["job_processing"].arn,
    ]
  }
}

# Processor – read from processing, write to completed
data "aws_iam_policy_document" "processor_sqs" {
  # Receive from job-processing + DLQs
  statement {
    effect = "Allow"
    actions = [
      "sqs:ReceiveMessage",
      "sqs:DeleteMessage",
      "sqs:ChangeMessageVisibility",
      "sqs:GetQueueAttributes",
      "sqs:GetQueueUrl",
    ]

    resources = [
      aws_sqs_queue.this["job_processing"].arn,
      aws_sqs_queue.dlq["job_processing"].arn,
      aws_sqs_queue.dlq["job_completed"].arn,
    ]
  }

  # Send to job-completed
  statement {
    effect = "Allow"
    actions = [
      "sqs:SendMessage",
      "sqs:GetQueueAttributes",
      "sqs:GetQueueUrl",
    ]

    resources = [
      aws_sqs_queue.this["job_completed"].arn,
    ]
  }
}

#######################################
# IAM User Policies (for_each)
#######################################

resource "aws_iam_user_policy" "this" {
  for_each = var.iam_users

  name = "${each.key}-sqs-policy"
  user = aws_iam_user.this[each.key].name

  # Choose which policy document to attach based on user type
  policy = (
    each.value.type == "producer"
    ? data.aws_iam_policy_document.producer_sqs.json
    : data.aws_iam_policy_document.processor_sqs.json
  )
}
