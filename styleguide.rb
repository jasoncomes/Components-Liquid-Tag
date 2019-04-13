# frozen_string_literal: true

# styleguide / https://github.com/jasoncomes/Components-Liquid-Tag
# Collects all properties and content from each component within _html/components and creates a stylized output at /styleguide based on each components potential properties and content, ie: Title Example Properties Usage Instructions
# {% styleguide %}

module Jekyll
  class Styleguide < Liquid::Tag
    Syntax = /(#{Liquid::QuotedFragment}+)?/

    # Escape HTML
    def escape_html(string)
      string.gsub('&', '&amp;').gsub('%}', '&#37;&#125;').gsub('{%', '&#123;&#37;').gsub('>', '&#62;').gsub('<', '&#60;').gsub('"', '&#34;').gsub("'", '&#39;')
    end

    # Escape HTML
    def new_lines(string)
      string.gsub('&#37;&#125;&#123;&#37;', '&#37;&#125;<br />&#123;&#37;').gsub('&#62;&#60;', '&#62;<br />&#60;').gsub('&#62;&#123;&#37;', '&#62;<br />&#123;&#37;').gsub('&#37;&#125;&#60;', '&#37;&#125;<br />&#60;')
    end

    # Get Markup
    def get_markup(component)
      # Bail if no title
      return if component['markup'].nil? || component['title'].nil? || component['title'].empty?

      # HTML
      html  = "<div class=\"component #{component['ext'].delete('.')}-#{component['base']}\">" # Container
      html += "<h3 id=\"#{component['base']}\">#{component['title']}<a href=\"\##{component['base']}\"><sup>&#9875;</sup></a></h3>" # Title

      # Examples
      if !component['example'].nil? || !component['example_1'].nil?
        count = 0
        html += '<h5 class="title">Example</h5>'
        html += '<div class="property example">'

        loop do
          example = count === 0 ? 'example' : 'example_' + count.to_s
          count  += 1
          break if component[example].nil? || (count == 6)

          html += component['ext'] === '.snippet' ? component[example] : component[example].gsub('this', component['base'])
          component.delete(example)
        end

        html += '</div>'
      end

      # Markup
      unless component['markup'].nil?
        markup = component['ext'] === '.snippet' ? escape_html(component['markup']) : new_lines(escape_html(component['markup'].gsub('this', component['base'])))
        html += "<h5 class=\"title\">Markup</h5><code class=\"property\"><pre class=\"code\">#{markup}<button class=\"clipboard js-clipboard\">Copy</button></pre></code>"
        html += "<div class=\"clipboard-area\"><textarea>#{markup.gsub('<br />', '&#13;')}</textarea></div>"
      end

      # Additional Properties
      component.each do |property, value|
        # Exclude Properties
        next if %w[base title markup example ext].include? property

        html += case property
                when 'ext'
                  "<h5 class=\"title\">Type</h5>#{value.slice(1..-1).capitalize}"
                else
                  "<h5 class=\"title\">#{property.capitalize}</h5><div class=\"property #{property.downcase}\">#{value}</div>"
                end
      end

      html += '</div>'

      html
    end

    # Get Shortcodes HTML
    def get_shortcodes_html
      html       = ''
      components = Dir.glob('_html/components/**/*').sort

      # Return if Component Nil or Empty
      return html if components.nil? || components.empty?

      # Shortcodes Glob Loop
      components.each do |file|
        # Variables
        component         = {}
        component['ext']  = File.extname(file)
        component['base'] = File.basename(file, component['ext'])

        # Folder Names
        if File.directory?(file)
          html += "<h2 class=\"header\" id=\"#{component['base']}\">#{component['base'].capitalize}<a href=\"\##{component['base']}\"><sup>&#9875;</sup></a></h2>"
          next
        end

        # Read markup
        markup = File.read(file)

        next unless Syntax.match?(markup)

        # Snippet properties
        if component['ext'] === '.snippet'
          snippet             = markup.split('{% endcomment %}')[-1].gsub /^$\n/, ''
          component['markup'] = snippet.to_s
        end

        markup.scan(/\{% comment %\}(.*?)\{% endcomment %\}/m).each do |comment|
          comment = !comment.first.nil? && !comment.first.empty? ? comment.first : nil

          # Return if no comment
          next if comment.nil?

          # Loop through comment properties
          comment.each_line do |line|
            property, value = line.split(': ', 2)

            # Return if property empty
            next if property.nil? || value.nil?

            # Variables
            property            = property.tr("\r", ' ').tr("\n", ' ').squeeze(' ').strip.downcase.to_s
            value               = value.tr("\r", ' ').tr("\n", ' ').squeeze(' ').strip.to_s
            component[property] = value
          end
        end

        if !component.nil? && component.is_a?(Hash)
          html += get_markup(component).to_s
        end

        # markup syntax end
      end

      html
    end

    # Render
    def render(context)
      Liquid::Template.parse(get_shortcodes_html).render(context)
    end
  end
end

Liquid::Template.register_tag('styleguide', Jekyll::Styleguide)
