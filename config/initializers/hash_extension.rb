class Hash
  def pretty_indent
    s = "{\n"
    level = 0
    self.each do |k, v|
      level += 1
      s += ('  ' * level) + k.inspect + ' => '
      if !v.is_a?(Array) || !v.is_a?(Hash)
        s += v.inspect
      elsif v.is_a?(Array) && (!v.all?(Array) || !v.all?(Hash))
        s += v.inspect
      else
        s += v.pretty_indent
      end
      s += "\n"
    end
    s += '}'
  end
end