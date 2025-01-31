/*----------------------------------------------------------------------------
   Copyright 2024, Koka-Community Authors

   Licensed under the MIT License ("The License"). You may not
   use this file except in compliance with the License. A copy of the License
   can be found in the LICENSE file at the root of this distribution.
----------------------------------------------------------------------------*/

import html/html


pub effect val page-title : string

pub effect fun body-begin-scripts() : ()
  // : <html-tree|e> () // an explicit effect in result type of an operation is not allowed (yet)
pub effect fun body-content() : ()
pub effect fun body-end-scripts() : ()

pub alias html-tmpl = <
  page-title,
  body-begin-scripts,
  body-content,
  body-end-scripts
>


pub value struct html-page<e::E>
  page-head : () -> <html-tmpl,html-tree|e> ()
  page-body : () -> <html-tmpl,html-tree|e> ()

pub val web-tmpl-basic : html-page<total> = Html-page(
  {
    head
      meta("charset", "UTF-8")
      link("icon", "image/png", "icons/favicon.png")
      link("stylesheet", "text/css", "/site.css")
      title
        text(page-title)
  },{
    body
      body-begin-scripts()
      body-content()
      body-end-scripts()
  }
)


pub fun layout-html(
  page : html-page<e>, 
  create-component : (() -> <html-tmpl,html-tree|e> component) -> e component
) : e component

  with val page-title = "?!?"

  with fun body-begin-scripts()
    src/script("/init-page.js")

  with fun body-content() {()}

  with fun body-end-scripts()
    src/script("/site.js")

/*
effects do not match
  inferred effect: <body-begin-scripts,body-content,body-end-scripts,page-title|$e>
  expected effect: <html-tmpl,html-builder/html-tree|$e>
*/
  create-component
    html
      page-head(page)()
      page-body(page)()
