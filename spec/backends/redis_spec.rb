require "spec_helper"

describe CB2::RollingWindow do
  let(:backend) do
    CB2::Backends::Redis.new(:redis => redis)
  end

  let(:redis) { Redis.new }

  describe "#delete" do
    it "deletes a key" do
      redis.set("foo", true)
      assert redis.get("foo")
      backend.delete("foo")
      assert redis.get("foo").nil?
    end
  end

  describe "#set" do
    it "sets a key" do
      backend.set("foo", "bar")
      assert_equal "bar", redis.get("foo")
    end
  end

  describe "#get" do
    it "gets a key" do
      redis.set("foo", "bar")
      assert_equal "bar", backend.get("foo")
    end
  end

  describe "#count" do
    it "counts a key" do
      redis.zadd("foo", 1, "bar")
      redis.zadd("foo", 2, "baz")
      assert_equal 2, backend.count("foo")
    end
  end

  describe "#remove_range" do
    it "removes all and down" do
      redis.zadd("foo", 1, "bar")
      redis.zadd("foo", 2, "baz")
      redis.zadd("foo", 3, "biz")
      backend.remove_range("foo", nil, 2)
      assert_equal 1, backend.count("foo")
    end

    it "removes a mid-range" do
      redis.zadd("foo", 1, "bar")
      redis.zadd("foo", 2, "baz")
      redis.zadd("foo", 3, "biz")
      redis.zadd("foo", 4, "fiz")
      backend.remove_range("foo", 2, 3)
      assert_equal 2, backend.count("foo")
    end
  end

  describe "#add_to_weighted_set" do
    it "adds to a set" do
      backend.add_to_weighted_set("foo", 1, "bar")
      assert_equal 1, backend.count("foo")
    end
  end

  describe "#atomic" do
    it "does a set of operations and returns the last" do
      ret = backend.atomic do
        backend.add_to_weighted_set("foo", 1, "bar")
        backend.remove_range("foo", nil, 1)
        backend.add_to_weighted_set("foo", 1, "bar")
        backend.count("foo")
      end
      assert_equal 1, ret
    end
  end
end
