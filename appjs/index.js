
var express = require('express');
var mysql      = require('mysql');
var app = express();


var connection = mysql.createConnection({
  host     : process.env.DB_HOST || 'localhost',
  user     : process.env.DB_USER ||'root',
  password : 's3kreee7'
});
app.get("/users", (req,res) => {
    connection.query('SELECT * from users', function(err, rows, fields) {
        if (err) {
            connection.end();
            throw err;
        }
        res.json(rows);
      });
})





app.get('/', function (req, res) {
  res.send({text:'Hello World!'});
});

app.listen(3000, function () {
  console.log('Example app listening on port 3000!');
});

