express = require 'express'
app = express()
SSI = require 'node-ssi'
ssi = new SSI {baseDir: __dirname, encoding: 'utf-8'}
transform = require 'connect-static-transform'
path = require 'path'
S = require 'string'

app.use transform
    root: __dirname
    match: /.*(\.html|\/)$/
    normalize: (fp) -> if S(fp).endsWith '/' then "#{fp}index.html" else fp
    cache: false
    pathOnly: true
    transform: (filepath, send) ->
        if S(filepath).endsWith '.html'
            # console.log "Transforming: #{filepath}"
            ssi.compileFile filepath, (err, content) ->
                if err
                    console.error err.stack
                    console.log "Transform error code: #{err.code}, message: #{err.message}"
                    send false
                else
                    console.log "Sending: #{filepath}"
                    send content, {'Content-type': 'text/html'}
        else
            console.log "Skipping transform: #{filepath}"
            send false # skip to next middleware
    # if pathOnly is false or undefined, this version can be used instead:
    # transform: (filepath, text, send) ->
    #     console.log "Transforming: #{filepath}"
    #     ssi.compile text, {dirname: path.dirname filepath}, (err, content) ->
    #         throw err if err
    #         console.log "Sending: #{filepath}"
    #         send content, {'Content-type': 'text/html'}

app.use express.static __dirname

# http://expressjs.com/guide/error-handling.html
app.use (err, req, res, next) ->
    console.error err.stack
    console.log "Error code: #{err.code}, message: #{err.message}"
    res.status(500).send err.message

app.listen 8080, ->
    console.log "Listening on: http://localhost:%s", this.address().port