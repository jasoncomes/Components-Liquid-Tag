# frozen_string_literal: true

# Is Number Method
def is_number?(string)
  true if Float(string)
rescue StandardError
  false
end
