// Generated by CoffeeScript 1.10.0
(function() {
  var Gdk, Gio, Glib, Gtk, Lang, Palomino, SPACING, Webkit, app;

  Gtk = imports.gi.Gtk;

  Lang = imports.lang;

  Webkit = imports.gi.WebKit2;

  Glib = imports.gi.GLib;

  Gdk = imports.gi.Gdk;

  Gio = imports.gi.Gio;

  SPACING = 10;

  Palomino = new Lang.Class({
    Name: 'Palomino',
    _init: function() {
      this.application = new Gtk.Application();
      this.application.connect('activate', Lang.bind(this, this._onActivate));
      this.application.connect('startup', Lang.bind(this, this._onStartup));
      return this.application.connect('shutdown', Lang.bind(this, this._onShutdown));
    },
    _onActivate: function() {
      return this._window.present();
    },
    _onStartup: function() {
      return this._buildUI();
    },
    _onShutdown: function() {
      return print("Shutdown");
    },
    _buildUI: function() {
      this._window = new Gtk.Window({
        application: this.application,
        title: 'Palomino',
        default_width: 1600,
        default_height: 900,
        window_position: Gtk.WindowPosition.CENTER
      });
      this._window.set_icon_from_file('/home/macco/Listings/Palomino/resources/palomino.svg');
      this._vBox = new Gtk.Box({
        orientation: Gtk.Orientation.VERTICAL,
        spacing: SPACING
      });
      this._webview = new Webkit.WebView();
      this._mousetarget = new Webkit.HitTestResult();
      this._headerbar = new Gtk.HeaderBar();
      this._headerbar.set_title("Palomino");
      this._headerbar.set_show_close_button(true);
      this._window.set_titlebar(this._headerbar);
      this._newMessageButton = new Gtk.Button();
      this._newMessageIcon = new Gio.ThemedIcon({
        name: "list-add-symbolic"
      });
      this._newMessageImage = new Gtk.Image({
        gicon: this._newMessageIcon
      });
      this._newMessageButton.add(this._newMessageImage);
      this._settingsButton = new Gtk.Button();
      this._settingsIcon = new Gio.ThemedIcon({
        name: "preferences-system-symbolic"
      });
      this._settingsImage = new Gtk.Image({
        gicon: this._settingsIcon
      });
      this._settingsButton.add(this._settingsImage);
      this._headerbar.pack_end(this._settingsButton);
      this._headerbar.pack_start(this._newMessageButton);
      this._webcontext = this._webview.web_context;
      this._webcontext.set_cache_model(Webkit.CacheModel.DOCUMENT_VIEWER);
      this._cookie_manager = this._webcontext.get_cookie_manager();
      this._cookie_manager.set_persistent_storage('/home/macco/.palomino_cookies.txt', Webkit.CookiePersistentStorage.TEXT);
      this._websettings = this._webview.get_settings();
      this._websettings.set_javascript_can_open_windows_automatically(true);
      this._websettings.set_allow_modal_dialogs(true);
      this._websettings.set_enable_smooth_scrolling(true);
      this._webview.load_uri('https://mail.google.com', null);
      this._window.add(this._webview);
      this._newMessageButton.connect('clicked', Lang.bind(this, this._onClickNewMessageBtn));
      this._webview.connect('show-notification', Lang.bind(this, this._onShowNotification));
      this._webview.connect('decide-policy', Lang.bind(this, this._onDecidePolicy));
      this._webview.connect('create', Lang.bind(this, this._onCreate));
      this._webview.connect('script-dialog', Lang.bind(this, this._onScriptDialog));
      this._webview.connect('mouse-target-changed', Lang.bind(this, this._onMouseTargetChanged));
      this._webcontext.connect('download-started', Lang.bind(this, this._onDownloadStarted));
      return this._window.show_all();
    },
    _onShowNotification: function() {
      return print('show-notification');
    },
    _onDecidePolicy: function(webview, policyDecision, policyDecisionType) {
      print('decide-policy');
      if (policyDecisionType === Webkit.PolicyDecisionType.NEW_WINDOW_ACTION) {
        Gtk.show_uri(null, policyDecision.get_request().get_uri(), Gdk.CURRENT_TIME);
      }
      return false;
    },
    _onCreate: function(webview) {
      return print('on-create');
    },
    _onScriptDialog: function(webview, dialog) {
      print('script-dialog');
      if (dialog.get_dialog_type() === Webkit.ScriptDialogType.ALERT && this._mousetarget.context_is_link()) {
        Gtk.show_uri(null, this._mousetarget.get_link_uri(), Gdk.CURRENT_TIME);
        return true;
      }
      return false;
    },
    _onMouseTargetChanged: function(webview, hitTestResult) {
      print('mouse-target-changed');
      if (hitTestResult.context_is_link()) {
        print(hitTestResult.get_link_uri());
        this._mousetarget = hitTestResult;
      }
      return this._mousetarget;
    },
    _onClickNewMessageBtn: function() {
      return print('onClickNewMessageBtn');
    },
    _onDownloadStarted: function(webcontext, download) {
      print('fileDownload');
      download.connect('decide-destination', Lang.bind(this, this._showInfobar));
      return download.connect('finished', Lang.bind(this, this._hideInfobar));
    },
    _showInfobar: function(download, suggested_filename) {
      print('Started download of ' + suggested_filename);
      return false;
    },
    _hideInfobar: function(download) {
      return print('hideInfobar');
    }
  });

  app = new Palomino();

  app.application.run(ARGV);

}).call(this);
