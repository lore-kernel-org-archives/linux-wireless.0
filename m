Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vc0-f176.google.com ([209.85.220.176]:33579 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752129AbaB0Rty (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Feb 2014 12:49:54 -0500
Received: by mail-vc0-f176.google.com with SMTP id la4so2811633vcb.21
        for <linux-wireless@vger.kernel.org>; Thu, 27 Feb 2014 09:49:54 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAOAOC6aWWh3y8b-iRsouxFV+d9oKSpL4hkeVyJ6sarGEVzyOdg@mail.gmail.com>
References: <CAOAOC6a96e5MrEOVY=KXirhUU-rJRv2hgz5B0so9SkWYMpoDfw@mail.gmail.com>
	<1393517094.4648.3.camel@jlt4.sipsolutions.net>
	<CAOAOC6agHr6mVB2jcUx1qHWnBJZyOw0=KP0Wp5BVhrvJgRhmQg@mail.gmail.com>
	<1393517627.4648.4.camel@jlt4.sipsolutions.net>
	<CAOAOC6ZhnB=LrJWvG07tOK=b_wWAFO74YdhXWZPxrVCk8=425A@mail.gmail.com>
	<CAOAOC6aoz43LdXBTcRHWqPMvQAVKsH6z4yNqe_hEpT7zouo+Ew@mail.gmail.com>
	<1393519119.4648.7.camel@jlt4.sipsolutions.net>
	<CAOAOC6Z5J8_-ZKVukxfz+_K402E5sjhTdBvf3TzsWUDgwqw0Zw@mail.gmail.com>
	<1393519539.4648.10.camel@jlt4.sipsolutions.net>
	<CAOAOC6aWWh3y8b-iRsouxFV+d9oKSpL4hkeVyJ6sarGEVzyOdg@mail.gmail.com>
Date: Thu, 27 Feb 2014 12:49:53 -0500
Message-ID: <CAOAOC6bzV8yZfOPRj1zCa0ONQ8VQ=vwBug6jga6LgzEADdk=Ww@mail.gmail.com> (sfid-20140227_184958_655025_93903F10)
Subject: Re: pci-half-mini 7260 Wireless AC support 3.13
From: Tim Nelson <tim.l.nelson@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Here are the logs when i set logging to informational for network-manager:

Feb 27 12:44:38 nix-tn NetworkManager[1040]: <info> Activation (wlan0)
starting connection 'corp-public'
Feb 27 12:44:38 nix-tn NetworkManager[1040]: <info> (wlan0): device
state change: disconnected -> prepare (reason 'none') [30 40 0]
Feb 27 12:44:38 nix-tn NetworkManager[1040]: <info> NetworkManager
state is now CONNECTING
Feb 27 12:44:38 nix-tn NetworkManager[1040]: <info> Activation (wlan0)
Stage 1 of 5 (Device Prepare) scheduled...
Feb 27 12:44:38 nix-tn NetworkManager[1040]: <info> (wlan0):
supplicant interface state: completed -> disconnected
Feb 27 12:44:38 nix-tn NetworkManager[1040]: <info> Activation (wlan0)
Stage 1 of 5 (Device Prepare) started...
Feb 27 12:44:38 nix-tn NetworkManager[1040]: <info> Activation (wlan0)
Stage 2 of 5 (Device Configure) scheduled...
Feb 27 12:44:38 nix-tn NetworkManager[1040]: <info> Activation (wlan0)
Stage 1 of 5 (Device Prepare) complete.
Feb 27 12:44:38 nix-tn NetworkManager[1040]: <info> Activation (wlan0)
Stage 2 of 5 (Device Configure) starting...
Feb 27 12:44:38 nix-tn NetworkManager[1040]: <info> (wlan0): device
state change: prepare -> config (reason 'none') [40 50 0]
Feb 27 12:44:38 nix-tn NetworkManager[1040]: <info> Activation
(wlan0/wireless): access point 'corp-public' has security, but secrets
are required.
Feb 27 12:44:38 nix-tn NetworkManager[1040]: <info> (wlan0): device
state change: config -> need-auth (reason 'none') [50 60 0]
Feb 27 12:44:38 nix-tn NetworkManager[1040]: <info> Activation (wlan0)
Stage 2 of 5 (Device Configure) complete.
Feb 27 12:44:38 nix-tn NetworkManager[1040]: <info> Activation (wlan0)
Stage 1 of 5 (Device Prepare) scheduled...
Feb 27 12:44:38 nix-tn dbus[571]: [system] Successfully activated
service 'org.freedesktop.nm_dispatcher'
Feb 27 12:44:38 nix-tn NetworkManager[1040]: <info> Activation (wlan0)
Stage 1 of 5 (Device Prepare) started...
Feb 27 12:44:38 nix-tn NetworkManager[1040]: <info> (wlan0): device
state change: need-auth -> prepare (reason 'none') [60 40 0]
Feb 27 12:44:38 nix-tn NetworkManager[1040]: <info> Activation (wlan0)
Stage 2 of 5 (Device Configure) scheduled...
Feb 27 12:44:38 nix-tn NetworkManager[1040]: <info> Activation (wlan0)
Stage 1 of 5 (Device Prepare) complete.
Feb 27 12:44:38 nix-tn NetworkManager[1040]: <info> Activation (wlan0)
Stage 2 of 5 (Device Configure) starting...
Feb 27 12:44:38 nix-tn NetworkManager[1040]: <info> (wlan0): device
state change: prepare -> config (reason 'none') [40 50 0]
Feb 27 12:44:38 nix-tn NetworkManager[1040]: <info> Activation
(wlan0/wireless): connection 'corp-public' has security, and secrets
exist.  No new secrets needed.
Feb 27 12:44:38 nix-tn NetworkManager[1040]: <info> Config: added
'ssid' value 'corp-public'
Feb 27 12:44:38 nix-tn NetworkManager[1040]: <info> Config: added
'scan_ssid' value '1'
Feb 27 12:44:38 nix-tn NetworkManager[1040]: <info> Config: added
'key_mgmt' value 'WPA-PSK'
Feb 27 12:44:38 nix-tn NetworkManager[1040]: <info> Config: added
'auth_alg' value 'OPEN'
Feb 27 12:44:38 nix-tn NetworkManager[1040]: <info> Config: added
'psk' value '<omitted>'
Feb 27 12:44:38 nix-tn NetworkManager[1040]: <info> Activation (wlan0)
Stage 2 of 5 (Device Configure) complete.
Feb 27 12:44:38 nix-tn NetworkManager[1040]: <info> Config: set
interface ap_scan to 1
Feb 27 12:44:39 nix-tn wpa_supplicant[1326]: wlan0: Failed to initiate AP scan
Feb 27 12:44:41 nix-tn wpa_supplicant[1326]: message repeated 2 times:
[ wlan0: Failed to initiate AP scan]
Feb 27 12:44:41 nix-tn wpa_supplicant[1326]: wlan0: SME: Trying to
authenticate with 08:cc:68:cc:df:ab (SSID='corp-public' freq=5180 MHz)
Feb 27 12:44:41 nix-tn kernel: [ 1733.272381] wlan0: authenticate with
08:cc:68:cc:df:ab
Feb 27 12:44:41 nix-tn kernel: [ 1733.272390] wlan0: AP VHT
information is invalid, disable VHT
Feb 27 12:44:41 nix-tn kernel: [ 1733.274110] wlan0: send auth to
08:cc:68:cc:df:ab (try 1/3)
Feb 27 12:44:41 nix-tn kernel: [ 1733.274997] wlan0: authenticated
Feb 27 12:44:41 nix-tn wpa_supplicant[1326]: wlan0: Trying to
associate with 08:cc:68:cc:df:ab (SSID='corp-public' freq=5180 MHz)
Feb 27 12:44:41 nix-tn kernel: [ 1733.277165] wlan0: associate with
08:cc:68:cc:df:ab (try 1/3)
Feb 27 12:44:41 nix-tn kernel: [ 1733.280564] wlan0: RX AssocResp from
08:cc:68:cc:df:ab (capab=0x11 status=0 aid=60)
Feb 27 12:44:41 nix-tn wpa_supplicant[1326]: wlan0: Associated with
08:cc:68:cc:df:ab
Feb 27 12:44:41 nix-tn kernel: [ 1733.281381] wlan0: associated
Feb 27 12:44:41 nix-tn kernel: [ 1733.281446] cfg80211: Calling CRDA
for country: US
Feb 27 12:44:41 nix-tn kernel: [ 1733.286106] cfg80211: Regulatory
domain changed to country: US
Feb 27 12:44:41 nix-tn kernel: [ 1733.286110] cfg80211:   (start_freq
- end_freq @ bandwidth), (max_antenna_gain, max_eirp)
Feb 27 12:44:41 nix-tn kernel: [ 1733.286113] cfg80211:   (2402000 KHz
- 2472000 KHz @ 40000 KHz), (300 mBi, 2700 mBm)
Feb 27 12:44:41 nix-tn kernel: [ 1733.286116] cfg80211:   (5170000 KHz
- 5250000 KHz @ 40000 KHz), (300 mBi, 1700 mBm)
Feb 27 12:44:41 nix-tn kernel: [ 1733.286119] cfg80211:   (5250000 KHz
- 5330000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Feb 27 12:44:41 nix-tn kernel: [ 1733.286121] cfg80211:   (5490000 KHz
- 5600000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Feb 27 12:44:41 nix-tn kernel: [ 1733.286124] cfg80211:   (5650000 KHz
- 5710000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Feb 27 12:44:41 nix-tn kernel: [ 1733.286126] cfg80211:   (5735000 KHz
- 5835000 KHz @ 40000 KHz), (300 mBi, 3000 mBm)
Feb 27 12:44:41 nix-tn kernel: [ 1733.286139] cfg80211:   (57240000
KHz - 63720000 KHz @ 2160000 KHz), (N/A, 4000 mBm)
Feb 27 12:44:41 nix-tn wpa_supplicant[1326]: wlan0: WPA: Key
negotiation completed with 08:cc:68:cc:df:ab [PTK=CCMP GTK=CCMP]
Feb 27 12:44:41 nix-tn wpa_supplicant[1326]: wlan0:
CTRL-EVENT-CONNECTED - Connection to 08:cc:68:cc:df:ab completed
(reauth) [id=0 id_str=]
Feb 27 12:44:41 nix-tn NetworkManager[1040]: <info> (wlan0):
supplicant interface state: disconnected -> associating
Feb 27 12:44:41 nix-tn NetworkManager[1040]: <info> (wlan0):
supplicant interface state: associating -> 4-way handshake
Feb 27 12:44:41 nix-tn NetworkManager[1040]: <info> (wlan0):
supplicant interface state: 4-way handshake -> completed
Feb 27 12:44:41 nix-tn NetworkManager[1040]: <info> Activation
(wlan0/wireless) Stage 2 of 5 (Device Configure) successful.
Connected to wireless network 'corp-public'.
Feb 27 12:44:41 nix-tn NetworkManager[1040]: <info> Activation (wlan0)
Stage 3 of 5 (IP Configure Start) scheduled.
Feb 27 12:44:41 nix-tn NetworkManager[1040]: <info> Activation (wlan0)
Stage 3 of 5 (IP Configure Start) started...
Feb 27 12:44:41 nix-tn NetworkManager[1040]: <info> (wlan0): device
state change: config -> ip-config (reason 'none') [50 70 0]
Feb 27 12:44:41 nix-tn NetworkManager[1040]: <info> Activation (wlan0)
Beginning DHCPv4 transaction (timeout in 45 seconds)
Feb 27 12:44:41 nix-tn NetworkManager[1040]: <info> dhclient started
with pid 5596
Feb 27 12:44:41 nix-tn NetworkManager[1040]: <info> Activation (wlan0)
Beginning IP6 addrconf.
Feb 27 12:44:41 nix-tn avahi-daemon[657]: Withdrawing address record
for fe80::e8b:fdff:fe32:dec6 on wlan0.
Feb 27 12:44:41 nix-tn avahi-daemon[657]: Leaving mDNS multicast group
on interface wlan0.IPv6 with address fe80::e8b:fdff:fe32:dec6.
Feb 27 12:44:41 nix-tn avahi-daemon[657]: Interface wlan0.IPv6 no
longer relevant for mDNS.
Feb 27 12:44:41 nix-tn NetworkManager[1040]: <info> Activation (wlan0)
Stage 3 of 5 (IP Configure Start) complete.
Feb 27 12:44:41 nix-tn dhclient: Internet Systems Consortium DHCP Client 4.2.4
Feb 27 12:44:41 nix-tn dhclient: Copyright 2004-2012 Internet Systems
Consortium.
Feb 27 12:44:41 nix-tn dhclient: All rights reserved.
Feb 27 12:44:41 nix-tn dhclient: For info, please visit
https://www.isc.org/software/dhcp/
Feb 27 12:44:41 nix-tn dhclient:
Feb 27 12:44:41 nix-tn dhclient:
/var/lib/NetworkManager/dhclient-wlan0.conf line 21: semicolon
expected.
Feb 27 12:44:41 nix-tn dhclient: prepend domain-name-servers 8.8.8.8 172.
Feb 27 12:44:41 nix-tn dhclient:                                      ^
Feb 27 12:44:41 nix-tn dhclient:
/var/lib/NetworkManager/dhclient-wlan0.conf line 21: expecting a
statement.
Feb 27 12:44:41 nix-tn dhclient: prepend domain-name-servers 8.8.8.8
172.22.227.70;
Feb 27 12:44:41 nix-tn dhclient:
            ^
Feb 27 12:44:41 nix-tn dhclient:
/var/lib/NetworkManager/dhclient-wlan0.conf line 55: semicolon
expected.
Feb 27 12:44:41 nix-tn dhclient: send
Feb 27 12:44:41 nix-tn dhclient: ^
Feb 27 12:44:41 nix-tn dhclient: Listening on LPF/wlan0/0c:8b:fd:32:de:c6
Feb 27 12:44:41 nix-tn dhclient: Sending on   LPF/wlan0/0c:8b:fd:32:de:c6
Feb 27 12:44:41 nix-tn dhclient: Sending on   Socket/fallback
Feb 27 12:44:41 nix-tn dhclient: DHCPREQUEST of 192.168.67.41 on wlan0
to 255.255.255.255 port 67 (xid=0x4bc14984)
Feb 27 12:44:41 nix-tn NetworkManager[1040]: <info> (wlan0): DHCPv4
state changed nbi -> preinit
Feb 27 12:44:43 nix-tn avahi-daemon[657]: Joining mDNS multicast group
on interface wlan0.IPv6 with address fe80::e8b:fdff:fe32:dec6.
Feb 27 12:44:43 nix-tn avahi-daemon[657]: New relevant interface
wlan0.IPv6 for mDNS.
Feb 27 12:44:43 nix-tn avahi-daemon[657]: Registering new address
record for fe80::e8b:fdff:fe32:dec6 on wlan0.*.
Feb 27 12:44:44 nix-tn dhclient: DHCPREQUEST of 192.168.67.41 on wlan0
to 255.255.255.255 port 67 (xid=0x4bc14984)
Feb 27 12:44:44 nix-tn dhclient: DHCPACK of 192.168.67.41 from 1.1.1.1
Feb 27 12:44:44 nix-tn dhclient: bound to 192.168.67.41 -- renewal in
6110 seconds.
Feb 27 12:44:44 nix-tn NetworkManager[1040]: <info> (wlan0): DHCPv4
state changed preinit -> reboot
Feb 27 12:44:44 nix-tn NetworkManager[1040]: <info>   address 192.168.67.41
Feb 27 12:44:44 nix-tn NetworkManager[1040]: <info>   prefix 22 (255.255.252.0)
Feb 27 12:44:44 nix-tn NetworkManager[1040]: <info>   gateway 192.168.64.1
Feb 27 12:44:44 nix-tn NetworkManager[1040]: <info>   nameserver '8.8.8.8'
Feb 27 12:44:44 nix-tn NetworkManager[1040]: <info>   nameserver '8.8.4.4'
Feb 27 12:44:44 nix-tn NetworkManager[1040]: <info>   nameserver '4.2.2.2'
Feb 27 12:44:44 nix-tn NetworkManager[1040]: <info> Activation (wlan0)
Stage 5 of 5 (IPv4 Configure Commit) scheduled...
Feb 27 12:44:44 nix-tn NetworkManager[1040]: <info> Activation (wlan0)
Stage 5 of 5 (IPv4 Commit) started...
Feb 27 12:44:44 nix-tn avahi-daemon[657]: Joining mDNS multicast group
on interface wlan0.IPv4 with address 192.168.67.41.
Feb 27 12:44:44 nix-tn avahi-daemon[657]: New relevant interface
wlan0.IPv4 for mDNS.
Feb 27 12:44:44 nix-tn avahi-daemon[657]: Registering new address
record for 192.168.67.41 on wlan0.IPv4.
Feb 27 12:44:45 nix-tn NetworkManager[1040]: <info> (wlan0): device
state change: ip-config -> secondaries (reason 'none') [70 90 0]
Feb 27 12:44:45 nix-tn NetworkManager[1040]: <info> Activation (wlan0)
Stage 5 of 5 (IPv4 Commit) complete.
Feb 27 12:44:45 nix-tn NetworkManager[1040]: <info> (wlan0): device
state change: secondaries -> activated (reason 'none') [90 100 0]
Feb 27 12:44:45 nix-tn NetworkManager[1040]: <info> NetworkManager
state is now CONNECTED_GLOBAL
Feb 27 12:44:45 nix-tn NetworkManager[1040]: <info> Policy set
'corp-public' (wlan0) as default for IPv4 routing and DNS.
Feb 27 12:44:45 nix-tn NetworkManager[1040]: <info> Writing DNS
information to /sbin/resolvconf
Feb 27 12:44:45 nix-tn dnsmasq[1819]: setting upstream servers from DBus
Feb 27 12:44:45 nix-tn dnsmasq[1819]: using nameserver 4.2.2.2#53
Feb 27 12:44:45 nix-tn dnsmasq[1819]: using nameserver 8.8.4.4#53
Feb 27 12:44:45 nix-tn dnsmasq[1819]: using nameserver 8.8.8.8#53
Feb 27 12:44:45 nix-tn NetworkManager[1040]: <info> (wlan0): roamed
from BSSID 08:CC:68:CC:DF:A4 (corp-public) to 08:CC:68:CC:DF:AB
(corp-public)

On Thu, Feb 27, 2014 at 12:21 PM, Tim Nelson <tim.l.nelson@gmail.com> wrote:
> I see nothing at all in my dmesg when I connect to it.  As well,
> running Ubuntu, I do not have a wpa_supplicant.log.
>
> It's not that it errors at all, in fact it works quite well.  The
> problem lies with the fact it's not actually doing AC.  Although it is
> doing very well with N.
>
> On Thu, Feb 27, 2014 at 11:45 AM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
>> On Thu, 2014-02-27 at 11:41 -0500, Tim Nelson wrote:
>>> [    9.299536] iwlwifi 0000:02:00.0: Detected Intel(R) Dual Band
>>> Wireless AC 7260, REV=0x144
>>
>> Hm ok that should support it. Maybe it's always connecting to the 2.4
>> GHz one for some reason? That seems unlikely but still possible...
>>
>> Maybe you could get more dmesg data about the AP it selected, and the
>> wpa_supplicant log.
>>
>> johannes
>>
