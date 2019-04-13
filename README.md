# components

This automatically registers all tags and blocks added to the _html/components directory. If the [styleguide](https://www.notion.so/9614bcf6-e335-4bca-a1eb-b160938ded85) tag is used then it'll build out a page: [https://www.bestcolleges.com/styleguide/](https://www.bestcolleges.com/styleguide/)

### Requirements

Each component in the `_html/components` directory must follow suit:

- Must be in the `_html/components` directory.
- Name must be suffixed with `.tag` or `.block`. Differences between block and tag are, tags don't have content region where blocks do.
- Component must have docblock with following data:
    - `Title`
    - `Example` can also have alternative examples, Example_1, Example_2, ..., Example_5
    - `Properties`
    - Any additional properties you add, will be added to the styleguide.

### Doc Block Header

    {% comment %}
    Title: Title
    Markup: {% this attribute:"" %}
    Example: {% this attribute:" %}
    Properties: <ul><li>attribute <i>required.<i></li></ul>
    {% endcomment %}

### Context Inheritance

By adding a new tag or block to the html/components directory, the component gives you property inheritance throughout the site. For example, if you created a tag called **brians_magnificent_slider** you can now declare global defaults, layout defaults, page defaults, as well as component specific data.

**Config ~ Global Defaults**

    brians_magnificent_slider:
      background: green
      title: "Get your Slide On"

**Layout Frontmatter > Config**

    ---
    brians_magnificent_slider:
      title: "Get your Slide On in this Unique Layout"
    ---

**Page Frontmatter > Layout Frontmatter**

    ---
    brians_magnificent_slider:
      background: red
      title: "Get your Slide On in this Unique Page"
    ---

**Page Content**

    {% brians_magnificent_slider title:"Check out my Slider!" other_attributes... %}

## Example

---

### Block: expert.block

    {% comment %}
    Title: Experts
    Markup: {% this title:"" class:"" %}content{% endthis %}
    Example: {% this title:"Example Title" class:"example-class" %}Some Dummy Content{% endthis %}
    Properties: <ul><li>title</li><li>class</li><li>content <i>required.</i></li></ul>
    Instructions: Some instructions, maybe?
    {% endcomment %}
    
    {% if content %}
    	<section class="experts {{ class }}">
    		{% if title %}<h1>{{ title }}</h1>{% endif %}
        {{ content }}
    	</section>
    {% endif %}

### Input

    Check out this: 
    
    {% expert title:"Brian McCoy" class:"background-green" }
    	<p>Brian loves walks on the beach, puppies, and counting the stars.</p>
    {% endexpert %}

### Output

    Check out this: 
    
    <section class="experts background-green">
    	<h1>Brian McCoy</h1>
    	<p>Brian loves walks on the beach, puppies, and counting the stars.</p>
    </section>

### Tag: icon.tag

    {% comment %}
    Title: Tag
    Markup: {% this title:"" class:"" src:"" %}
    Example: {% this title:"Example Title" class:"example-class" src:"" %}
    Properties: <ul><li>title</li><li>class</li><li>src <i>required.</i></li></ul>
    {% endcomment %}
    
    {% if src %}
    	<img src="{{ src }}" alt="{{ title }}" class="{{ class }}" />
    {% endif %}

### Input

    Check out this: 
    
    {% icon title:"Brian McCoy" class:"background-green" src:"/assets/img/icon.png" }

### Output

    Check out this: 
    
    <img src="/assets/img/icon.png" alt="Brian McCoy" class="background-green" />
