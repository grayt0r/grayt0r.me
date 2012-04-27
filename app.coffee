express = require 'express'
stylus = require 'stylus'
nib = require 'nib'

app = module.exports = express.createServer()

# Configuration
app.configure ->
  app.set 'views', "#{__dirname}/views"
  app.set 'view engine', 'jade'
  #app.set 'view options', { layout: 'layout' }
  app.use express.bodyParser()
  app.use express.methodOverride()
  app.use app.router
  app.use stylus.middleware({ src: "#{__dirname}/assets/stylus", dest: "#{__dirname}/public/css" })
  app.use express.static("#{__dirname}/public")

compileMethod = (str, path) ->
  stylus(str).set('filename', path).set('compress', true).use(nib())

pjax = (req) ->
  if req.header('X-PJAX') then 'partial' else 'render'

app.configure 'development', ->
  app.use express.errorHandler({ dumpExceptions: true, showStack: true })

app.configure 'production', ->
  app.use express.errorHandler()

# Routes
app.get '/', (req, res) ->
  res[pjax(req)]('index')

app.get '/projects', (req, res) ->
  res[pjax(req)]('projects')

app.get '/cv', (req, res) ->
  res[pjax(req)]('cv')

app.listen(process.env.PORT  or 3000)
console.log "Express server listening on port #{app.address().port} in #{app.settings.env} mode"