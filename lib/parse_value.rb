# frozen_string_literal: true

require 'yaml'

# Method: Parse Values
def parse_value(data)
  # Remove surrounding quotes & spaces
  value = data.to_s.gsub(/^('|")/, '').gsub(/('|")$/, '').strip

  # If empty, make nil
  return nil if value.empty?

  # Convert string to array or object
  return YAML.safe_load(value) if value.start_with?('[', '{') && value.end_with?(']', '}')

  # Convert string true to boolean true
  return true if (value == 'true') || (value == 'TRUE')

  # Convert string false to boolean false
  return false if (value == 'false') || (value == 'FALSE')

  # Convert number to floating or integer
  if is_number?(value) && value.scan(/^0/).empty?
    return value.to_f if value.include?('.') || value.include?(',')

    return value.to_i
  end

  # Return Value
  value
end
