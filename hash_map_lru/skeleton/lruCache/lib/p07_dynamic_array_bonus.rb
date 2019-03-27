require 'byebug'

class StaticArray
  attr_reader :store

  def initialize(capacity)
    @store = Array.new(capacity)
  end

  def [](i)
    validate!(i)
    self.store[i]
  end

  def []=(i, val)
    validate!(i)
    self.store[i] = val
  end

  def length
    self.store.length
  end

  private

  def validate!(i)
    raise "Overflow error" unless i.between?(0, self.store.length - 1)
  end
end

class DynamicArray
  attr_accessor :count

  include Enumerable

  def initialize(capacity = 8)
    @store = StaticArray.new(capacity)
    @count = 0
  end

  def [](i)
    # debugger
    return nil if i >= count
    return @store[i] if i > 0
    offset = i + 1
    return nil if offset.abs >= count
    dup = count
    while @store[dup].nil?
      dup -= 1  
    end
    if i < 0
      return @store[dup + offset]
    end
  end

  def []=(i, val)
    @store[i] = val if i > 0
    while i > @count
      push(nil)
    end
    
    offset = i + 1
    dup = count
    while @store[dup].nil?
      dup -= 1
    end
    if i < 0
      @store[dup + offset] = val
    end
  end

  def capacity
    @store.length
  end

  def include?(val)
    each do |ele|
      return true if ele == val
    end
    false
  end

  def push(val)
    resize! if count >= capacity
    @store[count] = val
    @count += 1
  end

  def unshift(val)
    
    (@count-1).downto(0).each do |idx|
      current = @store[idx]
      @store[idx + 1] = current
    end
    @store[0] = val
    @count += 1
    resize! if @count >= capacity
  end

  def pop
    return nil if @count == 0
    @count -= 1
    to_return = @store[@count]
    @store[@count] = nil
    to_return
  end

  def shift
    return nil if @count == 0
    return nil if @store[0] == nil
    to_return = first
    (0...@count).each do |idx|
      current = @store[idx+1]
      @store[idx] = current
    end
     @count -= 1
     to_return
  end

  def first
    @store[0]
  end

  def last
    @store[@count - 1]
  end

  def each(&prc)
    (0...@count).each do |idx|
      prc.call(@store[idx])
    end
  end

  def to_s
    "[" + inject([]) { |acc, el| acc << el }.join(", ") + "]"
  end

  def ==(other)
    return false unless [Array, DynamicArray].include?(other.class)
    # ...[0,1] [1,0]
    other.each_with_index do |val,idx|
       return false if self[idx] != val
    end
    true
  end

  alias_method :<<, :push
  [:length, :size].each { |method| alias_method method, :count }

  private

  def resize!
    new_store = StaticArray.new(capacity * 2)
    (0...@count).each do |idx|
      new_store[idx] = @store[idx]
    end
    @store = new_store
  end
end
