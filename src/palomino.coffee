Gtk = imports.gi.Gtk
Lang = imports.lang
Webkit = imports.gi.WebKit2
Glib = imports.gi.GLib

Palomino = new Lang.Class({
  Name: 'Palomino'

  # Create the app
  _init: ->
    @application = new Gtk.Application()

    # connect 'activate' and 'startup' signals to the callback functions
    @application.connect('activate', Lang.bind(@, @_onActivate))
    @application.connect('startup', Lang.bind(@, @_onStartup))

  # callback function for 'activate'
  _onActivate: ->
    @window.present()

  # callback ffunction for 'startup'
  _onStartup: ->
    @_buildUI()

  _buildUI: ->
    # Create the application window
    @_window = new Gtk.ApplicationWindow({
      application: @application
      title: 'Palomino'
      default_width: 1600
      default_height: 900
      window_position: Gtk.WindowPosition.CENTER
      })
    @_window.set_icon_from_file('/home/macco/Listings/Palomino/resources/palomino.svg')
    # create a webview to show the web app
    @_webview = new Webkit.WebView()
    @_webview.connect('show-notification', Lang.bind(@, @_onShowNotification))
    # load gmail
    @_webview.load_uri('https://mail.google.com/', null)
    @_webcontext = @_webview.web_context
    print('WEBCONTEXT')
    print(@_webcontext)
    @_cookie_manager = @_webcontext.get_cookie_manager()
    @_cookie_manager.set_persistent_storage('/home/macco/.palomino_cookies.txt',
      Webkit.CookiePersistentStorage.TEXT)
    @_window.add(@_webview)

    @_window.show_all()

  _onShowNotification: ->
    print('show-notification')
  })

# run Palomino
app = new Palomino()
app.application.run(ARGV)
