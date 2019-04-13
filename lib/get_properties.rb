# frozen_string_literal: true

# Get Static/Dynamic Properties
def get_properties(context, tag, markup, content = '')
  # Properties Attribute
  variables = {
    'content' => content,
    'site'    => !context['site'].nil? ? context['site'] : context.registers[:site].config,
    'layout'  => !context['layout'].nil? ? context['layout'] : {},
    'page'    => context['page']
  }

  # Tag variables from Page, Layout & Config
  tag_config = !variables['site'][tag].nil? ? variables['site'][tag] : {}
  tag_layout = !variables['layout'][tag].nil? ? variables['layout'][tag] : {}
  tag_page   = !variables['page'][tag].nil? ? variables['page'][tag] : {}
  tag_all    = tag_config.merge!(tag_layout).merge!(tag_page)

  tag_all.each { |key, value| value = parse_value(value); variables[key] = value unless value.nil? } unless tag_all.empty?

  # Variables from Context
  properties = markup.gsub(/\:\"(.*?)\"\s+/, ' ').gsub(/\:\'(.*?)\'\s+/, ' ').gsub(/\:(.*?)\s+/, ' ').to_s
  properties.split(' ').each { |key| value = parse_value(context[key]); variables[key] = value unless value.nil? }

  # Variables from Tag
  markup.scan(Liquid::TagAttributes) { |key, value| value = parse_value(value); variables[key] = value unless value.nil? }

  # Return Variables
  variables
end
