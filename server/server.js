let express = require('express')

const app = express()
app.use((req, res, next) => {
    res.header("Access-Control-Allow-Origin", "*");
    res.header("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept");
    next();
});

class User {
    constructor(id, firstName, lastName) {
        this.id = id
        this.firstName = firstName
        this.lastName = lastName
    }
}


class Tag {
    constructor(tagName) {
        this.tagName = tagName
    }
}


class Article {
    constructor(userId, header, tags, body) {
        this.userId = userId
        this.header = header
        this.tags = tags
        this.body = body
    }
}


let users = new Map()
users.set(1, new User(1, "Jon", "Harder"))

let articles = new Map()
articles.set(1, new Article(1, "First Post!", [new Tag("elm"), new Tag("blog")], `My first post!
Well, here it is. It may look like hot garbage, but there's a lot going on under the scenes here.
There's an express app running which response to requests to users and articles. And an elm application
which asynchronosly requests a user, the first article, decodes the json, and displays a formatted post,
this post to be exact.

I'm tired so thats all for this inagural post.`))


app.get('/', (req, res) => {
    res.send('ok')
})
app.get('/articles', (req, res) => {
    res.json(Array.from(articles.values()))
})
app.get('/users', (req, res) => {
    res.json(Array.from(users.values()))
})
app.get('/users/:userId', (req, res) => {
    const { userId } = req.params
    parsedUserId = parseInt(userId)
    let user = null;
    if(Number.isNaN(parsedUserId)) {
        res.status(400).send(`${userId} is not an integer`)
    } else {
        user = users.get(parsedUserId)
        if(user === undefined) {
            res.status(404).send('user not found')
        } else {
            res.json(user)
        }
    }
})
app.get('/articles/:articleId', (req, res) => {
    const { articleId } = req.params
    parsedArticleId = parseInt(articleId)
    let article = null;
    if(Number.isNaN(parsedArticleId)) {
        res.status(400).send(`${articleId} is not an integer`)
    } else {
        article = articles.get(parsedArticleId)
        if(article === undefined) {
            res.status(404).send('article not found')
        } else {
            res.json(article)
        }
    }
})

app.listen(3000, () => console.log('Blog backend started on port 3000!'))