SHELL = /bin/sh
INSTALL = install
INSTALL_PROGRAM = $(INSTALL) -m755
INSTALL_DATA = $(INSTALL) -m644
confdir = /etc/conf.d
prefix = /usr
bindir = $(prefix)/bin
libdir = $(prefix)/lib
datarootdir = $(prefix)/share
mandir = $(prefix)/share/man
man1dir = $(mandir)/man1

SOURCES = velocityd.sh.in velocityd.conf.in velocityd.service.in velocityd.sysusers.in velocityd.tmpfiles.in
OBJECTS = $(SOURCES:.in=)

GAME = velocity
INAME = velocityd
SERVER_ROOT = /srv/$(GAME)
GAME_USER = $(GAME)
MAIN_EXECUTABLE = velocity.jar
SESSION_NAME = $(GAME)
SERVER_START_CMD = java -Xms1G -Xmx1G -XX:+UseG1GC -XX:G1HeapRegionSize=4M -XX:+UnlockExperimentalVMOptions -XX:+ParallelRefProcEnabled -XX:+AlwaysPreTouch -XX:MaxInlineLevel=15 -jar ./$${MAIN_EXECUTABLE}
SERVER_START_SUCCESS = done
IDLE_SERVER = false
IDLE_SESSION_NAME = idle_server_$${SESSION_NAME}
GAME_PORT = 25565
CHECK_PLAYER_TIME = 30
IDLE_IF_TIME = 1200
GAME_COMMAND_DUMP = /tmp/$${INAME}_$${SESSION_NAME}_command_dump.txt
MAX_SERVER_START_TIME = 150
MAX_SERVER_STOP_TIME = 100

.MAIN = all

define replace_all
	cp -a $(1) $(2)
	sed -i \
		-e 's#@INAME@#$(INAME)#g' \
		-e 's#@GAME@#$(GAME)#g' \
		-e 's#@SERVER_ROOT@#$(SERVER_ROOT)#g' \
		-e 's#@GAME_USER@#$(GAME_USER)#g' \
		-e 's#@MAIN_EXECUTABLE@#$(MAIN_EXECUTABLE)#g' \
		-e 's#@SESSION_NAME@#$(SESSION_NAME)#g' \
		-e 's#@SERVER_START_CMD@#$(SERVER_START_CMD)#g' \
		-e 's#@SERVER_START_SUCCESS@#$(SERVER_START_SUCCESS)#g' \
		-e 's#@IDLE_SERVER@#$(IDLE_SERVER)#g' \
		-e 's#@IDLE_SESSION_NAME@#$(IDLE_SESSION_NAME)#g' \
		-e 's#@GAME_PORT@#$(GAME_PORT)#g' \
		-e 's#@CHECK_PLAYER_TIME@#$(CHECK_PLAYER_TIME)#g' \
		-e 's#@IDLE_IF_TIME@#$(IDLE_IF_TIME)#g' \
		-e 's#@GAME_COMMAND_DUMP@#$(GAME_COMMAND_DUMP)#g' \
		-e 's#@MAX_SERVER_START_TIME@#$(MAX_SERVER_START_TIME)#g' \
		-e 's#@MAX_SERVER_STOP_TIME@#$(MAX_SERVER_STOP_TIME)#g' \
		$(2)
endef

all: $(OBJECTS)
	echo $(OBJECTS)

%.sh: %.sh.in
	$(call replace_all,$<,$@)

%.conf: %.conf.in
	$(call replace_all,$<,$@)

%.service: %.service.in
	$(call replace_all,$<,$@)

%.sysusers: %.sysusers.in
	$(call replace_all,$<,$@)

%.tmpfiles: %.tmpfiles.in
	$(call replace_all,$<,$@)

%.timer: %.timer.in
	$(call replace_all,$<,$@)

clean:
	rm -f $(OBJECTS)

distclean: clean

maintainer-clean: clean

install:
	$(INSTALL_PROGRAM) -D velocityd.sh "$(DESTDIR)$(bindir)/$(INAME)"
	$(INSTALL_DATA) -D velocityd.conf           "$(DESTDIR)$(confdir)/$(GAME)"
	$(INSTALL_DATA) -D velocityd.service        "$(DESTDIR)$(libdir)/systemd/system/$(INAME).service"
	$(INSTALL_DATA) -D velocityd.sysusers       "$(DESTDIR)$(libdir)/sysusers.d/$(INAME).conf"
	$(INSTALL_DATA) -D velocityd.tmpfiles       "$(DESTDIR)$(libdir)/tmpfiles.d/$(INAME).conf"

uninstall:
	rm -f "$(bindir)/$(INAME)"
	rm -f "$(confdir)/$(GAME)"
	rm -f "$(libdir)/systemd/system/$(INAME).service"
	rm -f "$(libdir)/sysusers.d/$(INAME).conf"
	rm -f "$(libdir)/tmpfiles.d/$(INAME).conf"
