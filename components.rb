# frozen_string_literal: true

# components / https://www.notion.so/highereducation/components-9275cc38607d43bc85128af7a5627cfa
# This automatically registers all tags and blocks added to the _html/components directory. If the @styleguide tag is used then it'll build out a page: https://www.bestcolleges.com/styleguide/

module Jekyll
  # Custom Blocks Class ~ Extends Jekyll Liquid Blocks
  class CustomBlocks < Liquid::Block
    include Liquid::StandardFilters

    # Initialize
    def initialize(tag, markup, tokens)
      @template = Liquid::Template.parse(File.read(Dir.glob("_html/components/**/#{tag}.block").first))
      @markup   = markup
      @tag      = tag
      super
    end

    # Render Template with Properties
    def render(context)
      @template.render(get_properties(context, @tag, @markup, super))
    end
  end

  # Custom Tag Class ~ Extends Jekyll Liquid Tags
  class CustomTags < Liquid::Tag
    include Liquid::StandardFilters

    # Initialize
    def initialize(tag, markup, tokens)
      @template = Liquid::Template.parse(File.read(Dir.glob("_html/components/**/#{tag}.tag").first))
      @markup   = markup
      @tag      = tag
      super
    end

    # Render Template with Properties
    def render(context)
      @template.render(get_properties(context, @tag, @markup))
    end
  end
end

# Loop Components Directory For Tags/Blocks
Dir.glob('_html/components/**/*') do |file|
  ext = File.extname(file)

  if ext === '.tag' || ext === '.block'
    Liquid::Template.register_tag(File.basename(file, ext), ext === '.tag' ? Jekyll::CustomTags : Jekyll::CustomBlocks)
  end
end
