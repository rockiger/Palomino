Gtk = imports.gi.Gtk
Lang = imports.lang
Webkit = imports.gi.WebKit2
# Webex = imports.gi.WebKit2WebExtension
Glib = imports.gi.GLib
Gdk = imports.gi.Gdk
Gio = imports.gi.Gio

SPACING = 10

# TODO NewMessageWindow = new Gtk.Window() in eigene Datei

Palomino = new Lang.Class({
  Name: 'Palomino'

  # Create the app
  _init: ->
    @application = new Gtk.Application()

    # connect 'activate' and 'startup' signals to the callback functions
    @application.connect('activate', Lang.bind(@, @_onActivate))
    @application.connect('startup', Lang.bind(@, @_onStartup))
    @application.connect('shutdown', Lang.bind(@, @_onShutdown))

  # callback function for 'activate'
  _onActivate: ->
    @_window.present()

  # callback ffunction for 'startup'
  _onStartup: ->
    @_buildUI()

  _onShutdown: ->
    print("Shutdown")

  _buildUI: ->
    # Create the application window
    @_window = new Gtk.Window({
      application: @application
      title: 'Palomino'
      default_width: 1600
      default_height: 900
      window_position: Gtk.WindowPosition.CENTER
      })
    @_window.set_icon_from_file(\
    '/home/macco/Listings/Palomino/resources/palomino.svg')
    # create a webview to show the web apps
    @_vBox = new Gtk.Box({
      orientation: Gtk.Orientation.VERTICAL
      spacing: SPACING
      })
    @_webview = new Webkit.WebView()
    @_mousetarget = new Webkit.HitTestResult()

    @_headerbar = new Gtk.HeaderBar()
    @_headerbar.set_title("Palomino")
    @_headerbar.set_show_close_button(true)
    @_window.set_titlebar(@_headerbar)

    @_newMessageButton = new Gtk.Button()
    @_newMessageIcon = new Gio.ThemedIcon({
      name: "list-add-symbolic"
      })
    @_newMessageImage = new Gtk.Image({
      gicon: @_newMessageIcon
      })
    @_newMessageButton.add(@_newMessageImage)
    @_newMessageButton.connect('clicked', Lang.bind(@, @_onClickNewMessageBtn))

    @_settingsButton = new Gtk.Button()
    @_settingsIcon = new Gio.ThemedIcon({
      name: "preferences-system-symbolic"
      })
    @_settingsImage = new Gtk.Image({
      gicon: @_settingsIcon
      })
    @_settingsButton.add(@_settingsImage)
    @_headerbar.pack_end(@_settingsButton)
    @_headerbar.pack_start(@_newMessageButton)

    @_webview.connect('show-notification', Lang.bind(@, @_onShowNotification))
    @_webview.connect('decide-policy', Lang.bind(@, @_onDecidePolicy))
    @_webview.connect('create', Lang.bind(@, @_onCreate))
    @_webview.connect('script-dialog', Lang.bind(@, @_onScriptDialog))
    @_webview.connect('mouse-target-changed', \
    Lang.bind(@, @_onMouseTargetChanged))

    # load gmail
    @_webcontext = @_webview.web_context
    @_webcontext.set_cache_model(Webkit.CacheModel.DOCUMENT_VIEWER)
    @_cookie_manager = @_webcontext.get_cookie_manager()
    @_cookie_manager.set_persistent_storage('/home/macco/.palomino_cookies.txt',
      Webkit.CookiePersistentStorage.TEXT)
    @_websettings = @_webview.get_settings()
    @_websettings.set_javascript_can_open_windows_automatically(true)
    @_websettings.set_allow_modal_dialogs(true)
    @_websettings.set_enable_smooth_scrolling(true)
    @_webview.load_uri('https://mail.google.com', null)
    @_window.add(@_webview)

    @_window.show_all()

  _onShowNotification: ->
    print('show-notification')

  _onDecidePolicy: (webview,policyDecision,policyDecisionType) ->
    if policyDecisionType is Webkit.PolicyDecisionType.NEW_WINDOW_ACTION
      Gtk.show_uri(null, policyDecision.get_request().get_uri(),
      Gdk.CURRENT_TIME)
    return false

  _onCreate: (webview) ->
    print('on-create')
    # Gtk.show_uri(null,webview.get_uri(), 0)

  _onScriptDialog: (webview,dialog) ->
    print('script-dialog')
    if dialog.get_dialog_type() is Webkit.ScriptDialogType.ALERT and
    @_mousetarget.context_is_link()
      Gtk.show_uri(null, @_mousetarget.get_link_uri(), Gdk.CURRENT_TIME)
      return true
    return false

  _onMouseTargetChanged: (webview, hitTestResult) ->
    print('mouse-target-changed')
    if hitTestResult.context_is_link()
      print(hitTestResult.get_link_uri())
      @_mousetarget = hitTestResult
    return @_mousetarget

  _onClickNewMessageBtn: ->
    print('onClickNewMessageBtn')
  })




# run Palomino
app = new Palomino()
app.application.run(ARGV)
