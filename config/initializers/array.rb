class Array
  def to_ordinalized_collection_sentence(options = {})
    self.map { |n| n.to_i == -1 ? 'last' : n.to_i.ordinalize }.to_sentence(options) # TODO: Fix for yearly rule. returns 'last february' instead of 'last day of february'
  end
end
