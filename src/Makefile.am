NULL =

appdir = $(pkgdatadir)
nodist_app_SCRIPTS = com.rockiger.Gtk.Palomino

app_resource_files = $(shell $(GLIB_COMPILE_RESOURCES) --sourcedir=$(srcdir) --generate-dependencies $(srcdir)/com.rockiger.Gtk.Palomino.src.gresource.xml)
com.rockiger.Gtk.Palomino.src.gresource: com.rockiger.Gtk.Palomino.src.gresource.xml $(app_resource_files)
	$(AM_V_GEN) $(GLIB_COMPILE_RESOURCES) --target=$@ --sourcedir=$(srcdir) $<

resourcedir = $(pkgdatadir)
resource_DATA = com.rockiger.Gtk.Palomino.src.gresource

com.rockiger.Gtk.Palomino: com.rockiger.Gtk.Palomino.in
	$(AM_V_GEN) sed \
		-e "s|[@]GJS@|$(GJS)|g" \
		-e "s|[@]PACKAGE_VERSION@|$(PACKAGE_VERSION)|g" \
		-e "s|[@]prefix@|$(prefix)|g" \
		-e "s|[@]libdir@|$(libdir)|g" \
		-e "s|[@]pkgdatadir@|$(pkgdatadir)|g" \
		$< > $@
	@chmod +x $@

EXTRA_DIST = \
	com.rockiger.Gtk.Palomino.in \
	com.rockiger.Gtk.Palomino.src.gresource.xml \
	$(app_resource_files) \
	$(service_resource_files) \
	$(NULL)

CLEANFILES = \
	com.rockiger.Gtk.Palomino \
	com.rockiger.Gtk.Palomino.src.gresource \
	$(NULL)

install-exec-hook:
	$(MKDIR_P) $(DESTDIR)$(bindir)
	ln -sf $(appdir)/com.rockiger.Gtk.Palomino $(DESTDIR)$(bindir)/$(PACKAGE_TARNAME)
uninstall-hook:
	-rm -f $(DESTDIR)$(bindir)/$(PACKAGE_TARNAME)

-include $(top_srcdir)/git.mk
