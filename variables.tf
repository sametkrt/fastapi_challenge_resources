variable "iam_users" {
  description = "Map of IAM users to create."
  type = map(object({
    name = string
    type = string 
    tags = optional(map(string))
  }))
}

variable "create_iam_secrets" {
  description = "Whether to create a Secrets Manager secret for each IAM user."
  type        = bool
  default     = true
}

variable "job_processing_queue_name" {
  description = "Name of the job-processing SQS queue."
  type        = string
  default     = "job-processing-queue"
}

variable "job_processing_dlq_name" {
  description = "Name of the dead-letter queue for the job-processing SQS queue."
  type        = string
  default     = "job-processing-dlq"
}

variable "job_completed_queue_name" {
  description = "Name of the job-completed SQS queue."
  type        = string
  default     = "job-completed-queue"
}

variable "job_completed_dlq_name" {
  description = "Name of the dead-letter queue for the job-completed SQS queue."
  type        = string
  default     = "job-completed-dlq"
}

variable "job_processing_max_receive_count" {
  description = "Max receive count for the job-processing queue before messages go to its DLQ."
  type        = number
  default     = 5
}

variable "job_completed_max_receive_count" {
  description = "Max receive count for the job-completed queue before messages go to its DLQ."
  type        = number
  default     = 5
}

variable "queues" {
  description = "Map of SQS queues to create"
  type = map(object({
    name              = string
    dlq_name          = string
    max_receive_count = optional(number)
    tags              = optional(map(string))
    dlq_tags          = optional(map(string))
  }))
}

variable "tags" {
  description = "Common tags applied to all queues."
  type        = map(string)
  default     = {}
}

