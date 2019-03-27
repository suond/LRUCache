require_relative 'p05_hash_map'
require_relative 'p04_linked_list'

class LRUCache
  attr_reader :map, :store, :max
  def initialize(max, prc)
    @map = HashMap.new
    @store = LinkedList.new
    @max = max
    @prc = prc
  end

  def count
    @map.count
  end

  def get(key)
    if @map.include?(key)
      linkedlist = @map.get(key)
      update_node!(linkedlist)
    elsif @map.count >= @max
      eject!
      calc!(key)
    else
      calc!(key)
    end
  end

  def to_s
    'Map: ' + @map.to_s + '\\n' + 'Store: ' + @store.to_s
  end

  def eject!
    lru = @store.first
    @store.remove(lru.key)
    @map.delete(lru.key)
  end
  private

  def calc!(key)
    # suggested helper method; insert an (un-cached) key
    hashed_key = @prc.call(key)
    @store.append(key, hashed_key)
    @map.set(key, @store.last)
    hashed_key
  end

  def update_node!(node)
    # suggested helper method; move a node to the end of the list
    @store.remove(node.key)
    @store.append(node.key, node.val)
    @map.set(node.key,@store.last)
  end

end
