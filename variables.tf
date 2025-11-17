variable "iam_users" {
  description = "Map of IAM users to create."
  type = map(object({
    name        = string
    policy_json = string
    policy_name = optional(string)
    tags        = optional(map(string))
  }))
  default = {}
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
  default = {}
}

variable "create_iam_secrets" {
  description = "Whether to create a Secrets Manager secret for each IAM user."
  type        = bool
  default     = true
}

variable "tags" {
  description = "Common tags applied to all resources."
  type        = map(string)
  default     = {}
}
