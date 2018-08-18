const express = require('express')
const fs = require('fs')


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


let users = new Map()
users.set(1, new User(1, "Jon", "Harder"))


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

const ArticesDir = "./static/artices"

const formatStaticArticle = (contents) => {
    const lines = contents.split("\n")
    return {
        header: lines[0],
        tags: lines[1].split(",").map(s => s.trim()),
        body: lines.slice(2).join("\n")
    }
}

const findArticle = (dateStr, slug) => {
    const dateDir = dateStr.replace(/-/g, '')
    const file = `./static/articles/${dateDir}/${slug}.md`
    return file
}

app.get("/articles/:date/:slug", (req, res) => {
    const { date, slug } = req.params
    const file = findArticle(date, slug)
    const contents = fs.readFileSync(file, "utf8")
    res.send(formatStaticArticle(contents))
})

app.listen(3000, () => console.log('Blog backend started on port 3000!'))