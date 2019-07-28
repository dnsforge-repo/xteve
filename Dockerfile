FROM alpine:latest
RUN apk update
RUN apk upgrade
RUN apk add --no-cache ca-certificates

MAINTAINER LeeD <hostmaster@dnsforge.com>

LABEL VERSION=1.0.2
LABEL SUPPORT_URL=https://discord.gg/eWYquha

ENV XTEVE_USER=xteve
ENV XTEVE_UID=31337
ENV XTEVE_GID=31337
ENV XTEVE_HOME=/home/xteve
ENV XTEVE_TEMP=/tmp/xteve
ENV XTEVE_BIN=/home/xteve/bin
ENV XTEVE_CONF=/home/xteve/conf
ENV XTEVE_PORT=34400
ENV XTEVE_LOG=/var/log/xteve.log
ENV XTEVE_URL=https://github.com/dnsforge-repo/xteve-test/blob/master/xteve-2.0.tar.gz?raw=true
ENV GUIDE2GO_HOME=/home/xteve/guide2go
ENV GUIDE2GO_CONF=/home/xteve/guide2go/conf

ENV PERL_MM_USE_DEFAULT=1
ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:$XTEVE_BIN

# Set working directory
WORKDIR $XTEVE_HOME

# Add Bash shell & dependancies
RUN apk add --no-cache bash busybox-suid su-exec

# Timezone (TZ):  Add the tzdata package and configure for EST timezone.
# This will override the default container time in UTC.
RUN apk update && apk add --no-cache tzdata
ENV TZ=America/New_York
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Install Perl for Zap2it support
RUN apk add --no-cache \
perl-dev \
build-base \
perl-html-parser \
perl-http-cookies \
perl-json \
perl-lwp-protocol-https \
perl-lwp-useragent-determined

# Pull the required binaries for xTeVe, Guide2go and Zap2XML from the repos.
ADD /bin/xteve_starter.pl $XTEVE_BIN/xteve_starter.pl
RUN wget $XTEVE_URL -O xteve-2.0.tar.gz \
&& tar zxfvp xteve-2.0.tar.gz -C $XTEVE_BIN && rm -f $XTEVE_HOME/xteve-2.0.tar.gz
ADD /bin/guide2go $XTEVE_BIN/guide2go
ADD /bin/guide2go.json $GUIDE2GO_CONF/guide2go.json
ADD /bin/zap2xml.pl $XTEVE_BIN/zap2xml.pl

# Set binary executable permissions.
RUN chmod +x $XTEVE_BIN/xteve_starter.pl
RUN chmod +x $XTEVE_BIN/xteve
RUN chmod +x $XTEVE_BIN/guide2go
RUN chmod +rx $XTEVE_BIN/zap2xml.pl

# Configure container volume mappings
VOLUME $XTEVE_CONF
VOLUME $XTEVE_TEMP

# Set default container port 
EXPOSE 34400

# Run the xTeVe init script
ENTRYPOINT $XTEVE_BIN/xteve_starter.pl
