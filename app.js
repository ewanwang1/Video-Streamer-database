const express = require("express");
const bodyParser = require("body-parser");
const request = require("request");
const ejs = require("ejs");


const app = express();
app.use(express.static("public"));
app.set('view engine', 'ejs');
app.use(bodyParser.urlencoded({ extended: true }));



var _ = require('lodash');
const { response } = require("express");

const pgp = require('pg-promise')()
const CONNECTION_STRING = 'Server://postgres:12345@localhost:5432/movie_streaming';

const db = pgp(CONNECTION_STRING);


//Todo: import EJS library to send database reponse object to HTML file


//Global variable
var SQLresponse = "";



app.get("/", function (req, res) {
    res.render("main");
});


//insert
app.get("/insert", function (req, res) {
    let sql = `SELECT *
                  FROM videos
                  JOIN non_cartoon
                  ON videos.videoID = non_cartoon.videoID;`;

    db.any(sql)
        .then(resolve => {
            SQLresponse = resolve;
            res.render("insert", { response: SQLresponse });
        })
        .catch(err => {
            console.log(err);
        });
});

app.post("/insert", function (req, res) {
    let userInput = req.body;
    let sql = `INSERT INTO video_specifics
                VALUES ('${userInput.title}', ${userInput.year}, ${userInput.rating}); ` +
        `INSERT INTO videos
                VALUES (${userInput.videoID},'${userInput.title}', ${userInput.year},${userInput.length}, '${userInput.description}', ${userInput.episode}); ` +
        `INSERT INTO non_cartoon
                 VALUES (${userInput.videoID}, '${userInput.location_setting}');` +
        `SELECT *
                  FROM videos
                  JOIN non_cartoon
                  ON videos.videoID = non_cartoon.videoID;`;
    db.any(sql)
        .then(resolve => {
            res.redirect("insert");
        })
        .catch(err => {
            console.log(err);
        });
});

//delete
app.get("/delete", function (req, res) {
    let sql = `select * from membership;`;
    db.any(sql)
        .then(resolve => {
            SQLresponse = resolve;
            res.render("delete", { response: SQLresponse });
        })
        .catch(err => {
            console.log(err);
        });
});

app.post("/delete", function (req, res) {
    let userInput = req.body;
    let sql = `DELETE FROM membership WHERE membershiptype = ${userInput.mtype};`;
    db.any(sql)
        .then(resolve => {
            SQLresponse = resolve;
            res.redirect("/delete");
        })
        .catch(err => {
            console.log(err);
        });
});

//update
app.get("/update", function (req, res) {
    let sql = `select * from membership;`;
    db.any(sql)
        .then(resolve => {
            SQLresponse = resolve;
            res.render("update", { response: SQLresponse });
        })
        .catch(err => {
            console.log(err);
        });
});

app.post("/update", function (req, res) {
    let userInput = req.body;
    var userTypeSQL = "";
    switch (userInput.type) {
        case 'Basic':
            userTypeSQL = "'Basic'";
            break;
        case 'Standard':
            userTypeSQL = "'Standard'";
            break;
        case 'Premium':
            userTypeSQL = "'Premium'";
            break;
        default:
            break;
    }
    let sql = `UPDATE membership 
               SET price = ${userInput.price}
               WHERE membershiptype = ${userTypeSQL};`

    db.any(sql)
        .then(resolve => {
            res.redirect("update");
        })
        .catch(err => {
            console.log(err);
        });
});

//select
app.get("/select", function (req, res) {
    let sql = `SELECT *
                FROM video_specifics;`;
    db.any(sql)
        .then(resolve => {
            SQLresponse = resolve;
            res.render("select", { response: SQLresponse });
        })
        .catch(err => {
            console.log(err);
        });
});

app.post("/select", function (req, res) {
    let userInput = req.body;

    let sql = `SELECT * 
                FROM video_specifics
                WHERE rating > ${userInput.rating};`;

    db.any(sql)
        .then(resolve => {
            SQLresponse = resolve;
            res.render("select", { response: SQLresponse });
        })
        .catch(err => {
            console.log(err);
        });
});



//project
app.get("/project", function (req, res) {
    serverCln = [];
    res.render("project", { response: SQLresponse, coln: serverCln });
});

app.post("/project", function (req, res) {
    let userInput = req.body;

    // let projectOptions = ["cID", "email", "cname", "age", "postalCode"];
    var projectItemSQL = "";
    serverCln = [];
    var startOfLoop = true;
    userInput.project.forEach(element => {
        switch (element) {
            case "cID":
                if (startOfLoop) {
                    projectItemSQL += "customerid"
                } else {
                    projectItemSQL += ",customerid"
                }
                serverCln.push("customerid")
                break;
            case "email":
                if (startOfLoop) {
                    projectItemSQL += "email"
                } else {
                    projectItemSQL += ",email"
                }
                serverCln.push("email")
                break;
            case "cName":
                if (startOfLoop) {
                    projectItemSQL += "entity_name"
                } else {
                    projectItemSQL += ",entity_name"
                }
                serverCln.push("entity_name")
                break;
            case "age":
                if (startOfLoop) {
                    projectItemSQL += "age"
                } else {
                    projectItemSQL += ",age"
                }
                serverCln.push("age")
                break;
            case "postalCode":
                if (startOfLoop) {
                    projectItemSQL += "postalcode"
                } else {
                    projectItemSQL += ",postalcode"
                }
                serverCln.push("postalcode")
                break;

            default:
                break;
        }
        startOfLoop = false;
    });
    let sql = `SELECT ${projectItemSQL}  
               FROM customers;`; //i think i understood this right, the checked box is the input itself? // edit by ewan: You can't pass an object to SQL

    db.any(sql)
        .then(resolve => {
            SQLresponse = resolve;
            res.render("project", { response: SQLresponse, coln: serverCln })
            SQLresponse = "";
        })
        .catch(err => {
            console.log(err);
        });
});

//join
app.get("/join", function (req, res) {
    res.render("join", { response: SQLresponse });
});

app.post("/join", function (req, res) {
    let userInput = req.body;
    let sql = `SELECT c.customerID, c.entity_name, c.age, v.videoID, v.title, v.video_year
               FROM customers c, videos v, recommendation r
               WHERE c.customerID = r.customerID AND v.videoID = r.movieID AND c.age > 19
               AND c.age < 30;`;

    db.any(sql)
        .then(resolve => {
            SQLresponse = resolve;
            res.render("join", { response: SQLresponse });
            SQLresponse = "";

        })
        .catch(err => {
            console.log(err);
        });
});

//Aggregation
app.get("/aggregation", function (req, res) {

    res.render("aggregation", { response: SQLresponse });
});

app.post("/aggregation", function (req, res) {
    let userInput = req.body;
    let sql = `SELECT *
               FROM video_specifics
               WHERE rating = (SELECT MAX(rating) 
                               FROM video_specifics);`;

    db.any(sql)
        .then(resolve => {
            SQLresponse = resolve;

            res.render("aggregation", { response: SQLresponse });

            SQLresponse = "";
        })
        .catch(err => {
            console.log(err);
        });
    // db.$pool.end();
});

//nested, have to discuss what we want to do but ill leave in the template
app.get("/nested", function (req, res) {
    res.render("nested", { response: SQLresponse });
});

app.post("/nested", function (req, res) {
    let userInput = req.body;
    let sql = `Select v.title, v.video_year, count(*)
                From adds a, video_specifics v
                Group by v.title, v.video_year
                Having count(*) > 1 AND v.title IN (Select v1.title
                    FROM videos v1
                    Where v1.video_description LIKE '%hero%');`;
    db.any(sql)
        .then(resolve => {
            SQLresponse = resolve;
            res.render("nested", { response: SQLresponse });
            SQLresponse = "";

        })
        .catch(err => {
            console.log(err);
        });
});


app.get("/division", function (req, res) {
    res.render("division", { response: SQLresponse });
});

app.post("/division", function (req, res) {
    let sql = `SELECT c.customerID, c.entity_name, c.email
               FROM customers c
               WHERE NOT EXISTS ((SELECT v.videoID FROM videos v)
                                  EXCEPT
                                  (SELECT a.videoID FROM adds a 
                                  WHERE a.customerID = c.customerID));`;
    db.any(sql)
        .then(resolve => {
            SQLresponse = resolve;
            console.log(SQLresponse);
            res.render("division", { response: SQLresponse });
            console.log("about to clear SQLresponse");
            SQLresponse = "";

        })
        .catch(err => {
            console.log(err);
        });
});




app.listen("3000", function () {
    console.log("server is running on port 3000");
});
