A outgoing webhook handler for [Slack](https://slack.com) that queries PuppetDB
for nodes. The node query syntax is done using
[node-puppetdbquery](https://www.npmjs.org/package/node-puppetdbquery).

Installation
============

clone the git repo on your PuppetDB host, copy the `config.json.example` file to
`config.json` and edit it to match your environment. Especially edit the token
to match the one for your Slack webhook.

Install the dependencies using `npm install` (in the source directory).
And then run it using `npm start` (requires coffee-script,
`npm install -g coffee-script`).

Then setup a outgoing Slack webhook to point to to the URL of your server, and
choose some activation keyword like `puppetdbquery:`.
