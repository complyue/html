/*----------------------------------------------------------------------------
   Copyright 2024, Koka-Community Authors

   Licensed under the MIT License ("The License"). You may not
   use this file except in compliance with the License. A copy of the License
   can be found in the LICENSE file at the root of this distribution.
----------------------------------------------------------------------------*/

import html/html

import html/layout


// todo: this deserves a PR to go into std/core?
fun do(action : () -> e a) : e a
  action()


fun front()

  /* todo: a PR to introduce the `super` keyword, to be used in record-updates?
          val page = web-tmpl-basic(page-head = {
            page-head(super)()
            link("stylesheet", "text/css", "/front.css")
          })
  */
  val tmpl = web-tmpl-basic(page-head = {
    page-head(web-tmpl-basic)()
    link("stylesheet", "text/css", "/front.css")
  })

  with create-component <- layout-html(tmpl)
  // customization to the page template follows

  with val page-title = "The Front Page"

  with fun body-content() // admit no content from the template, fresh new here
    h3
      text(page-title)
      // todo: text("&nbsp;") might work in current early stage,
      //       but `text()` should really escape HTML sequences,
      //       then we'll need a `raw()` HTML function in parallel,
      //       and ultimately we'd better add the `fun nbsp() {raw("&nbsp;")}` 
      // nbsp()
      span
        add-attr("style", "font-size: 70%;")
        a("/data.csv")
          text("download csv")
    table
      thead
        tr
          th
            text("Col A")
          th
            text("Col B")
          th
            text("Col C")
      tbody
        with row <- range/for(1,5)
        tr
          td
            text("Cell A" ++ row.show)
          td
            text("Cell B" ++ row.show)
          td
            text("Cell C" ++ row.show)

  with fun body-end-scripts()
    // possibly prepand special contents for this page here

    do // include default contents from the template
      mask<body-end-scripts>
      body-end-scripts()

    // append special contents for this page
    src/script("/front.js")

  // materialize the page template with effective customization above
  create-component()


fun main()
  val page = front()
  println(page.show)
