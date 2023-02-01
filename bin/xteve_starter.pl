#!/usr/bin/perl
############################################################################
# ; Program: xteve_starter.pl
# ; Author : LeeD <hostmaster@dnsforge.com>
# ; Rev    : v1.1.1
# ; Date   : 6/25/2019
# ; Last Modification: 1/31/2023
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

use File::Copy;

$XTEVE_USER      = $ENV{'XTEVE_USER'};
$XTEVE_UID       = $ENV{'XTEVE_UID'};
$XTEVE_GID       = $ENV{'XTEVE_GID'};
$XTEVE_HOME      = $ENV{'XTEVE_HOME'};
$XTEVE_TEMP      = $ENV{'XTEVE_TEMP'};
$XTEVE_BIN       = $ENV{'XTEVE_BIN'};
$XTEVE_CACHE     = $ENV{'XTEVE_CACHE'};
$XTEVE_CONF      = $ENV{'XTEVE_CONF'};
$XTEVE_PORT      = $ENV{'XTEVE_PORT'};
$XTEVE_LOG       = $ENV{'XTEVE_LOG'};
$XTEVE_BRANCH    = $ENV{'XTEVE_BRANCH'};
$XTEVE_DEBUG     = $ENV{'XTEVE_DEBUG'};
$XTEVE_API       = $ENV{'XTEVE_API'};
$XTEVE_VERSION   = $ENV{'XTEVE_VERSION'};

$GUIDE2GO_SERVER_HOST = $ENV{'GUIDE2GO_SERVER_HOST'};
$GUIDE2GO_SERVER_PORT = $ENV{'GUIDE2GO_SERVER_PORT'};
$GUIDE2GO_HOME        = $ENV{'GUIDE2GO_HOME'};
$GUIDE2GO_CONF        = $ENV{'GUIDE2GO_CONF'};
$GUIDE2GO_LOG		  = $ENV{'GUIDE2GO_LOG'};

$PATH            = $ENV{'PATH'};
$TZ              = $ENV{'TZ'};
$PROFILE         = "/etc/profile";
$CRONDIR         = "/etc/crontabs";
$XTEVE_CRONDIR   = "$XTEVE_CONF/cron";
$XTEVE_SCRIPTS   = "$XTEVE_CONF/scripts";

if ( !-e "$XTEVE_HOME/.xteve.run") {
	print "Executing: Installation of Perl Modules...\n";
	system("/usr/bin/perl -MCPAN -e \"install JSON::XS\" >/var/log/xteve_starter.log 2>&1");
	print "Executing: Add xTeVe user and group...\n";
	system("/usr/sbin/addgroup -g \"$XTEVE_GID\" \"$XTEVE_USER\"");
	sleep (1);
	system("/usr/sbin/adduser -H -h \"$XTEVE_HOME\" -s /bin/bash -D -u \"$XTEVE_UID\" -G \"$XTEVE_USER\" \"$XTEVE_USER\"");
	system("/bin/chown -R $XTEVE_USER:$XTEVE_USER $XTEVE_HOME");
	system("/bin/chown -R $XTEVE_USER:$XTEVE_USER $XTEVE_TEMP");
	system("/bin/chmod -R g+s $XTEVE_HOME");
	system("/bin/chmod -R g+s $XTEVE_TEMP");
	system("/bin/touch $XTEVE_HOME/.xteve.run");
	print "Executing: Checking System Configuration..\n";
	print "\n";
	print "Executing: Info: [ To access a local docker shell type : docker exec -it < container_name > /bin/bash on the host system.\n\n";
	print "Executing: Info: [ To configure your SD lineups : - guide2conf --username <username> --password <password> --name <lineup_name> ** ]\n\n";
	&verify_setup();
	&update_settings();

if ( !-e "$XTEVE_CRONDIR" ) {
	mkdir $XTEVE_CRONDIR, 0755;
}
else {
	chmod 0755, $XTEVE_CRONDIR;
}


if ( !-e "$XTEVE_SCRIPTS" ) {
    mkdir $XTEVE_SCRIPTS, 0755;
	move("$XTEVE_BIN/m3uFilter.sh","$XTEVE_SCRIPTS/m3uFilter.sh");
}
else {
    chmod 0755, $XTEVE_SCRIPTS;
	move("$XTEVE_BIN/m3uFilter.sh","$XTEVE_SCRIPTS/m3uFilter.sh");
}


open CRONFILE, ">>$CRONDIR/root" or die "Unable to open $CRONFILE: $!";
	print CRONFILE "# Run xTeVe cron sync every 59 minutes\n*/59  *  *  *  *  /bin/cp $CRONDIR/$XTEVE_USER -Rf $XTEVE_CRONDIR/$XTEVE_USER\n";
close CRONFILE;

if ( !-e "$XTEVE_CRONDIR/$XTEVE_USER" ) {
open CRONFILE, ">>$XTEVE_CRONDIR/$XTEVE_USER" or die "Unable to open $CRONFILE: $!";
	print CRONFILE "#\n";
	print CRONFILE "# * * * * *\n";
	print CRONFILE "# | | | | |\n";
	print CRONFILE "# | | | | +- - - - day of week (0 - 6) (Sunday=0)\n";
	print CRONFILE "# | | | +- - - - - month (1 - 12)\n";
	print CRONFILE "# | | +- - - - - - day of month (1 - 31)\n";
	print CRONFILE "# | +- - - - - - - hour (0 - 23)\n";
	print CRONFILE "# +- - - - - - - - minute (0 - 59)\n";
	print CRONFILE "#\n";
	print CRONFILE "# To create your lineups for guide2go, zap2it and tvguide please see the examples below to create them with the guide2conf utility.\n";
	print CRONFILE "# Usage: $XTEVE_BIN/guide2conf -h\n";
	print CRONFILE "#\n";
	print CRONFILE "# Guide2go:\n";
	print CRONFILE "# $XTEVE_BIN/guide2conf --username <username> --password <password> --max-days=7 --name <lineup_name>\n";
	print CRONFILE "# Zap2it & TVGuide:\n";
	print CRONFILE "# $XTEVE_BIN/guide2conf --username <username\@domain.com> --password <password> --max-days=7 --name <lineup_name>\n";
	print CRONFILE "#\n";
	print CRONFILE "# Run the m3uFilter script daily at 12:00 AM\n";
	print CRONFILE "00  00  *  *  *   /bin/bash /home/xteve/conf/scripts/m3uFilter.sh\n";
	close CRONFILE;
	chmod 0600, "$XTEVE_CRONDIR/$XTEVE_USER";
	copy ("$XTEVE_CRONDIR/$XTEVE_USER","$CRONDIR/$XTEVE_USER");
}
else {
	print "Executing: Restoring Existing xTeVe crond Configuration...\n";
	chmod 0600, "$XTEVE_CRONDIR/$XTEVE_USER";
	copy ("$XTEVE_CRONDIR/$XTEVE_USER","$CRONDIR/$XTEVE_USER");
}

open PROFILE, ">>$PROFILE" or die "Unable to open $PROFILE: $!";
	print PROFILE "\n# Set custom \$USER Environment\n";
	print PROFILE "export PATH=$PATH\n";
	print PROFILE "export TZ=$TZ\n";
	print PROFILE "export XTEVE_USER=$XTEVE_USER\n";
	print PROFILE "export XTEVE_API=$XTEVE_API\n";
	print PROFILE "export XTEVE_BIN=$XTEVE_BIN\n";
	print PROFILE "export XTEVE_CACHE=$XTEVE_CACHE\n";
	print PROFILE "export XTEVE_CONF=$XTEVE_CONF\n";
	print PROFILE "export XTEVE_HOME=$XTEVE_HOME\n";
	print PROFILE "export XTEVE_VERSION=$XTEVE_VERSION\n";
	print PROFILE "export GUIDE2GO_SERVER_HOST=$GUIDE2GO_SERVER_HOST\n";
	print PROFILE "export GUIDE2GO_SERVER_PORT=$GUIDE2GO_SERVER_PORT\n";
	print PROFILE "export GUIDE2GO_HOME=$GUIDE2GO_HOME\n";
	print PROFILE "export GUIDE2GO_CONF=$GUIDE2GO_CONF\n";
	print PROFILE "export GUIDE2GO_LOG=$GUIDE2GO_LOG\n";
close PROFILE;
}
&check_api();
&verify_setup();
print "Executing: Version: xTeVe Docker Edition $XTEVE_VERSION\n";
print "Executing: Starting xTeVe and crond services...\n";
print "Executing: Info: For docker documentation visit https://hub.docker.com/r/dnsforge/xteve\n";
print "Executing: Info: For support come see us in our Discord channel: https://discord.gg/Up4ZsV6\n";
print "Executing: Info: xTeVe DEBUG mode [$XTEVE_DEBUG] initilized..\n" if $XTEVE_DEBUG > 0;
print "Executing: Info: xTeVe BRANCH mode [$XTEVE_BRANCH] initilized..\n" if $XTEVE_BRANCH =~ /beta/;
print "[xTeVe]: Log File: $XTEVE_LOG\n";
system("/bin/chown -R $XTEVE_USER:$XTEVE_USER $XTEVE_HOME");
system("/bin/chown -R $XTEVE_USER:$XTEVE_USER $XTEVE_TEMP");
system("/usr/sbin/crond -l 2 -f -L /var/log/cron.log &");

if ( $XTEVE_BRANCH =~ /beta/ ) {
	exec("/sbin/su-exec $XTEVE_USER $XTEVE_BIN/xteve -config=$XTEVE_CONF -port=$XTEVE_PORT -branch=$XTEVE_BRANCH -debug=$XTEVE_DEBUG >> $XTEVE_LOG 2>&1");
}
else {
	exec("/sbin/su-exec $XTEVE_USER $XTEVE_BIN/xteve -config=$XTEVE_CONF -port=$XTEVE_PORT -debug=$XTEVE_DEBUG >> $XTEVE_LOG 2>&1");
}

##################################################################################################################
# ;
# ; xteve_starter.pl: Program Subroutines
# ;
# ;
##################################################################################################################

sub verify_setup {
if ( $XTEVE_BRANCH !~ /master|beta/ ) {
	 $XTEVE_BRANCH = "master";
}
if ( $XTEVE_DEBUG > 3 ) {
	 $XTEVE_DEBUG = 3;
}
if ( $TZ !~ /America\/New_York/ ) {
	 unlink("/etc/localtime","/etc/timezone");
	 system("/bin/ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone");
	 }
}

sub check_api {
open SETTINGS, "$XTEVE_CONF/settings.json";
open T_SETTINGS, ">$XTEVE_CONF/settings.json.tmp";
                                                  
	while ( $reader = <SETTINGS> ) {
    	chomp $reader;
	print T_SETTINGS "$reader\n" unless $reader =~ /\"api\"/;
																                                                                   
	if ( $reader =~ /\"api\"/ ) {
   	 if ( $XTEVE_API ==0 ) {
			print T_SETTINGS "  \"api\": false,\n";
    	}
    	elsif ( $XTEVE_API ==1 ) {
	        print T_SETTINGS "  \"api\": true,\n";
        }
     }
} 
close SETTINGS;
close T_SETTINGS;
copy("$XTEVE_CONF/settings.json.tmp","$XTEVE_CONF/settings.json");
unlink("$XTEVE_CONF/settings.json.tmp");
}

sub update_settings {
if ( ! -e "$XTEVE_CONF/settings.json" ) {
open SETTINGS, ">$XTEVE_CONF/settings.json";

	if ( $XTEVE_API ==0 ) {
                print SETTINGS "\{\n  \"api\": false,\n";
	}
        elsif ( $XTEVE_API ==1 ) {
                print SETTINGS "\{\n  \"api\": true,\n";
}
print SETTINGS "  \"authentication.api\": false,\n";
print SETTINGS "  \"authentication.m3u\": false,\n";
print SETTINGS "  \"authentication.pms\": false,\n";
print SETTINGS "  \"authentication.web\": false,\n";
print SETTINGS "  \"authentication.xml\": false,\n";
print SETTINGS "  \"backup.keep\": 10,\n";
print SETTINGS "  \"backup.path\": \"/home/xteve/conf/backup/\",\n";
print SETTINGS "  \"git.branch\": \"$XTEVE_BRANCH\",\n";
print SETTINGS "  \"buffer\": \"-\",\n";
print SETTINGS "  \"buffer.size.kb\": 1024,\n";
print SETTINGS "  \"buffer.timeout\": 500,\n";
print SETTINGS "  \"cache.images\": false,\n";
print SETTINGS "  \"epgSource\": \"XEPG\",\n";
print SETTINGS "  \"ffmpeg.options\": \"-hide_banner -loglevel error -i [URL] -c copy -f mpegts pipe:1\",\n";
print SETTINGS "  \"ffmpeg.path\": \"/usr/bin/ffmpeg\",\n";
print SETTINGS "  \"vlc.options\": \"-I dummy [URL] --sout #std{mux=ts,access=file,dst=-}\",\n";
print SETTINGS "  \"vlc.path\": \"/usr/bin/cvlc\",\n";
print SETTINGS "  \"files\": {\n";
print SETTINGS "    \"hdhr\": {},\n";
print SETTINGS "    \"m3u\": {},\n";
print SETTINGS "    \"xmltv\": {}\n";
print SETTINGS "  \},\n";
print SETTINGS "  \"files.update\": true,\n";
print SETTINGS "  \"filter\": {},\n";
print SETTINGS "  \"language\": \"en\",\n";
print SETTINGS "  \"log.entries.ram\": 500,\n";
print SETTINGS "  \"m3u8.adaptive.bandwidth.mbps\": 10,\n";
print SETTINGS "  \"mapping.first.channel\": 1000,\n";
print SETTINGS "  \"port\": \"$XTEVE_PORT\",\n";
print SETTINGS "  \"ssdp\": true,\n";
print SETTINGS "  \"temp.path\": \"/tmp/xteve/\",\n";
print SETTINGS "  \"tuner\": 1,\n";
print SETTINGS " \"update\": [\n";
print SETTINGS "    \"0000\"\n";
print SETTINGS "  ],\n";
print SETTINGS "  \"user.agent\": \"xTeVe\",\n";
print SETTINGS "  \"version\": \"2.1.0\",\n";
print SETTINGS "  \"xepg.replace.missing.images\": true,\n";
print SETTINGS "  \"xteveAutoUpdate\": true\n";
print SETTINGS "\}";
}
else {
	&check_api();
	}
}
