express = require 'express'
stylus = require 'stylus'
nib = require 'nib'

app = module.exports = express.createServer()

# Configuration
app.configure ->
  app.set 'views', "#{__dirname}/views"
  app.set 'view engine', 'jade'
  app.use express.bodyParser()
  app.use express.methodOverride()
  app.use app.router
  app.use express.static("#{__dirname}/public")
  app.use stylus.middleware({ src: "#{__dirname}/assets", dest: "#{__dirname}/public", compile: compileMethod })

compileMethod = (str, path) ->
  stylus(str).set('filename', path).set('compress', true).use(nib())

app.configure 'development', ->
  app.use express.errorHandler({ dumpExceptions: true, showStack: true })

app.configure 'production', ->
  app.use express.errorHandler()

# Routes
app.get '/', (req, res) ->
  res.render 'index'

app.listen 3000
console.log "Express server listening on port #{app.address().port} in #{app.settings.env} mode"