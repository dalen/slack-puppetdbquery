#!/usr/bin/env coffee

express = require('express')
parser = require('node-puppetdbquery')
http = require('https')
querystring = require('querystring')
request = require('sync-request')
bodyParser = require('body-parser')
config = require('./config')

app = express()
app.use(bodyParser.urlencoded({ extended: true }))

app.post '/', (req, res) ->
  unless req.param('token') == config.token
    res.status(403).send("Wrong token")
  else
    queryString = req.param('text').slice(req.param('trigger_word').length+1)
    try
      query = JSON.stringify(parser.parse(queryString))
    catch error
      res.status(200).send JSON.stringify({
        text: "```" + error.message + "```"
      })
      return
    response = request('GET',
      config.url +
      '/v4/nodes?' +
      querystring.stringify(query: query))
    nodes = JSON.parse(response.getBody('UTF-8')).map (node) ->
      node.certname
    if nodes.length == 0
      res.send(JSON.stringify {text: "No nodes found"})
    else if nodes.length > config.limit
      res.send(JSON.stringify {
        text: "```" + (nodes.slice(1,config.limit).join "\n") + "```\n" +
          "#{nodes.length} nodes total, showing first #{config.limit}"
      })
    else
      res.send(JSON.stringify {text: "```" + (nodes.join "\n") + "```\n" +
        "#{nodes.length} nodes total" })

server = app.listen config.port, ->
  host = server.address().address
  port = server.address().port
  console.log 'PuppetDB query Slack app listening at http://%s:%s', host, port
