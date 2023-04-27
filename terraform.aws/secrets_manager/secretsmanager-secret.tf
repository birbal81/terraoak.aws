resource "aws_secretsmanager_secret" "sac_secrets_manager_insecure" {
  name                    = "sac-testing-secrets-manager-insecure"
  description             = "Default config2"
  recovery_window_in_days = 10 
}

resource "aws_secretsmanager_secret_policy" "sac_secrets_manager_policy" {
  secret_arn = aws_secretsmanager_secret.sac_secrets_manager_insecure.arn

  policy = <<POLICY
  # oak9: Secrets policy allows any action using * (wildcards)
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "EnableAnotherAWSAccountToReadTheSecret",
      "Effect": "Allow",
      "Principal": "*",
      "Action": "*",
      "Resource": "*"
    }
  ]
}
POLICY
}

resource "aws_kms_key" "sac_kms_key" {
  # oak9: Define tags to maintain a proper asset inventory. Organizational conventions require that each resource contains at least an environment tag to ensure that the assets are easily identifiable and accounted for.
  description             = "This key is used to encrypt dynamoDB objects"
  deletion_window_in_days = 10
  enable_key_rotation = false
  key_usage = "ENCRYPT_DECRYPT"
}