// Standard express generator app!
var express = require('express');
var path = require('path');
var logger = require('morgan');
const port = process.env.FUNCTIONS_HTTPWORKER_PORT || 3005
var usersRouter = require('./routes/users');

var app = express();
app.use(require('nocache')())

app.use(logger('dev'));
app.use(express.json());
app.use(express.urlencoded({ extended: false }));

app.use(express.static(path.join(__dirname, 'public')));

app.get('/stream', require('./routes/stream'));
app.get('/', usersRouter);

app.listen(port,() => {
    console.log('runnings12', port)
})