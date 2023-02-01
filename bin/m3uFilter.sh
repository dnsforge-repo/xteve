#!/bin/bash
############################################################################
# ; Program: m3uFilter.sh
# ; Author : LeeD <hostmaster@dnsforge.com>
# ; Rev    : v1.1.1
# ; Date   : 9/11/2022
# ; Last Modification: 1/30/2023
# ; 
# ; Desc   : Build's a customized M3U playlist including only categories
# ;	     specififed in $M3U_GROUP_NAMES.
# ; 
# ;     Copyright (c) 2019, Dnsforge Internet Inc.
# ; 
# ;     This program is free software: you can redistribute it and/or modify
# ;     it under the terms of the GNU General Public License as published by
# ;     the Free Software Foundation, either version 3 of the License, or
# ;     (at your option) any later version.
# ;
# ;     This program is distributed in the hope that it will be useful,
# ;     but WITHOUT ANY WARRANTY; without even the implied warranty of
# ;     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# ;     GNU General Public License for more details.
# ;
# ;     You should have received a copy of the GNU General Public License
# ;     along with this program.  If not, see <http://www.gnu.org/licenses/>.
# ;
############################################################################

M3UFILTER_MODE="0";												# Change this to "1" to enable script
XTEVE_USER="$XTEVE_USER"											# System UID for crontab
M3U_URL='http://proxy.provider.tld/get.php?username=username&password=password&type=m3u_plus&output=ts'		# Streaming server Playlist M3U URL
M3U_USER_AGENT='TiviMate/4.3.0 (Linux; Android 7.1.2)'                                                          # Custom user agent for connecting to streaming server
M3U_FILE='/home/xteve/conf/data/playlist.m3u'									# Local file name for M3U Playlist
M3U_OUTPUT_FILE='/home/xteve/conf/data/playlist.m3u.tmp'							# Local temp file name for filtered M3U Playlist
M3U_BACKUP_FILE='/home/xteve/conf/data/playlist.m3u.bak'                                            		# Local file name of backup file for rollback
M3U_GROUP_NAMES=( "USA" "UK" "CANADA")										# M3U catagories to add to M3U Playlist
M3U_MIN_SIZE='600000'												# Set a minimum file size in bytes (triggers auto rollback)

if (( $M3UFILTER_MODE == 0 )); 
then
     echo "Script is DISABLED please configure settings and set M3UFILTER_MODE to [1] to ENABLE"
     exit 0
fi

if [ -f "$M3U_FILE" ]; then
/bin/cp $M3U_FILE $M3U_BACKUP_FILE
fi
if [ -f "$M3U_FILE" ]; then
rm -f $M3U_FILE
fi
if [ -f "$M3U_OUTPUT_FILE" ]; then
rm -f $M3U_OUTPUT_FILE
fi

echo ""
echo "Playlist M3U URL: $M3U_URL"
echo "Downloading M3U Playlist to [$M3U_FILE] . . ."
echo ""

/usr/bin/wget --user-agent="$M3U_USER_AGENT" -O $M3U_FILE $M3U_URL

if [ -s $M3U_FILE ]
then
M3U_FILE_SIZE=$(stat -c%s "$M3U_FILE")
echo "M3U download file size is: [$M3U_FILE_SIZE] bytes"
else
echo "Error downloading M3U File. File is empty or does not exist. !!"
echo "Restoring [$M3U_BACKUP_FILE] . . ."
/bin/cp $M3U_BACKUP_FILE $M3U_FILE
/bin/chown $XTEVE_USER:$XTEVE_USER $M3U_FILE
/bin/chown $XTEVE_USER:$XTEVE_USER $M3U_BACKUP_FILE
exit 0;
fi

if (( $M3U_FILE_SIZE < $M3U_MIN_SIZE )); then
echo "M3U Playlist was NOT downloaded successfully.  File is smaller then minimum file size of [$M3U_MIN_SIZE] bytes !!"
echo "Restoring [$M3U_BACKUP_FILE] . . ."
/bin/cp $M3U_BACKUP_FILE $M3U_FILE
/bin/chown $XTEVE_USER:$XTEVE_USER $M3U_FILE
/bin/chown $XTEVE_USER:$XTEVE_USER $M3U_BACKUP_FILE
exit 0;
fi

if [ -s $M3U_FILE ]
then
     echo "M3U Playlist was downloaded successully!!"
     /usr/bin/dos2unix $M3U_FILE
     /bin/chown $XTEVE_USER:$XTEVE_USER $M3U_FILE
     /bin/chown $XTEVE_USER:$XTEVE_USER $M3U_BACKUP_FILE
else
     echo "M3U Playlist was NOT downloaded successfully.  Please check URL or try again!!"
     echo "Restoring [$M3U_BACKUP_FILE] . . ."
     /bin/cp $M3U_BACKUP_FILE $M3U_FILE
     /bin/chown $XTEVE_USER:$XTEVE_USER $M3U_FILE
     /bin/chown $XTEVE_USER:$XTEVE_USER $M3U_BACKUP_FILE
     exit 0
fi

echo ""
echo "Building M3U: Including the following groups:"
printf '%s\n' "${M3U_GROUP_NAMES[@]}"

echo "#EXTM3U" > $M3U_OUTPUT_FILE
/bin/chown $XTEVE_USER:$XTEVE_USER $M3U_OUTPUT_FILE
for group in "${M3U_GROUP_NAMES[@]}"
do
sed -n "/group-title=\"$group\"/,+1p" $M3U_FILE >> $M3U_OUTPUT_FILE
done

echo ""
echo "Copying [$M3U_OUTPUT_FILE] to [$M3U_FILE] ..."
echo ""
mv $M3U_OUTPUT_FILE $M3U_FILE
echo "Done!"
