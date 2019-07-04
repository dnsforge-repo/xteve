#!/usr/bin/perl
############################################################################
# ; Program: xteve_starter.pl
# ; Author : LeeD <hostmaster@dnsforge.com>
# ; Rev    : v1.0.1
# ; Date   : 6/25/2019
# ; Last Modification: 6/25/2019
# ;
# ; Desc   : ENTRYPOINT & init script for the xTeVe docker container.
# ;
# ;	Copyright (c) 2019, Dnsforge Internet Inc.
# ;
# ;	This program is free software: you can redistribute it and/or modify
# ;	it under the terms of the GNU General Public License as published by
# ;	the Free Software Foundation, either version 3 of the License, or
# ;	(at your option) any later version.
# ;
# ;	This program is distributed in the hope that it will be useful,
# ;	but WITHOUT ANY WARRANTY; without even the implied warranty of
# ;	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# ;	GNU General Public License for more details.
# ;
# ;	You should have received a copy of the GNU General Public License
# ;	along with this program.  If not, see <http://www.gnu.org/licenses/>.
# ;
############################################################################

$XTEVE_USER = $ENV{'XTEVE_USER'};
$XTEVE_UID  = $ENV{'XTEVE_UID'};
$XTEVE_GID  = $ENV{'XTEVE_GID'};
$XTEVE_HOME = $ENV{'XTEVE_HOME'};
$XTEVE_TEMP = $ENV{'XTEVE_TEMP'};
$XTEVE_BIN  = $ENV{'XTEVE_BIN'};
$XTEVE_CONF = $ENV{'XTEVE_CONF'};
$XTEVE_PORT = $ENV{'XTEVE_PORT'};
$XTEVE_LOG  = $ENV{'XTEVE_LOG'};
$GUIDE2GO_HOME = $ENV{'GUIDE2GO_HOME'};
$GUIDE2GO_CONF = $ENV{'GUIDE2GO_CONF'};

$PATH = $ENV{'PATH'};
$TZ = $ENV{'TZ'};

$PROFILE = "/etc/profile";

if ( !-e "$XTEVE_HOME/.xteve.run") {
	print "Executing: Installation of Perl Modules...\n";
	system("/usr/bin/perl -MCPAN -e \"install JSON::XS\" >/var/log/xteve_start.log 2>&1");
	print "Executing: Add xTeVe user and group...\n";
	system("/usr/sbin/addgroup -g \"$XTEVE_GID\" \"$XTEVE_USER\"");
	sleep (1);
	system("/usr/sbin/adduser -H -h \"$XTEVE_HOME\" -s /bin/bash -D -u \"$XTEVE_UID\" -G \"$XTEVE_USER\" \"$XTEVE_USER\"");
	system("/bin/chown -R $XTEVE_USER:$XTEVE_USER $XTEVE_HOME");
	system("/bin/chown -R $XTEVE_USER:$XTEVE_USER $XTEVE_TEMP");
	system("/bin/chmod -R g+s $XTEVE_HOME");
	system("/bin/chmod -R g+s $XTEVE_TEMP");
	system("/bin/touch $XTEVE_HOME/.xteve.run");

if ( $TZ !~ /America\/New_York/ ) {
	unlink("/etc/localtime","/etc/timezone");
	system("/bin/ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone");
}

open PROFILE, ">>$PROFILE" or die "Unable to open $PROFILE: $!";
	print PROFILE "\n# Set custom \$USER Environment\n";
	print PROFILE "export PATH=$PATH\n";
	print PROFILE "export TZ=$TZ\n";
	print PROFILE "export XTEVE_BIN=$XTEVE_BIN\n";
	print PROFILE "export XTEVE_CONF=$XTEVE_CONF\n";
	print PROFILE "export XTEVE_HOME=$XTEVE_HOME\n";
	print PROFILE "export GUIDE2GO_HOME=$GUIDE2GO_HOME\n";
	print PROFILE "export GUIDE2GO_CONF=$GUIDE2GO_CONF\n";
close PROFILE;
}
print "Executing: Starting xTeVe and crond services...\n";
print "Executing: Info: For support come see us in our Discord channel: https://discord.gg/eWYquha\n";
system("/bin/chown -R $XTEVE_USER:$XTEVE_USER $XTEVE_HOME");
system("/bin/chown -R $XTEVE_USER:$XTEVE_USER $XTEVE_TEMP");
system("/usr/sbin/crond -l 2 -f -L /var/log/cron.log &");
exec("/sbin/su-exec $XTEVE_USER $XTEVE_BIN/xteve -config=$XTEVE_CONF -port=$XTEVE_PORT >> $XTEVE_LOG 2>&1");

