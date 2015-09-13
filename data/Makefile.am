# I chose to use recursive automake so I can use nobase_ and avoid
# 5 different directory declarations
SUBDIRS = icons

app_resource_files = $(shell $(GLIB_COMPILE_RESOURCES) --sourcedir=$(srcdir) --generate-dependencies $(srcdir)/com.rockiger.Gtk.Palomino.data.gresource.xml)
com.rockiger.Gtk.Palomino.data.gresource: com.rockiger.Gtk.Palomino.data.gresource.xml $(app_resource_files)
	$(AM_V_GEN) $(GLIB_COMPILE_RESOURCES) --target=$@ --sourcedir=$(srcdir) $<

resourcedir = $(pkgdatadir)
resource_DATA = com.rockiger.Gtk.Palomino.data.gresource 

appsdir = $(datadir)/applications
apps_DATA = com.rockiger.Gtk.Palomino.desktop

@INTLTOOL_DESKTOP_RULE@

gsettings_SCHEMAS = com.rockiger.Gtk.Palomino.gschema.xml

@GSETTINGS_RULES@

appstream_XML = com.rockiger.Gtk.Palomino.appdata.xml

@APPSTREAM_XML_RULES@
@INTLTOOL_XML_RULE@

com.rockiger.Gtk.Palomino.service: com.rockiger.Gtk.Palomino.service.in
	$(AM_V_GEN) sed \
		-e "s|[@]PACKAGE_NAME@|$(PACKAGE_NAME)|g" \
		-e "s|[@]pkgdatadir@|$(pkgdatadir)|g" \
		-e "s|[@]pkglibdir@|$(pkglibdir)|g" \
		$< > $@

servicedir = $(datadir)/dbus-1/services
service_DATA = com.rockiger.Gtk.Palomino.service

EXTRA_DIST = \
	com.rockiger.Gtk.Palomino.desktop.in \
	com.rockiger.Gtk.Palomino.service.in \
	com.rockiger.Gtk.Palomino.data.gresource.xml \
	$(gsettings_SCHEMAS) \
	com.rockiger.Gtk.Palomino.appdata.xml.in \
	$(app_resource_files) \
	$(NULL)

CLEANFILES = \
	com.rockiger.Gtk.Palomino.service \
	com.rockiger.Gtk.Palomino.data.gresource \
	com.rockiger.Gtk.Palomino.appdata.xml \
	com.rockiger.Gtk.Palomino.appdata.valid \
	$(apps_DATA) \
	*.valid \
	gschemas.compiled \
	$(NULL)

# For uninstalled use
all-local:
	$(GLIB_COMPILE_SCHEMAS) $(builddir)

-include $(top_srcdir)/git.mk
