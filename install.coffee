fs = require('fs.extra')
path = require('path')

NAME = 'myapp'
ID = 'org.example.myapp'
BINDIR = '/usr/bin'
DATADIR = '/usr/share'
SOURCENAME = 'dbus-example.js'
DESTNAME = 'myapp'

# copy binary
fs.chmodSync(path.join(BINDIR, DESTNAME), 0o755)
fs.copy(SOURCENAME, path.join(BINDIR, DESTNAME), { replace: true }, (err) ->
  if err?
    throw err
  console.log("Copied binary")
)

# copy desktop file
fs.copy('desktop', path.join(DATADIR,'applications', ID + '.desktop'), { replace: true }, (err) ->
  if err?
    throw err
  console.log("Copied desktop file")
)

# copy dbus file
fs.copy('dbus.service', path.join(DATADIR,'dbus-1/services', ID + '.service'), { replace: true }, (err) ->
  if err?
    throw err
  console.log("Copied service file")
)
