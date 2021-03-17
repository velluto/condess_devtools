# condess_devtools

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

When referencing any template you can either use the full path from the __twig folder OR the relative path under the directory it's in.

For example, if I have a template in `__twig/components/_sidebar_image.twig` then I can reference it as `components/_sidebar_image.twig` or `_sidebar_image.twig` and the system will locate it.

### Handlers

When processing a request, the `handler` is the starting point.  Handlers are located in `__twig/handlers`.  Each handler must be named the same as the request action and must end with the `.twig` file extension.

For example, if a user requests `https://mywebsite.com/story/4938` the handler used is `story.twig`

This is going to be the starting point for any request.

Example Handler:

```
{% extends "base_1.twig" %}

{% block handler_content %}
    {{ include('_news_1.twig') }}
    {{ include('_gallery.twig') }}
    {{ include('_news_3.twig') }}

{% endblock %}
```

### Sections

### Layouts

### Components

### Additional Directories

## Configuration Files

## Available Template Functions/Tags

## Custom Hooks

# General Methodology for Converting an Existing Template
