var express = require('express');
var router = express.Router();

/* GET users listing. */
router.get('*', function(req, res, next) {
  console.log(req.headers)
  return res.json({user:true})
});

module.exports = router;
