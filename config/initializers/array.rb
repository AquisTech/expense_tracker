class Array
  def to_ordinalized_collection_sentence(options = {})
    self.map { |n| n == -1 ? 'last' : n.ordinalize }.to_sentence(options)
  end
end
