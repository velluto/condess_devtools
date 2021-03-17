# Devtools Overview

# Template Development

## Overview

## How The System Functions

Fundamentally the Condess System works like a standard web server.  It can serve static files, but it is primarily designed to serve dynamic content through arbitrary templates.

All requests funnel through a master script which decides how to process the request.  This is fully transparent to both the developer and the user visiting the website.

The master script provides access to relevent request variables for use throughout the rendering process.

Our template system is based on Twig.

## Primary Template Directories

We require four standard directories to be present in each template:

- __twig/handlers
- __twig/layouts
- __twig/sections
- __twig/components

The system requires that these directories be present in the template for proper rendering.  Not including them may result in unpredictable errors.

### Search Order

The system will search for template files in a specific order.  It's best to avoid name collisions no matter what, and it is entirely possible to end up with circular references if you aren't careful.

The system will search the following directories in order:

- __twig/handlers
- __twig/layouts
- __twig/sections
- __twig/components
- __twig

When referencing any template you can either use the full path from the `__twig` folder OR the relative path under the directory it's in.

For example, if I have a template in `__twig/components/_sidebar_image.twig` then I can reference it as `components/_sidebar_image.twig` or `_sidebar_image.twig` and the system will locate it.

### Handlers

When processing a request, the `handler` is the starting point.  Handlers are located in `__twig/handlers`.  Each handler must be named the same as the request action and must end with the `.twig` file extension.

For example, if a user requests `https://mywebsite.com/story/4938` the handler used is `story.twig`

This is going to be the starting point for any request.

Example Handler:

```twig
{% extends "base_1.twig" %}

{% block handler_content %}
    {{ include('_news_1.twig') }}
    {{ include('_gallery.twig') }}
    {{ include('_news_3.twig') }}
{% endblock %}
```

### Layouts

Layouts are generic building blocks that are used in handlers, sections, and components.  They can not be customized through the backend dashboard.

In the handler example, `_news_1.twig`, `_gallery.twig`, and `_news_3.twig` are different sections.

Generally speaking you will want to put your base template in this directory (usually called `base.twig`) which is then used as a baseline for other layouts.

This is particularly suitable for setting up specific layouts for different purposes.  One common example is to provide a layout for any static content:

`__twig/layouts/static.twig`

```twig
{% block meta_tags %}
    <meta name="robots" content="noindex, noimageindex" />
{% endblock %}


{% extends "base.twig" %}

{% block content %}
<div class="main-content--section pbottom--30">
    <div class="container">
        <div class="row">
        {% block static_content %}
        {% endblock %}
        </div>
    </div>
</div>
{% endblock %}
```

Using that can be as simple as adding a new handler with the end point (say for `https://mywebsite.com/privacy_policy`) in:

`__twig/handlers/privacy_policy.twig`
```twig
{% extends "static.twig" %}

{% block static_content %}
    Content Goes here
{% endblock %}
```

We also put layouts in here that are used as building blocks in sections and components.  Basically, if you use it more than once in a component, you should turn it into a layout.  By convention, these building block layouts are prepended with an _ to make it clear that they are a partial template.


`__twig/layouts/_content_block_5.twig`
```twig
<div class="mv-item">
    {% for article in content %}
    <div class="mv-box d-flex">
        <div class="mv-img">
            <a href="{{article.href}}"><img src="{{ article.image_links.small_100 }}" alt=""></a>
        </div>
        <div class="img-content">
            <p><a href="{{article.href}}">{{article.title  | truncate(120)}}</a></p>
            <span>{{article.formatted_date}}</span>
        </div>
    </div>
    {% endfor %}
</div>
```


### Sections

Sections are used in handlers as 'major building blocks' ... you can use whatever abstraction you like. Sections are located in `__twig/sections` and must end with the `.twig` file extension.  They can contain components and static content.  Think logo blocks, headers, footers, menus, etc

Sections are customized per template layout in the backend dashboard.

Example:
`__twig/sections/_footer_bottom.twig`
```twig
<section class="footer-btm">
    <div class="container">
        <div class="row">
            {% for snippet in site_config.snippets.footer_bottom %}
            <div class="col-md-6">
                {% include "#{snippet.filesystem_location}.twig" with {'snippet': snippet} %}
            </div>
            {% endfor %}
        </div>
    </div>
    <div class="back-to-top text-center">
        <a data-scroll href="#btt"><i class="fa fa-angle-up"></i></a>
    </div>
</section>
```

The key part there is the Twig `for` loop that iterates over the available components for that section:

`{% for snippet in site_config.snippets.footer_bottom %}`


### Components

These are the 'Lego Bricks' of the system.  You use these template partials when constructing sections dynamically.  Components are located in `__twig/components` and must end with the `.twig` file extension.  They can reference other components, layouts, and any custom template partials.  

All Components are automatically included in the backend and available to be added to sections.

Components can be complicated or simple. This component simply includes custom text provided by the backend (Note that this will parse the string as a template, letting you use template tags via the backend):

```twig
<div class=" {{ mobile_only }} {{ hide_on_mobile }}">
    {{include(template_from_string(snippet.options.template ?? snippet.options.custom_content ?? snippet.options.content, 'T3-front-half-width'))}}
</div>
```

On the flip side, this component is more complicated and will display a list of links provided by the backend:

```twig
<div class="col-md-3 col-xs-6 col-xxs-12 ptop--30 pbottom--30">
    <div class="widget">
        <div class="widget--title">
            <h2 class="h4">{{ snippet.options.header_string }}</h2>
        </div>

        <div class="links--widget">
            <ul class="nav">
                <li><a href="/" class="fa-angle-right">{{ site_config.strings.ts_home_link}}</a></li>
                {% for category_id in snippet.options.category_ids %}
                <li><a href={{"/category/#{category_id}"}} class="fa-angle-right">{{ category_data(category_id).anchor }}</a></li>
                {% endfor %}
            </ul>
        </div>
    </div>
</div>
```

See the sample templates for more details on this.

### Additional Directories

You can use subdirectories to organize any of the main directories, as long as you use that path when referencing the template partial.  For example, if you want to reference `__twig/components/post/_post_header.twig` then you would reference it with `post/_post_header.twig`

You can also add new subdirectories to the `__twig` directory, but they will not be in the search path so you'll have to reference them directly:  `__twig/mydirectory/_footer_logo.twig` -> `mydirectory/_footer_logo.twig`

## Configuration Files

## Available Template Functions/Tags

## Custom Hooks

# General Methodology for Converting an Existing Template
