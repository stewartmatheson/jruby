require File.dirname(__FILE__) + "/../spec_helper"

java_import "java.util.ArrayList"

describe "List Ruby extensions" do
  before(:each) do
    @data = ["foo", "quux", "bar", "aa"]
    @list = ArrayList.new(@data)
  end

  it "should support index() with one argument" do
    expect(@list.index("quux")).to eq(1)
  end

  it "should return nil on index() with one argument that does not exist" do
    expect(@list.index(451)).to eq(nil)
  end

  it "should support index() with a block" do
    expect(@list.index{|x| x == "bar" }).to eq(2)
  end

  it "should support index() with a block that does not exist" do
    expect(@list.index{|x| x == :nazgul }).to eq(nil)
  end

  it "should support index() with nil (not found)" do
    expect(@list.index(nil)).to eq(nil)
  end

  it "should support index() with nil (found)" do
    expect(ArrayList.new(["foo", "quux", nil, "bar", "aa"]).index(nil)).to eq(2)
  end

  it "should support index() with no arguments" do
    expect(@list.index.each {|x| x == "foo" }).to eq(0)
  end

  it "should support index() with no arguments (not existing)" do
    expect(@list.index.each {|x| x == ":-(" }).to eq(nil)
  end

  # Java 8 adds a single-parameter sort method to List that sorts in-place
  if ENV_JAVA['java.specification.version'] < '1.8'
    it "should be sortable with sort() without block" do
      expect(@list.sort.to_a).to eq(@data.sort)
    end

    it "should be sortable with sort() with block" do
      result = @list.sort do |a, b|
        a.length <=> b.length
      end

      expected = @data.sort do |a, b|
        a.length <=> b.length
      end

      expect(result.to_a).to eq(expected)
    end
  end

  it "should be sortable with sort!() without block" do
    list = ArrayList.new(@data)
    list.sort!
    expect(list.to_a).to eq(@data.sort)
  end

  it "should be sortable with sort!() with block" do
    list = ArrayList.new(@data)
    list.sort! do |a, b|
      a.length <=> b.length
    end

    expected = @data.sort do |a, b|
      a.length <=> b.length
    end

    expect(list.to_a).to eq(expected)
  end

  it "should support slicing with 2 arguments" do
    expect(@list[0,3].to_a).to eq(@data[0,3])
  end

  it "should support slicing with inclusive ranges" do
    expect(@list[0..3].to_a).to eq(@data[0..3])
  end

   it "should support slicing with exclusive ranges" do
    expect(@list[0...2].to_a).to eq(@data[0...2])
  end

  it "should respect to_ary objects defined on iteration" do
    class Pair
      def initialize(a, b)
        @a = a
        @b = b
      end

      def to_ary
        [@a, @b]
      end
    end

    ArrayList.new([Pair.new(:x, :y)]).each do |car, cdr|
      expect(car).to eq(:x)
      expect(cdr).to eq(:y)
    end
  end
end
