variable "artifact_file" {
  type        = string
  description = "The path to the function's deployment package within the local filesystem"
  default     = null
}

variable "handler" {
  type        = string
  description = "The function entrypoint in the code."
  default     = "index.handler"
}

variable "memory_size" {
  type        = number
  description = "Amount of memory in MB your Lambda Function can use at runtime."
  default     = 128
}

variable "timeout" {
  type        = number
  description = "The amount of time your Lambda Function has to run in seconds."
  default     = 6
}

variable "description" {
  type        = string
  description = "Description of what the Lambda Function does."
  default     = null
}

variable "environment" {
  type        = map(string)
  description = "The Lambda environment's configuration settings."
  default     = {}
}

variable "cwl_retention_days" {
  type        = number
  description = "The retention time in days for the CloudWatch Logs Stream."
  default     = 30
}

variable "tags" {
  description = "A mapping of tags to assign to the module resources."
  type        = map(string)
  default     = {}
}

variable "name" {
  type        = string
  description = "A unique name for the Lambda Function."
}

variable "runtime" {
  type        = string
  description = "The Runtime used in the Lambda Function."
}
