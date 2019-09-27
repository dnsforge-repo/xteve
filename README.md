<h1 id="xTeVe><a href="https://xteve.de/">xTeVe Docker Edition v2.0</a></h1>
<a href="https://xteve.de"><p><b>Recommended by xteve.de</b></p></a>
<tr>
<br>

Image Maintainer:  <b>LeeD </b>\<hostmaster@dnsforge.com\></a>

For support come visit us at our xTeVe Discord channel:
https://discord.gg/eWYquha

<p <b>Existing Users:  To migrate to the latest v2.0 docker image simply install this docker and restore from a backup of version v1.4.4 or later.</b></p>

<tr>

<br>

<br>

<br>

<h2 id="description">Description</h2>

xTeVe is a M3U proxy server for Plex, Emby and any client and provider which supports the .TS and .M3U8 (HLS) streaming formats.

xTeVe emulates a SiliconDust HDHomeRun OTA tuner, which allows it to expose IPTV style channels to software, which would not normally support it.  This Docker image includes the following packages and features:

<br>

<ul>
<li>xTeVe v2.0 (Linux) x86 64 bit</li>
<li>Guide2go (Linux) x86 64 bit  (Schedules Direct XMLTV grabber)</li>
<li>Zap2XML Support  (Perl based zap2it / TVguide.com XMLTV grabber)</li>
<li>Bash, Perl & crond Support</li>
<li>VLC & ffmpeg Support (BETA)</li>
<li>Sample config's and crons</li>
<li>Runs as  unprivileged user</li>
</ul>

<br>

<h2 >Docker 'run' Configuration & container mappings</h2>

The recommended <b>default</b> container settings are listed in the docker run command listed below:

<p><b> docker run -it -d --name=xteve --network=host --restart=always -v $LOCAL_DIR/xteve:/home/xteve/conf -v $LOCAL_DIR/xteve_tmp:/tmp/xteve dnsforge/xteve:latest</b></p>

<br>

<br>

If you plan to use guide2go simply, include the GUIDE2GO_CONF Volume to be able to access your files directly from the host.  Existing users can also copy their existing <b>.json</b> configuration files in to this location.

<p><b>docker run -it -d --name=xteve --network=host --restart=always -v $LOCAL_DIR/xteve:/home/xteve/conf -v $LOCAL_DIR/xteve_tmp:/tmp/xteve -v $LOCAL_DIR/guide2go_conf:/home/xteve/guide2go/conf dnsforge/xteve:latest</b></p>

<br>

The default Locale is configured as: <b>America/New_York (EST) </b> and the Web UI can be accessed at <b>http://\$HOST_IP:34400/web/ </b>

<br>

<br>

<h2 >Custom Configuration</h2>

You can  customize the container installation by passing options with <b> 'docker run'</b> or by selecting the "Environment" tab in your docker GUI.  Below are a few examples of customizing the container configuration.  Please see the "Parameters" table below for a list of all supported options.

Custom Locale (Timezone):

<p><b> docker run -it -d --name=xteve --network=host --restart=always -e TZ=Europe/London -v $LOCAL_DIR/xteve:/home/xteve/conf -v
$LOCAL_DIR/xteve_tmp:/tmp/xteve dnsforge/xteve:latest</b></p>

Custom Port and Locale:
<p><b> docker run -it -d --name=xteve --network=host --restart=always -e TZ=Europe/London -e XTEVE_PORT=8080 -v $LOCAL_DIR/xteve:/home/xteve/conf -v
$LOCAL_DIR/xteve_tmp:/tmp/xteve dnsforge/xteve:latest</b></p>

<br>

<h2>Default container paths</h2>

This container is configured with the following default environmental variables,  for reference, here are the paths of the xTeVe installation:


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
<tr>
<td>$GUIDE2GO_CONF</td>
<td>/home/xteve/guide2go/conf</td>
</tr>
</tbody>
</table>

<br>

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
<td>-e TZ=Europe/London</td>
<td>Set custom Locale</td>
</tr>
<tr>
<td>-p 34400</td>
<td>Default container port mapping [ 127.0.0.1:34400:34400 ]</td>
</tr>
<tr>
<td>-e XTEVE_PORT=8080</td>
<td>Set custom xTeVe Port</td>
</tr>
<tr>
<td>-e XTEVE_BRANCH=beta</td>
<td>Set xTeVe git branch [ master|beta ] Default: master
</tr>
<tr>
<td>-e XTEVE_DEBUG=1</td>
<td>Set xTeVe debug level [ 0-3 ] Default: 0=OFF</td>
</tr>
<tr>
<td>-v</td>
<td>Set volume mapping [ -v ~xteve:/home/xteve/conf ]</td>
</tr>
<tr>
<td>dnsforge/xteve:latest</td>
<td>Latest Docker image</td>
</tbody>
</table>

<br>
<br>

<h2 >Linux Shell (Bash)</h2>
To connect to the xTeVe container to run local commands, use the following docker command to start a bash shell:
<p><b>docker exec -it xteve /bin/bash</b></p>

You will automatically be logged in as the root user.  Type <b>"su - xteve"</b> to change to the xTeve user.

<br>
<br>

<h2 >Linux</h2>

Run the container with the 'docker run' command with any desired parameters from the table above.

<p><b>mkdir -p ~/xteve</b>

<p><b>mkdir -p ~/xteve_tmp</b>

<p><b>docker run -it -d --name=xteve --network=host --restart=always  -v ~/xteve:/home/xteve/conf -v ~/xteve_tmp:/tmp/xteve dnsforge/xteve:latest</b>

<br>

<br>

<p>Linux with Guide2go:</p>
<p><b>docker run -it -d --name=xteve --network=host --restart=always  -v ~/xteve:/home/xteve/conf -v ~/xteve_tmp:/tmp/xteve -v ~/guide2go_conf:/home/xteve/guide2go/conf dnsforge/xteve:latest</b>

<br>

<br>

<h2 >Synology</h2>

Run the container with the 'docker run' command with any desired parameters from the table above.  Alternatively you can launch this image in the
Synology Docker GUI which is equivalent to 'docker run'.

<p><b>mkdir /volume1/docker/xteve</b>

<p><b>mkdir /volume1/docker/xteve_tmp</b>

<p><b>docker run -it -d --name=xteve --network=host --restart=always  -v /volume1/docker/xteve:/home/xteve/conf -v /volume1/docker/xteve_tmp:/tmp/xteve dnsforge/xteve:latest</b>

<br>
<br>

<p>Synology with Guide2go:</p>

<p><b>docker run -it -d --name=xteve --network=host --restart=always  -v /volume1/docker/xteve:/home/xteve/conf -v /volume1/docker/xteve_tmp:/tmp/xteve -v /volume1/docker/guide2go_conf:/home/xteve/guide2go/conf dnsforge/xteve:latest</b>

<br>
<br>

<h2 id="Guide2go Configuration">Guide2go Configuration</h2>

To use this feature you will need to purchase a <a href="http://www.schedulesdirect.org">Schedules Direct</a> subscription for $25.00/yr. A sample guide2go configuration file has been provided in /home/xteve/guide2go/conf/guide2go.json which can be configured using the following command:

<p><b>guide2go -configure $GUIDE2GO_CONF/guide2go.json</b></p>

Provide your Schedules Direct username and password when prompted and then configure your lineup and channels using these options: 
2. Add lineup  [ Enter your postcode/zip and select a TV provider lineup in your local area ]
4. Manage channels [ Select the channels to populate in your lineup or type "ALL" for all channels in the lineup ]

<br>
<br>

<h2 id="Guide2go Crontab">Guide2go Crontab</h2>

Additionally a sample crontab has been created to run the guide2go configuration on a weekly basis. To modify the crontab run <b>'crontab -e -u xteve'</b>
from a command prompt terminal inside the container.  You will need to add the guide2go XMLTV file located in <b>$XTEVE_CONF/data/guide2go.xml</b>  to  <b>xTeVe->XMLTV</b> once it has been generated on the first run. The sample crontab runs at 1:15 AM on sundays.

<p><b>guide2go -config $GUIDE2GO_CONF/guide2go.json</b></p>

<br>
<br>

<h2 id="zap2XML Crontab">zap2XML Crontab</h2>

In addition a sample crontab has been created to run the zap2XML configuration on a weekly basis. You will need to sign up for a free <a href="https://tvlistings.zap2it.com">Zap2it</a> account. To modify the crontab run  <b>'crontab -e -u xteve'</b> from a command prompt terminal 
inside the container. You will need to add the zap2XML XMLTV file located in <b>$XTEVE_CONF/data/zap2xml.xml</b>  to <b>xTeVe->XMLTV</b> once it has been generated on the first run. The sample crontab runs at 1:15 AM on sundays.

<p><b>/usr/bin/perl /home/xteve/bin/zap2xml.pl -u username@domain.com -p  ******** -U -c $XTEVE_HOME/cache/zap2xml -o
$XTEVE_CONF/data/zap2xml.xml</b></p>

<br>
<br>

<h2 id="zap2XML Crontab">zap2XML TVGuide Crontab</h2>

Support for tvguide.com is also now available in this image.  A sample crontab has been created to run the zap2XML TVGuide configuration on a weekly basis. You will need to sign up for a free <a href="https://tvlistings.zap2it.com">Zap2it</a> account. To modify the crontab run  <b>'crontab -e -u xteve'</b> from a command prompt terminal inside the container. You will need to add the zap2XML TVGuide XMLTV file located in <b>$XTEVE_CONF/data/tvguide.xml</b>  to <b>xTeVe->XMLTV</b> once it has been generated on the first run. The sample crontab runs at 1:15 AM on sundays.

<p><b>/usr/bin/perl /home/xteve/bin/zap2xml.pl -z -u username@domain.com -p ******** -U -c $XTEVE_HOME/cache/tvguide -o $XTEVE_CONF/data/tvguide.xml</b></p>


Enjoy!
