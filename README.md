# Elm Blog
I've wanted to create a blog to act as a diary of sorts for my software development....development
for quite a while.  I've also wanted to get to know [Elm](http://elm-lang.org) for a while as well.

I expect the first few posts to be about the building of this blog itself, with more diverse subjects
trickling in as the implimentation of this site settles.

## Requirements

* elm >= 0.19
* node >= ??? (developed with v8.9.1)

## Building
You can build this blog yourself if you want to mess around with the framework, or see what a
small/medium scale Elm app looks like.  For now my blog posts will be hard coded into the application
itself, but I hope to store them in static files or a database once the design of the site nears
completion.

There is a `Makefile` included which handles the building, optimizing, and various other tasks
associated with the life-cycle of this site

### Developmental build

```bash
make
```

### Optimized build

```bash
make build
```

### Clean the distribution folder

```bash
make clean
```