var Router = require('express').Router()
var https = require('https')
 
Router.get('*', function (req, res, next) {
 
    https.get('https://github.com/jsa2/azureFNcustomHandlers', (data) => {
 
        //remove express headers
        Object.keys(res.getHeaders()).forEach((headerName) => {
            res.removeHeader(headerName)
        })
 
        // write status
        res.status = data.statusCode
        // write headers
        Object.keys(data.headers).forEach((headerName) => {
            res.setHeader(headerName, data.headers[headerName])
        })
 
         //Pipe data to response stream
         data.pipe(res)
 
    })
 
})
 
module.exports=Router