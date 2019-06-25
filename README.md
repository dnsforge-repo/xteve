<h1 id="xTeVe><a href="https://xteve.de/">xTeVe v2.0 / Guide2go / Zap2XML</a></h1>
<a href="https://xteve.de/"><p><b>https://www.xteve.de</b></p></a>


Image Maintainer:  <b>LeeD </b>\<hostmaster@dnsforge.com\></a>

For support come visit us at our xTeVe Discord channel:
https://discord.gg/eWYquha

<h2 id="description">Description</h2>

xTeVe is a M3U proxy server for Plex, Emby and any client and provider which supports the .TS and .M3U8 (HLS) streaming formats.

xTeVe emulates an SiliconDust HDHomeRun OTA tuner which allows it to expose IPTV style channels to software which would not normally support it.  This Docker image includes the following packages:

                    *    xTeVe v2.0 (Linux) x86 64 bit
                    *    Guide2go (Linux) x86 64 bit  (Schedules Direct XMLTV grabber)
                    *    Zap2XML (Perl based zap2it XMLTV grabber)
                    *    Crond
                    *    Perl

The recommended container settings are listed in the docker run command listed below:

<p><b> docker run -it -d --name=xteve --network=host --restart=always -e TZ=America/New_York  -p 127.0.0.1:34400:34400 -v ~xteve:/home/xteve/conf -v ~xteve_tmp:/tmp/xteve dnsforge/xteve:latest</b></p>



<h2 id="container paths">Default container paths</h2>

This container is configured with the following default environmental variables,  For reference here are the path's of the xTeVe installation:


<table class="paleBlueRows">
<thead>
<tr>
<th>Variable</th>
<th>Path</th>
</tr>
</thead>
<tfoot>
<tr>
<td>&nbsp;</td>
<td>&nbsp;</td>
</tr>
</tfoot>
<tbody>
<tr>
<td>$XTEVE_HOME</td>
<td>/home/xteve</td>
</tr>
<tr>
<td>$XTEVE_BIN</td>
<td>/home/xteve/bin</td>
</tr>
<tr>
<td>$XTEVE_CONF</td>
<td>/home/xteve/conf</td>
</tr>
<tr>
<td>$XTEVE_CONF/data</td>
<td>/home/xteve/conf/data</td>
</tr>
<tr>
<td>$XTEVE_CONF/backup</td>
<td>/home/xteve/conf/backup</td>
</tr>
<tr>
<td>$GUIDE2GO_HOME</td>
<td>/home/xteve/guide2go</td>
</tr>
</tr>
<tr>
<td>$GUIDE2GO_CONF</td>
<td>/home/xteve/guide2go/conf</td>
</tr>
</tbody>
</table>


<h2 id="parameters">Parameters</h2>

<table class="paleBlueRows">
<thead>
<tr>
<th>Parameter</th>
<th>Description</th>
</tr>
</thead>
<tfoot>
<tr>
<td>&nbsp;</td>
<td>&nbsp;</td>
</tr>
</tfoot>
<tbody>
<tr>
<td>--name</td>
<td>Name of container image</td>
</tr>
<tr>
<td>--network</td>
<td>Set network type [ host | bridge ]</td>
</tr>
<tr>
<td>--restart</td>
<td>Enable auto restart for this container</td>
</tr>
<tr>
<td>-p 38400</td>
<td>Default container port mapping [ie; 127.0.0.1:38400:38400]</td>
</tr>
<tr>
<td>-e XTEVE_PORT=8080</td>
<td>Set custom xTeVe Port</td>
</tr>
<tr>
<td>-e TZ=America/Los_Angeles</td>
<td>Set custom Locale</td>
</tr>
<tr>
<td>-v</td>
<td>Set default container port mapping [ 127.0.0.1:34400:34400 ]</td>
</tr>
<tr>
<td>dnsforge/xteve:latest</td>
<td>Latest Docker image</td>
</tr>
<tr>
<td>-e GUIDE2GO_CONFIG=/path/to/config</td>
<td>Not yet Implemented</td>
</tbody>
</table>

<p><b>Linux:</b></p>

mkdir -p ~/xteve

mkdir -p ~/xteve_tmp

docker run -it -d --name=xteve --network=host --restart=always -e TZ=America/New_York -p 127.0.0.1:34400:34400 -v ~/xteve:/home/xteve/conf -v ~/xteve_tmp:/tmp/xteve dnsforge/xteve:latest


<p><b>Synology:</b></p>


mkdir /volume1/docker/xteve

mkdir /volume1/docker/xteve_tmp

docker run -it -d --name=xteve --network=host --restart=always -e TZ=America/New_York -p 127.0.0.1:34400:34400 -v /volume1/docker/xteve:/home/xteve/conf -v /volume1/docker/xteve_tmp:/tmp/xteve dnsforge/xteve:latest

<h2 id="Guide2go Configuration">Guide2go Configuration</h2>

To use this feature you will need to purchase a <a href="http://www.schedulesdirect.org">Schedules Direct</a> subscription for $25.00/yr. A sample guide2go configuration file has been provided in /home/xteve/guide2go/conf/guide2go.json which can be configured using the following command:

<p><b>guide2go -configure $GUIDE2GO_CONF/guide2go.json</b></p>

You will need to enter your Schedules Direct username and password then select "2. Add lineup"  and follow the prompts.  Finally you will want to select the channels for your lineup using option "4. Manage channels".

<h2 id="Guide2go Crontab">Guide2go Crontab</h2>

Additionally a sample crontab has been created to run the guide2go configuration on a weekly basis. To modify the crontab run 'crontab -e'
from a command prompt terminal inside the container.  You will need to add the guide2go XML file in <b>XMLTV->Add</b> in xTeVe. The sample crontab runs at 1:15 AM on sundays.

<p><b>guide2go -config $GUIDE2GO_CONF/guide2go.json</p\b></p>


<h2 id="zap2XML Crontab">zap2XML Crontab</h2>

Also a sample crontab has been created to run the zap2XML configuration on a weekly basis. You will need to sign up for a free <a href="https://tvlistings.zap2it.com">Zap2it</a> account. To modify the crontab run 'crontab -e' from a command prompt terminal 
inside the container. You will need to add the zap2XML XML file in <b>XMLTV->Add</b> in xTeVe. The sample crontab runs at 1:15 AM on sundays.

<p><b>/usr/bin/perl $XTEVE_BIN/zap2xml.pl -u username -p password -o $XTEVE_CONF/data/zap2xml.xml</p\b></p>


Enjoy!
