fs = require('fs.extra')
path = require('path')

NAME = 'Palomino'
ID = 'com.rockiger.palomino'
BINDIR = '/usr/bin'
DATADIR = '/usr/share'
SOURCENAME = './bin/palomino'
DESTNAME = 'palomino'

# copy binary
fs.copy(SOURCENAME, path.join(BINDIR, DESTNAME), { replace: true }, (err) ->
  if err?
    throw err
  fs.chmodSync(path.join(BINDIR, DESTNAME), 0o755)
  console.log("Copied binary")
)

# copy desktop file
fs.copy('./src/desktop', path.join(DATADIR,'applications', ID + '.desktop'), { replace: true }, (err) ->
  if err?
    throw err
  console.log("Copied desktop file")
)

# copy dbus file
fs.copy('./src/dbus.service', path.join(DATADIR,'dbus-1/services', ID + '.service'), { replace: true }, (err) ->
  if err?
    throw err
  console.log("Copied service file")
)
