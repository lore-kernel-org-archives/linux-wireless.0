Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nm22.bullet.mail.ird.yahoo.com ([212.82.108.137]:41004 "HELO
	nm22.bullet.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751131Ab2G0Qnr convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Jul 2012 12:43:47 -0400
References: <CAKjQTCesBzbjbv4T+RPRutrgTyJoXJciwsKqPAxZDDcvot=q5g@mail.gmail.com> <500DBD17.7070706@lwfinger.net> <1343138030.94415.YahooMailNeo@web28906.mail.ir2.yahoo.com> <1343138193.40429.YahooMailNeo@web28904.mail.ir2.yahoo.com> <500EBA0C.106@lwfinger.net> <1343143522.46747.YahooMailNeo@web28903.mail.ir2.yahoo.com> <1343149616.67668.YahooMailNeo@web28904.mail.ir2.yahoo.com> <500EE086.6000304@lwfinger.net> <1343224463.22151.YahooMailNeo@web28906.mail.ir2.yahoo.com> <1343236780.36289.YahooMailNeo@web28901.mail.ir2.yahoo.com> <1343237104.35808.YahooMailNeo@web28905.mail.ir2.yahoo.com> <5010304E.6070005@lwfinger.net> <1343296732.22680.YahooMailNeo@web28905.mail.ir2.yahoo.com> <501121B5.4010305@lwfinger.net> <1343300503.96939.YahooMailNeo@web28902.mail.ir2.yahoo.com> <501129D9.4060407@lwfinger.net> <1343314190.31952.YahooMailNeo@web28901.mail.ir2.yahoo.com> <5011BC0A.8060600@lwfinger.net> <1343370892.97699.YahooMailNeo@web28904.mail.ir2.yahoo.com> <501280BF.4070409@lwfinger.net> <1343394581.87030.YahooMailNeo@web28902.mail.ir2.yahoo.com> <1343398356.19742.YahooMailNeo@web28904.mail.ir2.yahoo.com> <1343403507.54955.YahooMailNeo@web28906.mail.ir2.yahoo.com> <1343404770.91235.YahooMailNeo@web28906.mail.ir2.yahoo.com>
Message-ID: <1343407089.96532.YahooMailNeo@web28901.mail.ir2.yahoo.com> (sfid-20120727_184351_608176_3AB2B6A9)
Date: Fri, 27 Jul 2012 17:38:09 +0100 (BST)
From: Xavier de Almeida <xavierdealmeida@yahoo.fr>
Reply-To: Xavier de Almeida <xavierdealmeida@yahoo.fr>
Subject: Re: Tr : Tr : Can't make RTL8188CE work with hostapd (rtl8192ce)
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Cc: Larry Finger <Larry.Finger@lwfinger.net>
In-Reply-To: <1343404770.91235.YahooMailNeo@web28906.mail.ir2.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Without touching anything it started to work:

Jul 27 18:34:27 HTPC hostapd: wlan0: STA 88:30:8a:52:ed:cd IEEE 802.11: association OK (aid 1)
Jul 27 18:34:27 HTPC hostapd: wlan0: STA 88:30:8a:52:ed:cd IEEE 802.11: associated (aid 1)
Jul 27 18:34:27 HTPC hostapd: wlan0: STA 88:30:8a:52:ed:cd MLME: MLME-ASSOCIATE.indication(88:30:8a:52:ed:cd)
Jul 27 18:34:27 HTPC hostapd: wlan0: STA 88:30:8a:52:ed:cd MLME: MLME-DELETEKEYS.request(88:30:8a:52:ed:cd)
Jul 27 18:34:27 HTPC hostapd: wlan0: STA 88:30:8a:52:ed:cd WPA: event 1 notification
Jul 27 18:34:27 HTPC hostapd: wlan0: STA 88:30:8a:52:ed:cd WPA: start authentication
Jul 27 18:34:27 HTPC hostapd: wlan0: STA 88:30:8a:52:ed:cd IEEE 802.1X: unauthorizing port
Jul 27 18:34:27 HTPC hostapd: wlan0: STA 88:30:8a:52:ed:cd WPA: sending 1/4 msg of 4-Way Handshake
Jul 27 18:34:27 HTPC hostapd: wlan0: STA 88:30:8a:52:ed:cd WPA: received EAPOL-Key frame (2/4 Pairwise)
Jul 27 18:34:27 HTPC hostapd: wlan0: STA 88:30:8a:52:ed:cd WPA: sending 3/4 msg of 4-Way Handshake
Jul 27 18:34:27 HTPC hostapd: wlan0: STA 88:30:8a:52:ed:cd WPA: received EAPOL-Key frame (4/4 Pairwise)
Jul 27 18:34:27 HTPC hostapd: wlan0: STA 88:30:8a:52:ed:cd IEEE 802.1X: authorizing port
Jul 27 18:34:27 HTPC hostapd: wlan0: STA 88:30:8a:52:ed:cd RADIUS: starting accounting session 5012BD3F-00000000
Jul 27 18:34:27 HTPC hostapd: wlan0: STA 88:30:8a:52:ed:cd WPA: pairwise key handshake completed (RSN)

but the signal is very weak so maybe that was one of the issues.

I am looking fwd to remove the power mgt stuff and maybe find out how to increase the signal power. Maybe I should be a kind of antennat but not sure this will work with a barebone like the xs36v.

Merci

----- Mail original -----
> De : Xavier de Almeida <xavierdealmeida@yahoo.fr>
> À : "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
> Cc : Larry Finger <Larry.Finger@lwfinger.net>
> Envoyé le : Vendredi 27 juillet 2012 17h59
> Objet : Re: Tr : Tr : Can't make RTL8188CE work with hostapd (rtl8192ce)
> 
> Larry can you tell me what do you have for power mgt settings in
> 
> /etc/modprobe.d/rtl8192ce.conf 
> options rtl8192ce ips=0 swenc=1
> 
> systool -v -m rtl8192ce
> Module = "rtl8192ce"
> 
>   Attributes:
>     coresize            = "74421"
>     initsize            = "0"
>     initstate           = "live"
>     refcnt              = "0"
>     srcversion          = "AE758D5E662358264A4DB35"
>     taint               = ""
>     uevent              = <store method only>
> 
>   Parameters:
>     debug               = "0"
>     fwlps               = "Y"
>     ips                 = "N"
>     swenc               = "Y"
>     swlps               = "N"
> 
>   Sections:
>     .altinstr_replacement= "0x00000000"
>     .altinstructions    = "0x00000000"
>     .bss                = "0x00000000"
>     .data               = "0x00000000"
>     .devinit.rodata     = "0x00000000"
>     .exit.text          = "0x00000000"
>     .gnu.linkonce.this_module= "0x00000000"
>     .init.text          = "0x00000000"
>     .note.gnu.build-id  = "0x00000000"
>     .parainstructions   = "0x00000000"
>     .rodata             = "0x00000000"
>     .rodata.str1.1      = "0x00000000"
>     .rodata.str1.4      = "0x00000000"
>     .strtab             = "0x00000000"
>     .symtab             = "0x00000000"
>     .text               = "0x00000000"
>     __mcount_loc        = "0x00000000"
>     __param             = "0x00000000"
> 
> Thanks
> XabiX
> 
> 
> ----- Mail original -----
>>  De : Xavier de Almeida <xavierdealmeida@yahoo.fr>
>>  À : "linux-wireless@vger.kernel.org" 
> <linux-wireless@vger.kernel.org>
>>  Cc : Larry Finger <Larry.Finger@lwfinger.net>
>>  Envoyé le : Vendredi 27 juillet 2012 17h38
>>  Objet : Re: Tr : Tr : Can't make RTL8188CE work with hostapd 
> (rtl8192ce)
>> 
>>>   Hi Larry,
>> 
>>> 
>>>   So after rebooting (and installing the compat drivers from 05-10) it 
> seems 
>>  to 
>>>   work meaning that the process runs:
>>> 
>>>   5 S root      1486     1  0  80   0 -  1415 poll_s 16:03 ?       
>  00:00:00 
>>>   /usr/sbin/hostapd -B -P /var/run/hostapd.pid -dd 
> /etc/hostapd/hostapd.conf
>>> 
>>> 
>>>   Jul 27 16:06:15 HTPC hostapd: wlan0: STA 88:30:8a:52:ed:cd IEEE 
> 802.11: 
>>>   authentication OK (open system)
>>>   Jul 27 16:06:15 HTPC hostapd: wlan0: STA 88:30:8a:52:ed:cd IEEE 
> 802.11: 
>>>   authenticated
>>>   Jul 27 16:06:15 HTPC hostapd: wlan0: STA 88:30:8a:52:ed:cd IEEE 
> 802.11: 
>>>   association OK (aid 1)
>>>   Jul 27 16:06:15 HTPC hostapd: wlan0: STA 88:30:8a:52:ed:cd IEEE 
> 802.11: 
>>>   associated (aid 1)
>>>   Jul 27 16:06:18 HTPC hostapd: wlan0: STA 88:30:8a:52:ed:cd IEEE 
> 802.11: 
>>>   deauthenticated due to local deauth request
>>>   Jul 27 16:06:22 HTPC hostapd: wlan0: STA 88:30:8a:52:ed:cd IEEE 
> 802.11: 
>>>   authentication OK (open system)
>>>   Jul 27 16:06:22 HTPC hostapd: wlan0: STA 88:30:8a:52:ed:cd IEEE 
> 802.11: 
>>>   authenticated
>>>   Jul 27 16:06:22 HTPC hostapd: wlan0: STA 88:30:8a:52:ed:cd IEEE 
> 802.11: 
>>>   association OK (aid 1)
>>>   Jul 27 16:06:22 HTPC hostapd: wlan0: STA 88:30:8a:52:ed:cd IEEE 
> 802.11: 
>>>   associated (aid 1)
>>>   Jul 27 16:06:25 HTPC hostapd: wlan0: STA 88:30:8a:52:ed:cd IEEE 
> 802.11: 
>>>   deauthenticated due to local deauth request
>>>   Jul 27 16:06:29 HTPC hostapd: wlan0: STA 88:30:8a:52:ed:cd IEEE 
> 802.11: 
>>>   authentication OK (open system)
>>>   Jul 27 16:06:29 HTPC hostapd: wlan0: STA 88:30:8a:52:ed:cd IEEE 
> 802.11: 
>>>   authenticated
>>>   Jul 27 16:06:29 HTPC hostapd: wlan0: STA 88:30:8a:52:ed:cd IEEE 
> 802.11: 
>>>   association OK (aid 1)
>>>   Jul 27 16:06:29 HTPC hostapd: wlan0: STA 88:30:8a:52:ed:cd IEEE 
> 802.11: 
>>>   associated (aid 1)
>>> 
>>>   but I launch manually it doesn't work anymore
>>> 
>>>   xabix@HTPC:~$ sudo service hostapd stop
>>>   [sudo] password for xabix: 
>>>    * Stopping advanced IEEE 802.11 management hostapd
>>>      ...done.
>>>   xabix@HTPC:~$ /usr/sbin/hostapd -B -P /var/run/hostapd.pid -dd 
>>>   /etc/hostapd/hostapd.conf
>>>   Configuration file: /etc/hostapd/hostapd.conf
>>>   ctrl_interface_group=0
>>>   nl80211: Register Action command failed: ret=-1 (Operation not 
> permitted)
>>>   nl80211: Register Action match - hexdump(len=1): 06
>>>   nl80211: Failed to register Action frame processing - ignore for now
>>>   nl80211: Add own interface ifindex 3
>>>   nl80211: Add own interface ifindex 4
>>>   nl80211: Failed to set interface 4 to mode 3: -1 (Operation not 
> permitted)
>>>   nl80211: Failed to set interface 4 to mode 3: -1 (Operation not 
> permitted)
>>>   Could not set interface wlan0 flags: Permission denied
>>>   nl80211: Interface mode change to 3 from 0 failed
>>>   nl80211: Failed to set interface wlan0 into AP mode
>>>   nl80211 driver initialization failed.
>>>   rmdir[ctrl_interface]: No such file or directory
>>>   ELOOP: remaining socket: sock=4 eloop_data=0x9cdc910 
> user_data=0x9cde780 
>>>   handler=0x807c
>>> 
>>> 
>>>   so the only to launch it for now is to reboot :)
>>> 
>>>   I dit put this on the conf file
>>>   # Levels (minimum value for logged events):
>>>   #  0 = verbose debugging
>>>   #  1 = debugging
>>>   #  2 = informational messages
>>>   #  3 = notification
>>>   #  4 = warning
>>>   logger_syslog=1
>>>   logger_syslog_level=0
>>> 
>>> 
>>>   but I don't see enough logs to know why after the association 
> there is 
>>  a 
>>>   deauthentication.
>>> 
>>>   Cheers
>>>   almost there :D
>> 
>> 
>>  Too me it looks like it's working but the isc-dhcp-relay dies when the 
>>  interface goes down for power mgt;
>> 
>>  xabix@HTPC:~$ sudo tcpdump -n -i br0 port bootps or port bootpc
>>  [sudo] password for xabix: 
>>  tcpdump: verbose output suppressed, use -v or -vv for full protocol decode
>>  listening on br0, link-type EN10MB (Ethernet), capture size 65535 bytes
>>  16:42:48.997437 IP 0.0.0.0.68 > 255.255.255.255.67: BOOTP/DHCP, Request 
> from 
>>  88:30:8a:52:ed:cd, length 356
>> 
>> 
>>  Jul 27 16:10:31 HTPC dhcrelay: receive_packet failed on wlan0: Network is 
> down
>> 
>>  Jul 27 16:43:50 HTPC NetworkManager[1282]: <info> Unmanaged Device 
> found; 
>>  state CONNECTED forced. (see http://bugs.launchpad.net/bugs/191889)
>>  Jul 27 16:43:50 HTPC NetworkManager[1282]: <info> Unmanaged Device 
> found; 
>>  state CONNECTED forced. (see http://bugs.launchpad.net/bugs/191889)
>>  Jul 27 17:32:00 HTPC kernel: [ 5321.199053] init: isc-dhcp-relay main 
> process 
>>  (4351) terminated with status 1
>>  Jul 27 17:32:00 HTPC kernel: [ 5321.199116] init: isc-dhcp-relay main 
> process 
>>  ended, respawning
>>  Jul 27 17:32:00 HTPC dhcrelay: Usage: dhcrelay [-4] [-d] [-q] [-a] [-D]#012 
>     
>>                  [-A <length>] [-c <hops>] [-p <port>]#012 
>     
>>                  [-pf <pid-file>] [--no-pid]#012                     
> [-m 
>>  append|replace|forward|discard]#012                     [-i interface0 [ 
> ... -i 
>>  interfaceN]#012                     server0 [ ... serverN]#012#012       
>>  dhcrelay -6   [-d] [-q] [-I] [-c <hops>] [-p <port>]#012       
>       
>>          [-pf <pid-file>] [--no-pid]#012                     -l lower0 
> [ 
>>  ... -l lowerN]#012                     -u upper0 [ ... -u upperN]#012       
> 
>>  lower (client link): [address%]interface[#index]#012       upper (server 
> link): 
>>  [address%]interface
>>  Jul 27 17:32:00 HTPC kernel: [ 5321.209552] init: isc-dhcp-relay main 
> process 
>>  (4353) terminated with status 1
>>  Jul 27 17:32:00 HTPC kernel: [ 5321.209637] init: isc-dhcp-relay main 
> process 
>>  ended, respawning
>>  Jul 27 17:32:00 HTPC dhcrelay: Usage: dhcrelay [-4] [-d] [-q] [-a] [-D]#012 
>     
>>                  [-A <length>] [-c <hops>] [-p <port>]#012 
>     
>>                  [-pf <pid-file>] [--no-pid]#012                     
> [-m 
>>  append|replace|forward|discard]#012                     [-i interface0 [ 
> ... -i 
>>  interfaceN]#012                     server0 [ ... serverN]#012#012       
>>  dhcrelay -6   [-d] [-q] [-I] [-c <hops>] [-p <port>]#012       
>       
>>          [-pf <pid-file>] [--no-pid]#012                     -l lower0 
> [ 
>>  ... -l lowerN]#012                     -u upper0 [ ... -u upperN]#012       
> 
>>  lower (client link): [address%]interface[#index]#012       upper (server 
> link): 
>>  [address%]interface
>>  Jul 27 17:32:00 HTPC kernel: [ 5321.220074] init: isc-dhcp-relay main 
> process 
>>  (4355) terminated with status 1
>>  Jul 27 17:32:00 HTPC kernel: [ 5321.220143] init: isc-dhcp-relay main 
> process 
>>  ended, respawning
>> 
> 
