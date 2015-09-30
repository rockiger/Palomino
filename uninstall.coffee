fs = require('fs.extra')
path = require('path')

NAME = 'myapp'
ID = 'org.example.myapp'
BINDIR = '/usr/bin'
DATADIR = '/usr/share'
SOURCENAME = 'dbus-example.js'
DESTNAME = 'myapp'

#helper
existsSync = (filePath) ->
  try
    fs.statSync(filePath)
  catch err
    if(err.code == 'ENOENT')
      return false
  true

# rm binary
if existsSync(path.join(BINDIR, DESTNAME))
  fs.remove(path.join(BINDIR, DESTNAME),  (err) ->
    if err?
      throw err
    console.log("Deleted binary")
  )

# rm desktop file
if existsSync(path.join(DATADIR,'applications', ID + '.desktop'))
  fs.remove(path.join(DATADIR,'applications', ID + '.desktop'), (err) ->
    if err?
      throw err
    console.log("Deleted desktop file")
  )

# rm dbus file
if existsSync(path.join(DATADIR,'dbus-1/services', ID + '.service'))
  fs.remove(path.join(DATADIR,'dbus-1/services', ID + '.service'), (err) ->
    if err?
      throw err
    console.log("Copied service file")
  )
