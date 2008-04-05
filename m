Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from tor.lindesign.se ([194.17.154.111]:37844 "EHLO tor.lindesign.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751513AbYDELwz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 5 Apr 2008 07:52:55 -0400
Message-ID: <47F76814.7010405@tor.lindesign.se> (sfid-20080405_125257_931141_D658ECAC)
Date: Sat, 05 Apr 2008 13:52:52 +0200
From: Bachman Kharazmi <bachman@tor.lindesign.se>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: compat-wireless iwl4965 on hp/compaq 2510p
References: <47F75EB4.9090703@tor.lindesign.se>	 (sfid-20080405_124018_600873_72164D53) <1207396223.3860.9.camel@johannes.berg>
In-Reply-To: <1207396223.3860.9.camel@johannes.berg>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sure..
lapp:/tmp# iwconfig wlan0 essid planet_mars key B200A92732DA86E90DEFEFF3FB
stslapp:/tmp# iwconfig
lo        no wireless extensions.

eth1      no wireless extensions.

wmaster0  no wireless extensions.

wlan0     IEEE 802.11  ESSID:"planet_mars"
           Mode:Managed  Frequency:2.412 GHz  Access Point: Not-Associated
           Tx-Power=0 dBm
           Retry min limit:7   RTS thr:off   Fragment thr=2352 B
           Encryption key:B200-A927-32DA-86E9-0DEF-EFF3-FB
           Link Quality:0  Signal level:0  Noise level:0
           Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
           Tx excessive retries:0  Invalid misc:0   Missed beacon:0

lapp:/tmp# dhclient wlan0
There is already a pid file /var/run/dhclient.pid with pid 6907
killed old client process, removed PID file
Internet Systems Consortium DHCP Client V3.0.4
Copyright 2004-2006 Internet Systems Consortium.
All rights reserved.
For info, please visit http://www.isc.org/sw/dhcp/

wmaster0: unknown hardware address type 801
SIOCSIFFLAGS: No such device
SIOCSIFFLAGS: No such device
wmaster0: unknown hardware address type 801
Listening on LPF/wlan0/00:13:e8:81:40:d3
Sending on   LPF/wlan0/00:13:e8:81:40:d3
Sending on   Socket/fallback
receive_packet failed on wlan0: Network is down
DHCPDISCOVER on wlan0 to 255.255.255.255 port 67 interval 3
send_packet: Network is down
DHCPDISCOVER on wlan0 to 255.255.255.255 port 67 interval 8

Johannes Berg wrote:
>> lapp:~/temp/compat-wireless-2008-04-01# iwconfig
>> lo        no wireless extensions.
>> eth1      no wireless extensions.
>> wmaster0  no wireless extensions.
>> wlan0     IEEE 802.11  ESSID:""
>>            Mode:Managed  Frequency:2.412 GHz  Access Point: Not-Associated
> 
>> lapp:~/temp/compat-wireless-2008-04-01# dhclient wlan0
> 
> Have you considered connecting to a network before trying to use it?
> 
> johannes
