Gtk = imports.gi.Gtk
Lang = imports.lang
Webkit = imports.gi.WebKit2
Webex = imports.gi.WebKit2WebExtension
Glib = imports.gi.GLib
Gdk = imports.gi.Gdk

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
    @_window.present()

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
    @_window.set_icon_from_file(\
    '/home/macco/Listings/Palomino/resources/palomino.svg')
    # create a webview to show the web app
    @_webview = new Webkit.WebView()
    @_mousetarget = new Webkit.HitTestResult()

    @_webview.connect('show-notification', Lang.bind(@, @_onShowNotification))
    @_webview.connect('decide-policy', Lang.bind(@, @_onDecidePolicy))
    @_webview.connect('create', Lang.bind(@, @_onCreate))
    @_webview.connect('script-dialog', Lang.bind(@, @_onScriptDialog))
    @_webview.connect('mouse-target-changed', \
    Lang.bind(@, @_onMouseTargetChanged))

    # load gmail
    @_webview.load_uri('https://mail.google.com', null)
    @_webcontext = @_webview.web_context
    @_cookie_manager = @_webcontext.get_cookie_manager()
    @_cookie_manager.set_persistent_storage('/home/macco/.palomino_cookies.txt',
      Webkit.CookiePersistentStorage.TEXT)
    @_websettings = @_webview.get_settings()
    @_websettings.set_javascript_can_open_windows_automatically(true)
    @_websettings.set_allow_modal_dialogs(true)
    @_websettings.set_enable_smooth_scrolling(true)
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
  })


# run Palomino
app = new Palomino()
app.application.run(ARGV)