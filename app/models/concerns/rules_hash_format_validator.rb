class RulesHashFormatValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless valid_rules_hash_format?(record, value)
      record.errors.add(attribute, "are invalid for #{record.type} recurrence.")
    end
  end

  def valid_rules_hash_format?(record, rules_hash)
    return rules_hash.blank? if record.daily?
    return false if rules_hash.blank?
    valid_rule = case record.type
    when 'Weekly'
      rules_hash.is_a?(Array)
    when 'Monthly'
      (rules_hash.is_a?(Array) || (rules_hash.is_a?(Hash) && rules_hash.values.all? {|v| v.is_a?(Array) }))
    when 'Yearly'
      rules_hash.is_a?(Hash) && ((rules_hash.values.all? {|v| v.is_a?(Array) }) || (rules_hash.values.all? {|value_hash| value_hash.is_a?(Hash) && value_hash.values.all? {|v| v.is_a?(Array)} }))
    else
      false
    end
    valid_rule
  end
end