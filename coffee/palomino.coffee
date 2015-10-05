Gtk = imports.gi.Gtk
Lang = imports.lang
Webkit = imports.gi.WebKit2
# Webex = imports.gi.WebKit2WebExtension
Glib = imports.gi.GLib
Gdk = imports.gi.Gdk
Gio = imports.gi.Gio

SPACING = 10

# TODO NewMessageWindow = new Gtk.Window() in eigene Datei
# es  wird mit jeder neuen Instanz _onActivate ausgelöst bei myapp

NewMailWindow = new Lang.Class({

  Name: 'NewMailWindow'

  _init: (webview) ->
    @_buildWindow(webview)

  _buildWindow: (webview) ->
    # Create the application window
    @_window = new Gtk.Window({
      title: 'Write E-Mail'
      default_width: 850
      default_height: 700
      window_position: Gtk.WindowPosition.CENTER
      })

    @_vBox = new Gtk.Box({
      orientation: Gtk.Orientation.VERTICAL
      spacing: SPACING
      })
    @_webview = webview
    @_mousetarget = new Webkit.HitTestResult()

    @_headerbar = new Gtk.HeaderBar()
    @_headerbar.set_title("Write Mail")
    @_headerbar.set_show_close_button(true)
    @_window.set_titlebar(@_headerbar)

    @_window.add(@_webview)

    # connect events
    @_window.show_all()

  onReadyToShow: ->
    print('onReadyToShow')

  })

Palomino = new Lang.Class({
  Name: 'Palomino'

  # Create the app
  _init: ->
    @application = new Gtk.Application(
      {application_id: 'com.rockiger.palomino'}
    )

    @_buildActions()

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
    #@_window.set_icon_from_file(\
    #'/usr/palomino.svg')
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

    @_revealer = new Gtk.Revealer()
    @_revealer.set_transition_duration(1000)
    @_revealer.set_transition_type(Gtk.RevealerTransitionType.SLIDE_LEFT)
    @_message = new Gtk.Label()
    @_msgState = @_message.get_state()
    @_msgBgColor = new Gdk.RGBA()
    @_msgBgColor.parse("#f9edbe")
    @_message.override_background_color(@_msgState, @_msgBgColor)
    @_message.set_padding(10, 0)
    @_revealer.add(@_message)
    @_headerbar.pack_end(@_revealer)

    # load gmail
    @_webcontext = @_webview.web_context
    @_webcontext.set_cache_model(Webkit.CacheModel.DOCUMENT_VIEWER)
    @_cookie_manager = @_webcontext.get_cookie_manager()
    @_cookie_manager.set_persistent_storage('/home/macco/.palomino_cookies.txt',
      Webkit.CookiePersistentStorage.TEXT)
    @_websettings = @_webview.get_settings()
    @_websettings.set_javascript_can_open_windows_automatically(true)
    @_websettings.set_allow_modal_dialogs(true)
    @_websettings.set_enable_developer_extras(true)
    @_websettings.set_enable_smooth_scrolling(true)
    @_webview.load_uri('https://mail.google.com', null)
    @_window.add(@_webview)

    # connect events

    @_newMessageButton.connect('clicked', Lang.bind(@, @_onClickNewMessageBtn))
    @_webview.connect('show-notification', Lang.bind(@, @_onShowNotification))
    @_webview.connect('decide-policy', Lang.bind(@, @_onDecidePolicy))
    @_webview.connect('create', Lang.bind(@, @_onCreate))
    @_webview.connect('script-dialog', Lang.bind(@, @_onScriptDialog))
    @_webview.connect('mouse-target-changed', \
    Lang.bind(@, @_onMouseTargetChanged))
    @_webcontext.connect('download-started', Lang.bind(@, @_onDownloadStarted))
    @_window.connect('key-press-event', Lang.bind(@, @_onKeyPress))

    @_window.show_all()

  _buildActions: ->
    print('_buildActions')
    newMailAction = new Gio.SimpleAction({name: 'new-mail'})
    newMailAction.connect('activate', Lang.bind(@, @_onNewMail))
    @application.add_action(newMailAction)

  _onShowNotification: ->
    print('show-notification')

  _onDecidePolicy: (webview,policyDecision,policyDecisionType) ->
    # print('decide-policy')
    if policyDecisionType is Webkit.PolicyDecisionType.NEW_WINDOW_ACTION
      print('NEW_WINDOW_ACTION')
      Gtk.show_uri(null, policyDecision.get_request().get_uri(),
      Gdk.CURRENT_TIME)
    return false

  _onCreate: (webview, navAction, window) ->
    print('on-create')
    uri = navAction.get_request().get_uri()
    ###
    Test if Googlemail want's  to open a new compose window
    if not open url in default browser
    ###
    TS = "https://mail.google.com/mail/u/0/?ui=2&view=btop&ver="
    if uri? and uri.slice(0, TS.length) == TS
      newWebview = new Webkit.WebView({related_view: webview})
      newWebview.set_settings(webview.get_settings())

      newWindow = new NewMailWindow(newWebview)
      newWebview.connect('ready-to-show', Lang.bind(@, newWindow.onReadyToShow))
      newWebview.connect('close', Lang.bind(@, ->
        newWindow._window.destroy())) # ?? can't destroy in window in it's class
      return newWebview
    else
      Gtk.show_uri(null, uri, 0)
      return null


  _onScriptDialog: (webview,dialog) ->
    print('script-dialog')
    if dialog.get_dialog_type() is Webkit.ScriptDialogType.ALERT and
    @_mousetarget.context_is_link()
      Gtk.show_uri(null, @_mousetarget.get_link_uri(), Gdk.CURRENT_TIME)
      return true
    return true

  _onMouseTargetChanged: (webview, hitTestResult) ->
    if hitTestResult.context_is_link()
      print(hitTestResult.get_link_uri())
      @_mousetarget = hitTestResult
    return @_mousetarget

  _onClickNewMessageBtn: ->
    print('onClickNewMessageBtn')
    @_onNewMail()
    #ev = new Gdk.Event({type: Gdk.EventType.KEY_PRESS})
    #Gtk.test_widget_send_key(@_window, Gdk.KEY_c,Gdk.ModifierType.SHIFT_MASK)
    #event.keyval = Gdk.KEY_C
    #@_webview.emit('key-press-event', event)

    # get window in front

  _onDownloadStarted: (webcontext, download) ->
    print('fileDownload')
    download.connect('decide-destination', Lang.bind(@, @_showInfobar))
    download.connect('finished', Lang.bind(@, @_hideInfobar))

  _onNewMail: ->
    print('_onNewMail')
    ###
    send shortcut via javascript to webview, that it open a new compose window
    ###
    js = """(function() {

    //The compose button
    var composeEl = document.getElementsByClassName('T-I J-J5-Ji T-I-KE L3')[0];

    if(composeEl) {
      //Trigger mouse down event
      var mouseDown = document.createEvent('MouseEvents');
      mouseDown.initEvent( 'mousedown', true, false, window, 0, 0, 0, 0, 0, false, false, true, false, 0, null);
      mouseDown.shiftKey = true;
      console.log(mouseDown.shiftKey);
      console.log(mouseDown.metaKey);
      console.log(mouseDown.altKey);
      console.log(mouseDown.ctrlKey);
      composeEl.dispatchEvent(mouseDown);

      //Trigger mouse up event
      var mouseUp = document.createEvent('MouseEvents');
      mouseUp.initEvent( 'mouseup', true, false, window, 0, 0, 0, 0, 0, false, false, true, false, 0, null);
      composeEl.dispatchEvent(mouseUp)

      return true;
    }
    return false;
    }).call(this);
    """
    @_webview.run_javascript(js, null, ->)
    @_window.present()

  _showInfobar: (download, suggested_filename) ->
    @_message.set_markup("<b>Downloading: " + suggested_filename + "</b>")
    @_revealer.set_reveal_child(true)
    print('Started download of ' + suggested_filename )
    false

  _hideInfobar: (download) ->
    print('hideInfobar')
    Glib.timeout_add(Glib.PRIORITY_DEFAULT, 2000, Lang.bind(@, ->
      @_revealer.set_reveal_child(false)
      false))

  _onKeyPress: (widget, event) ->


  })


# run Palomino
app = new Palomino()
app.application.run(ARGV)
