Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f49.google.com ([209.85.160.49]:41235 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750861Ab3JVWo7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Oct 2013 18:44:59 -0400
Received: by mail-pb0-f49.google.com with SMTP id xb12so45264pbc.22
        for <linux-wireless@vger.kernel.org>; Tue, 22 Oct 2013 15:44:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CA+fsWUr=_MT+m9P_=XRj_mnUzcmvgAZA0tME8CP+3ho8pGY5qQ@mail.gmail.com>
References: <CA+fsWUr=_MT+m9P_=XRj_mnUzcmvgAZA0tME8CP+3ho8pGY5qQ@mail.gmail.com>
From: rl <rl608742063@gmail.com>
Date: Wed, 23 Oct 2013 00:44:38 +0200
Message-ID: <CA+fsWUq=Jg8mbJUr995pp2q5nCJBoLEgX9Zj_6=jDt0SSiOHPA@mail.gmail.com> (sfid-20131023_004502_957749_71E2F1F0)
Subject: Fwd: Problem with ALFA AWUS036h and openwrt
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

---------- Forwarded message ----------
From: rl <rl608742063@gmail.com>
Date: 2013/10/23
Subject: Problem with ALFA AWUS036h and openwrt
To: linux-wireless <linux-wireless@vger.kernel.org>



To: linux-wireless@vger.kernel.org

Hi,

I am trying to use  ALFA AWUS036h
in openwrt  kernel  3.3.8
#1  -OpenWrt revision r38455   Attitude_addiustement - card is connected to
usb port and there is a problem with drivers. The rtl8187  is installed.



There is short description of actions


WWPA2 PSK log shows when I am trying to connect to AP


Oct 21 17:01:43 OpenWrt kern.info kernel: [  796.610000] wlan0:
authenticate with 00:0c:03:10:1e:6d
Oct 21 17:01:44 OpenWrt kern.info kernel: [  796.890000] wlan0: send
auth to 00:0c:03:10:1e:6d (try 1/3)
Oct 21 17:01:44 OpenWrt kern.info kernel: [  796.910000] wlan0: authenticated
Oct 21 17:01:44 OpenWrt daemon.notice hostapd: wlan1: STA
00:c0:ca:66:66:6a IEEE 802.11: did not acknowledge authentication
response
Oct 21 17:01:44 OpenWrt kern.info kernel: [  796.940000] wlan0:
associate with 00:0c:03:10:1e:6d (try 1/3)
Oct 21 17:01:44 OpenWrt daemon.info hostapd: wlan1: STA
00:c0:ca:66:66:6a IEEE 802.11: associated (aid 1)
Oct 21 17:01:44 OpenWrt kern.info kernel: [  796.970000] wlan0: RX
AssocResp from 00:0c:03:10:1e:6d (capab=0x431 status=0 aid=1)
Oct 21 17:01:44 OpenWrt kern.info kernel: [  797.010000] wlan0: associated
Oct 21 17:01:46 OpenWrt user.info sysinit: ping: bad address 'google.com'
Oct 21 17:01:47 OpenWrt kern.info kernel: [  800.110000] wlan0:
deauthenticated from 00:0c:03:10:1e:6d (Reason: 2)
Oct 21 17:01:49 OpenWrt user.info sysinit: ping: bad address 'google.com'
Oct 21 17:01:52 OpenWrt daemon.info hostapd: wlan1: STA
00:c0:ca:66:66:6a IEEE 802.11: deauthenticated due to local deauth
request
Oct 21 17:01:52 OpenWrt user.info sysinit: ping: bad address 'google.com'
Oct 21 17:01:55 OpenWrt user.info sysinit: ping: bad address 'google.com'
Oct 21 17:01:58 OpenWrt user.info sysinit: ping: bad address 'google.com'
Oct 21 17:02:01 OpenWrt user.info sysinit: ping: bad address 'google.com'
Oct 21 17:02:01 OpenWrt cron.info crond[1311]: crond: USER root pid
4731 cmd /bin/tester.sh
Oct 21 17:02:02 OpenWrt daemon.notice netifd: Interface 'wan' is now down
Oct 21 17:02:04 OpenWrt user.info sysinit: ping: bad address 'google.com'
Oct 21 17:02:07 OpenWrt user.info sysinit: ping: bad address 'google.com'
Oct 21 17:02:09 OpenWrt kern.info kernel: [  821.940000] wlan0:
authenticate with 00:0c:03:10:1e:6d
Oct 21 17:02:09 OpenWrt kern.info kernel: [  822.230000] wlan0: send
auth to 00:0c:03:10:1e:6d (try 1/3)
Oct 21 17:02:09 OpenWrt kern.info kernel: [  822.450000] wlan0: send
auth to 00:0c:03:10:1e:6d (try 2/3)
Oct 21 17:02:09 OpenWrt kern.info kernel: [  822.670000] wlan0: send
auth to 00:0c:03:10:1e:6d (try 3/3)
Oct 21 17:02:09 OpenWrt daemon.notice hostapd: wlan1: STA
00:c0:ca:66:66:6a IEEE 802.11: did not acknowledge authentication
response
Oct 21 17:02:09 OpenWrt kern.info kernel: [  822.700000] wlan0: authenticated
Oct 21 17:02:09 OpenWrt kern.info kernel: [  822.710000] wlan0:
associate with 00:0c:03:10:1e:6d (try 1/3)
Oct 21 17:02:09 OpenWrt daemon.info hostapd: wlan1: STA
00:c0:ca:66:66:6a IEEE 802.11: associated (aid 1)
Oct 21 17:02:09 OpenWrt kern.info kernel: [  822.750000] wlan0: RX
AssocResp from 00:0c:03:10:1e:6d (capab=0x431 status=0 aid=1)
Oct 21 17:02:09 OpenWrt kern.info kernel: [  822.780000] wlan0: associated
Oct 21 17:02:10 OpenWrt user.info sysinit: ping: bad address 'google.com'
Oct 21 17:02:12 OpenWrt kern.info kernel: [  825.860000] wlan0:
deauthenticated from 00:0c:03:10:1e:6d (Reason: 2)
Oct 21 17:02:13 OpenWrt user.info sysinit: ping: bad address 'google.com'
Oct 21 17:02:16 OpenWrt user.info sysinit: ping: bad address 'google.com'
Oct 21 17:02:17 OpenWrt daemon.info hostapd: wlan1: STA
00:c0:ca:66:66:6a IEEE 802.11: deauthenticated due to local deauth
request
Oct 21 17:02:19 OpenWrt user.info sysinit: ping: bad address 'google.com'
Oct 21 17:02:22 OpenWrt user.info sysinit: ping: bad address 'google.com'
Oct 21 17:02:25 OpenWrt user.info sysinit: ping: bad address 'google.com'
Oct 21 17:02:29 OpenWrt user.info sysinit: ping: bad address 'google.com'
Oct 21 17:02:32 OpenWrt user.info sysinit: ping: bad address 'google.com'
Oct 21 17:02:34 OpenWrt kern.info kernel: [  847.760000] wlan0:
authenticate with 00:0c:03:10:1e:6d
Oct 21 17:02:35 OpenWrt user.info sysinit: ping: bad address 'google.com'
Oct 21 17:02:35 OpenWrt kern.info kernel: [  848.060000] wlan0: send
auth to 00:0c:03:10:1e:6d (try 1/3)
Oct 21 17:02:35 OpenWrt kern.info kernel: [  848.280000] wlan0: send
auth to 00:0c:03:10:1e:6d (try 2/3)
Oct 21 17:02:35 OpenWrt kern.info kernel: [  848.500000] wlan0: send
auth to 00:0c:03:10:1e:6d (try 3/3)
root@OpenWrt:/# logread
Oct 21 16:58:51 OpenWrt kern.info kernel: [  624.290000] br-lan: port
2(wlan1) entered disabled state
Oct 21 16:58:51 OpenWrt user.info sysinit: ping: bad address 'google.com'
Oct 21 16:58:52 OpenWrt daemon.notice netifd: Interface 'wwan' is now down
Oct 21 16:58:54 OpenWrt user.info sysinit: ping: bad address 'google.com'
Oct 21 16:58:57 OpenWrt user.info sysinit: ping: bad address 'google.com'
Oct 21 16:58:58 OpenWrt kern.info kernel: [  631.210000]
ADDRCONF(NETDEV_UP): wlan1: link is not ready
Oct 21 16:58:58 OpenWrt kern.info kernel: [  631.260000] device wlan1
entered promiscuous mode
Oct 21 16:58:58 OpenWrt kern.info kernel: [  631.410000]
ADDRCONF(NETDEV_UP): wlan1: link is not ready
Oct 21 16:58:59 OpenWrt kern.info kernel: [  632.360000] br-lan: port
2(wlan1) entered forwarding state
Oct 21 16:58:59 OpenWrt kern.info kernel: [  632.370000] br-lan: port
2(wlan1) entered forwarding state
Oct 21 16:58:59 OpenWrt kern.info kernel: [  632.380000]
ADDRCONF(NETDEV_CHANGE): wlan1: link becomes ready
Oct 21 16:59:00 OpenWrt user.info sysinit: ping: bad address 'google.com'
Oct 21 16:59:01 OpenWrt kern.info kernel: [  634.370000] br-lan: port
2(wlan1) entered forwarding state
Oct 21 16:59:03 OpenWrt user.info sysinit: ping: bad address 'google.com'
Oct 21 16:59:06 OpenWrt user.info sysinit: ping: bad address 'google.com'
Oct 21 16:59:07 OpenWrt kern.info kernel: [  640.350000]
ADDRCONF(NETDEV_UP): wlan0: link is not ready
Oct 21 16:59:09 OpenWrt user.info sysinit: ping: bad address 'google.com'
Oct 21 16:59:11 OpenWrt daemon.notice netifd: Interface 'wwan' is now up
Oct 21 16:59:12 OpenWrt daemon.info dnsmasq[3130]: exiting on receipt of SIGTERM
Oct 21 16:59:13 OpenWrt user.info sysinit: ping: bad address 'google.com'
Oct 21 16:59:13 OpenWrt user.notice firewall: Reloading firewall due
to ifup of wwan (wlan0)
Oct 21 16:59:16 OpenWrt user.info sysinit: ping: bad address 'google.com'
Oct 21 16:59:17 OpenWrt user.notice dnsmasq: DNS rebinding protection
is active, will discard upstream RFC1918 responses!
Oct 21 16:59:17 OpenWrt user.notice dnsmasq: Allowing 127.0.0.0/8 responses
Oct 21 16:59:19 OpenWrt user.info sysinit: ping: bad address 'google.com'
Oct 21 16:59:21 OpenWrt daemon.info dnsmasq[3830]: started, version
2.66 cachesize 150
Oct 21 16:59:21 OpenWrt daemon.info dnsmasq[3830]: compile time
options: IPv6 GNU-getopt no-DBus no-i18n no-IDN DHCP no-DHCPv6 no-Lua
TFTP no-conntrack no-ipset no-auth
Oct 21 16:59:21 OpenWrt daemon.info dnsmasq-dhcp[3830]: DHCP, IP range
192.168.1.100 -- 192.168.1.249, lease time 12h
Oct 21 16:59:21 OpenWrt daemon.info dnsmasq[3830]: using local
addresses only for domain lan
Oct 21 16:59:21 OpenWrt daemon.warn dnsmasq[3830]: no servers found in
/tmp/resolv.conf.auto, will retry
Oct 21 16:59:21 OpenWrt daemon.info dnsmasq[3830]: read /etc/hosts - 1 addresses
Oct 21 16:59:21 OpenWrt daemon.info dnsmasq-dhcp[3830]: read
/etc/ethers - 0 addresses
Oct 21 16:59:22 OpenWrt user.info sysinit: ping: bad address 'google.com'
Oct 21 16:59:25 OpenWrt user.info sysinit: ping: bad address 'google.com'
Oct 21 16:59:28 OpenWrt user.info sysinit: ping: bad address 'google.com'
Oct 21 16:59:31 OpenWrt user.info sysinit: ping: bad address 'google.com'
Oct 21 16:59:34 OpenWrt user.info sysinit: ping: bad address 'google.com'
Oct 21 16:59:37 OpenWrt user.info sysinit: ping: bad address 'google.com'
Oct 21 16:59:40 OpenWrt user.info sysinit: ping: bad address 'google.com'
Oct 21 16:59:43 OpenWrt user.info sysinit: ping: bad address 'google.com'
Oct 21 16:59:46 OpenWrt user.info sysinit: ping: bad address 'google.com'
Oct 21 16:59:49 OpenWrt user.info sysinit: ping: bad address 'google.com'
Oct 21 16:59:52 OpenWrt user.info sysinit: ping: bad address 'google.com'
Oct 21 16:59:55 OpenWrt user.info sysinit: ping: bad address 'google.com'
Oct 21 16:59:58 OpenWrt user.info sysinit: ping: bad address 'google.com'
Oct 21 17:00:01 OpenWrt cron.info crond[1311]: crond: USER root pid
4039 cmd /bin/tester.sh
Oct 21 17:00:02 OpenWrt user.info sysinit: ping: bad address 'google.com'
Oct 21 17:00:02 OpenWrt daemon.notice netifd: Interface 'wan' is now down
Oct 21 17:00:05 OpenWrt user.info sysinit: ping: bad address 'google.com'
Oct 21 17:00:08 OpenWrt user.info sysinit: ping: bad address 'google.com'
Oct 21 17:00:11 OpenWrt user.info sysinit: ping: bad address 'google.com'
Oct 21 17:00:14 OpenWrt user.info sysinit: ping: bad address 'google.com'
Oct 21 17:00:17 OpenWrt user.info sysinit: ping: bad address 'google.com'
Oct 21 17:00:20 OpenWrt user.info sysinit: ping: bad address 'google.com'
Oct 21 17:00:23 OpenWrt user.info sysinit: ping: bad address 'google.com'
Oct 21 17:00:26 OpenWrt user.info sysinit: ping: bad address 'google.com'
Oct 21 17:00:29 OpenWrt user.info sysinit: ping: bad address 'google.com'
Oct 21 17:00:32 OpenWrt user.info sysinit: ping: bad address 'google.com'
Oct 21 17:00:35 OpenWrt user.info sysinit: ping: bad address 'google.com'
Oct 21 17:00:38 OpenWrt user.info sysinit: ping: bad address 'google.com'
Oct 21 17:00:41 OpenWrt user.info sysinit: ping: bad address 'google.com'
Oct 21 17:00:44 OpenWrt user.info sysinit: ping: bad address 'google.com'
Oct 21 17:00:47 OpenWrt user.info sysinit: ping: bad address 'google.com'
Oct 21 17:00:50 OpenWrt user.info sysinit: ping: bad address 'google.com'
Oct 21 17:00:52 OpenWrt daemon.notice netifd: Interface 'wwan' is now down
Oct 21 17:00:53 OpenWrt kern.info kernel: [  746.150000] device wlan1
left promiscuous mode
Oct 21 17:00:53 OpenWrt kern.info kernel: [  746.160000] br-lan: port
2(wlan1) entered disabled state
Oct 21 17:00:54 OpenWrt user.info sysinit: ping: bad address 'google.com'
Oct 21 17:00:57 OpenWrt user.info sysinit: ping: bad address 'google.com'
Oct 21 17:00:59 OpenWrt kern.info kernel: [  752.710000]
ADDRCONF(NETDEV_UP): wlan1: link is not ready
Oct 21 17:00:59 OpenWrt kern.info kernel: [  752.730000] device wlan1
entered promiscuous mode
Oct 21 17:00:59 OpenWrt kern.info kernel: [  752.870000]
ADDRCONF(NETDEV_UP): wlan1: link is not ready
Oct 21 17:01:00 OpenWrt user.info sysinit: ping: bad address 'google.com'
Oct 21 17:01:01 OpenWrt kern.info kernel: [  753.950000] br-lan: port
2(wlan1) entered forwarding state
Oct 21 17:01:01 OpenWrt kern.info kernel: [  753.960000] br-lan: port
2(wlan1) entered forwarding state
Oct 21 17:01:01 OpenWrt kern.info kernel: [  753.970000]
ADDRCONF(NETDEV_CHANGE): wlan1: link becomes ready
Oct 21 17:01:03 OpenWrt kern.info kernel: [  755.960000] br-lan: port
2(wlan1) entered forwarding state
Oct 21 17:01:03 OpenWrt user.info sysinit: ping: bad address 'google.com'
Oct 21 17:01:06 OpenWrt user.info sysinit: ping: bad address 'google.com'
Oct 21 17:01:08 OpenWrt kern.info kernel: [  761.870000]
ADDRCONF(NETDEV_UP): wlan0: link is not ready
Oct 21 17:01:09 OpenWrt user.info sysinit: ping: bad address 'google.com'
Oct 21 17:01:12 OpenWrt user.info sysinit: ping: bad address 'google.com'
Oct 21 17:01:14 OpenWrt kern.info kernel: [  767.440000] wlan0:
authenticate with 00:0c:03:10:1e:6d
Oct 21 17:01:14 OpenWrt kern.info kernel: [  767.750000] wlan0: send
auth to 00:0c:03:10:1e:6d (try 1/3)
Oct 21 17:01:14 OpenWrt kern.info kernel: [  767.780000] wlan0: authenticated
Oct 21 17:01:14 OpenWrt daemon.info hostapd: wlan1: STA
00:c0:ca:66:66:6a IEEE 802.11: authenticated
Oct 21 17:01:14 OpenWrt kern.info kernel: [  767.820000] wlan0:
associate with 00:0c:03:10:1e:6d (try 1/3)
Oct 21 17:01:15 OpenWrt kern.info kernel: [  767.880000] wlan0: RX
AssocResp from 00:0c:03:10:1e:6d (capab=0x431 status=0 aid=1)
Oct 21 17:01:15 OpenWrt kern.info kernel: [  767.940000] wlan0: associated
Oct 21 17:01:15 OpenWrt kern.info kernel: [  767.940000]
ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
Oct 21 17:01:15 OpenWrt daemon.info dnsmasq[3830]: exiting on receipt of SIGTERM
Oct 21 17:01:15 OpenWrt daemon.notice netifd: wwan (4472): udhcpc
(v1.19.4) started
Oct 21 17:01:15 OpenWrt user.info sysinit: ping: bad address 'google.com'
Oct 21 17:01:15 OpenWrt daemon.notice netifd: wwan (4472): Sending discover...
Oct 21 17:01:17 OpenWrt user.notice dnsmasq: DNS rebinding protection
is active, will discard upstream RFC1918 responses!
Oct 21 17:01:17 OpenWrt user.notice dnsmasq: Allowing 127.0.0.0/8 responses
Oct 21 17:01:18 OpenWrt user.info sysinit: ping: bad address 'google.com'
Oct 21 17:01:18 OpenWrt daemon.notice netifd: wwan (4472): Sending discover...
Oct 21 17:01:20 OpenWrt daemon.info dnsmasq[4513]: started, version
2.66 cachesize 150
Oct 21 17:01:20 OpenWrt daemon.info dnsmasq[4513]: compile time
options: IPv6 GNU-getopt no-DBus no-i18n no-IDN DHCP no-DHCPv6 no-Lua
TFTP no-conntrack no-ipset no-auth
Oct 21 17:01:20 OpenWrt daemon.info dnsmasq-dhcp[4513]: DHCP, IP range
192.168.1.100 -- 192.168.1.249, lease time 12h
Oct 21 17:01:20 OpenWrt daemon.info dnsmasq[4513]: using local
addresses only for domain lan
Oct 21 17:01:20 OpenWrt daemon.warn dnsmasq[4513]: no servers found in
/tmp/resolv.conf.auto, will retry
Oct 21 17:01:20 OpenWrt daemon.info dnsmasq[4513]: read /etc/hosts - 1 addresses
Oct 21 17:01:20 OpenWrt daemon.info dnsmasq-dhcp[4513]: read
/etc/ethers - 0 addresses
Oct 21 17:01:21 OpenWrt daemon.notice netifd: wwan (4472): Sending discover...
Oct 21 17:01:21 OpenWrt user.info sysinit: ping: bad address 'google.com'
Oct 21 17:01:25 OpenWrt kern.info kernel: [  777.960000] wlan0:
deauthenticating from 00:0c:03:10:1e:6d by local choice (reason=3)
Oct 21 17:01:25 OpenWrt user.info sysinit: ping: bad address 'google.com'
Oct 21 17:01:27 OpenWrt kern.info kernel: [  780.530000] wlan0:
authenticate with 00:0c:03:10:1e:6d
Oct 21 17:01:27 OpenWrt kern.info kernel: [  780.810000] wlan0: send
auth to 00:0c:03:10:1e:6d (try 1/3)
Oct 21 17:01:28 OpenWrt kern.info kernel: [  781.030000] wlan0: send
auth to 00:0c:03:10:1e:6d (try 2/3)
Oct 21 17:01:28 OpenWrt kern.info kernel: [  781.040000] wlan0: authenticated
Oct 21 17:01:28 OpenWrt daemon.notice hostapd: wlan1: STA
00:c0:ca:66:66:6a IEEE 802.11: did not acknowledge authentication
response
Oct 21 17:01:28 OpenWrt kern.info kernel: [  781.060000] wlan0:
associate with 00:0c:03:10:1e:6d (try 1/3)
Oct 21 17:01:28 OpenWrt user.info sysinit: ping: bad address 'google.com'
Oct 21 17:01:28 OpenWrt kern.info kernel: [  781.280000] wlan0:
associate with 00:0c:03:10:1e:6d (try 2/3)
Oct 21 17:01:28 OpenWrt daemon.info hostapd: wlan1: STA
00:c0:ca:66:66:6a IEEE 802.11: associated (aid 1)
Oct 21 17:01:28 OpenWrt kern.info kernel: [  781.320000] wlan0: RX
AssocResp from 00:0c:03:10:1e:6d (capab=0x431 status=0 aid=1)
Oct 21 17:01:28 OpenWrt kern.info kernel: [  781.360000] wlan0: associated
Oct 21 17:01:31 OpenWrt user.info sysinit: ping: bad address 'google.com'
Oct 21 17:01:31 OpenWrt kern.info kernel: [  784.480000] wlan0:
deauthenticated from 00:0c:03:10:1e:6d (Reason: 2)
Oct 21 17:01:34 OpenWrt user.info sysinit: ping: bad address 'google.com'
Oct 21 17:01:36 OpenWrt daemon.info hostapd: wlan1: STA
00:c0:ca:66:66:6a IEEE 802.11: deauthenticated due to local deauth
request
Oct 21 17:01:37 OpenWrt user.info sysinit: ping: bad address 'google.com'
Oct 21 17:01:40 OpenWrt user.info sysinit: ping: bad address 'google.com'
Oct 21 17:01:43 OpenWrt user.info sysinit: ping: bad address 'google.com'
Oct 21 17:01:43 OpenWrt kern.info kernel: [  796.610000] wlan0:
authenticate with 00:0c:03:10:1e:6d
Oct 21 17:01:44 OpenWrt kern.info kernel: [  796.890000] wlan0: send
auth to 00:0c:03:10:1e:6d (try 1/3)
Oct 21 17:01:44 OpenWrt kern.info kernel: [  796.910000] wlan0: authenticated
Oct 21 17:01:44 OpenWrt daemon.notice hostapd: wlan1: STA
00:c0:ca:66:66:6a IEEE 802.11: did not acknowledge authentication
response
Oct 21 17:01:44 OpenWrt kern.info kernel: [  796.940000] wlan0:
associate with 00:0c:03:10:1e:6d (try 1/3)
Oct 21 17:01:44 OpenWrt daemon.info hostapd: wlan1: STA
00:c0:ca:66:66:6a IEEE 802.11: associated (aid 1)
Oct 21 17:01:44 OpenWrt kern.info kernel: [  796.970000] wlan0: RX
AssocResp from 00:0c:03:10:1e:6d (capab=0x431 status=0 aid=1)
Oct 21 17:01:44 OpenWrt kern.info kernel: [  797.010000] wlan0: associated
Oct 21 17:01:46 OpenWrt user.info sysinit: ping: bad address 'google.com'
Oct 21 17:01:47 OpenWrt kern.info kernel: [  800.110000] wlan0:
deauthenticated from 00:0c:03:10:1e:6d (Reason: 2)
Oct 21 17:01:49 OpenWrt user.info sysinit: ping: bad address 'google.com'
Oct 21 17:01:52 OpenWrt daemon.info hostapd: wlan1: STA
00:c0:ca:66:66:6a IEEE 802.11: deauthenticated due to local deauth
request
Oct 21 17:01:52 OpenWrt user.info sysinit: ping: bad address 'google.com'
Oct 21 17:01:55 OpenWrt user.info sysinit: ping: bad address 'google.com'
Oct 21 17:01:58 OpenWrt user.info sysinit: ping: bad address 'google.com'
Oct 21 17:02:01 OpenWrt user.info sysinit: ping: bad address 'google.com'
Oct 21 17:02:01 OpenWrt cron.info crond[1311]: crond: USER root pid
4731 cmd /bin/tester.sh
Oct 21 17:02:02 OpenWrt daemon.notice netifd: Interface 'wan' is now down
Oct 21 17:02:04 OpenWrt user.info sysinit: ping: bad address 'google.com'
Oct 21 17:02:07 OpenWrt user.info sysinit: ping: bad address 'google.com'
Oct 21 17:02:09 OpenWrt kern.info kernel: [  821.940000] wlan0:
authenticate with 00:0c:03:10:1e:6d
Oct 21 17:02:09 OpenWrt kern.info kernel: [  822.230000] wlan0: send
auth to 00:0c:03:10:1e:6d (try 1/3)
Oct 21 17:02:09 OpenWrt kern.info kernel: [  822.450000] wlan0: send
auth to 00:0c:03:10:1e:6d (try 2/3)
Oct 21 17:02:09 OpenWrt kern.info kernel: [  822.670000] wlan0: send
auth to 00:0c:03:10:1e:6d (try 3/3)
Oct 21 17:02:09 OpenWrt daemon.notice hostapd: wlan1: STA
00:c0:ca:66:66:6a IEEE 802.11: did not acknowledge authentication
response
Oct 21 17:02:09 OpenWrt kern.info kernel: [  822.700000] wlan0: authenticated
Oct 21 17:02:09 OpenWrt kern.info kernel: [  822.710000] wlan0:
associate with 00:0c:03:10:1e:6d (try 1/3)
Oct 21 17:02:09 OpenWrt daemon.info hostapd: wlan1: STA
00:c0:ca:66:66:6a IEEE 802.11: associated (aid 1)
Oct 21 17:02:09 OpenWrt kern.info kernel: [  822.750000] wlan0: RX
AssocResp from 00:0c:03:10:1e:6d (capab=0x431 status=0 aid=1)
Oct 21 17:02:09 OpenWrt kern.info kernel: [  822.780000] wlan0: associated
Oct 21 17:02:10 OpenWrt user.info sysinit: ping: bad address 'google.com'
Oct 21 17:02:12 OpenWrt kern.info kernel: [  825.860000] wlan0:
deauthenticated from 00:0c:03:10:1e:6d (Reason: 2)
Oct 21 17:02:13 OpenWrt user.info sysinit: ping: bad address 'google.com'
Oct 21 17:02:16 OpenWrt user.info sysinit: ping: bad address 'google.com'
Oct 21 17:02:17 OpenWrt daemon.info hostapd: wlan1: STA
00:c0:ca:66:66:6a IEEE 802.11: deauthenticated due to local deauth
request
Oct 21 17:02:19 OpenWrt user.info sysinit: ping: bad address 'google.com'
Oct 21 17:02:22 OpenWrt user.info sysinit: ping: bad address 'google.com'
Oct 21 17:02:25 OpenWrt user.info sysinit: ping: bad address 'google.com'
Oct 21 17:02:29 OpenWrt user.info sysinit: ping: bad address 'google.com'
Oct 21 17:02:32 OpenWrt user.info sysinit: ping: bad address 'google.com'
Oct 21 17:02:34 OpenWrt kern.info kernel: [  847.760000] wlan0:
authenticate with 00:0c:03:10:1e:6d
Oct 21 17:02:35 OpenWrt user.info sysinit: ping: bad address 'google.com'
Oct 21 17:02:35 OpenWrt kern.info kernel: [  848.060000] wlan0: send
auth to 00:0c:03:10:1e:6d (try 1/3)
Oct 21 17:02:35 OpenWrt kern.info kernel: [  848.280000] wlan0: send
auth to 00:0c:03:10:1e:6d (try 2/3)
Oct 21 17:02:35 OpenWrt kern.info kernel: [  848.500000] wlan0: send
auth to 00:0c:03:10:1e:6d (try 3/3)





WPA PSK

Oct 21 17:08:20 OpenWrt daemon.info hostapd: wlan1: STA
00:c0:ca:66:66:6a IEEE 802.11: deauthenticated due to local deauth
request
Oct 21 17:08:23 OpenWrt user.info sysinit: ping: bad address 'google.com'
Oct 21 17:08:26 OpenWrt user.info sysinit: ping: bad address 'google.com'
Oct 21 17:08:28 OpenWrt kern.info kernel: [ 1200.900000] wlan0:
authenticate with 00:0c:03:10:1e:6d
Oct 21 17:08:28 OpenWrt kern.info kernel: [ 1201.180000] wlan0: send
auth to 00:0c:03:10:1e:6d (try 1/3)
Oct 21 17:08:28 OpenWrt kern.info kernel: [ 1201.400000] wlan0: send
auth to 00:0c:03:10:1e:6d (try 2/3)
Oct 21 17:08:28 OpenWrt kern.info kernel: [ 1201.410000] wlan0: authenticated
Oct 21 17:08:28 OpenWrt daemon.info hostapd: wlan1: STA
00:c0:ca:66:66:6a IEEE 802.11: authenticated
Oct 21 17:08:28 OpenWrt kern.info kernel: [ 1201.430000] wlan0:
associate with 00:0c:03:10:1e:6d (try 1/3)
Oct 21 17:08:28 OpenWrt daemon.info hostapd: wlan1: STA
00:c0:ca:66:66:6a IEEE 802.11: associated (aid 1)
Oct 21 17:08:28 OpenWrt kern.info kernel: [ 1201.460000] wlan0: RX
AssocResp from 00:0c:03:10:1e:6d (capab=0x431 status=0 aid=1)
Oct 21 17:08:28 OpenWrt kern.info kernel: [ 1201.480000] wlan0: associated
Oct 21 17:08:29 OpenWrt user.info sysinit: ping: bad address 'google.com'


WWPA-PSK/WPA2-PSK MIXEDMODE

WORK for other OpenWrt master mode AP for different AP with this
setting sometimes work
only when radio is set as radio1

config wifi-device 'radio0'
        option type 'mac80211'
        option channel '11'
        option hwmode '11ng'
        option macaddr '00:0c:03:10:1e:6d'
        option htmode 'HT20'
        list ht_capab 'GF'
        list ht_capab 'SHORT-GI-20'
        list ht_capab 'SHORT-GI-40'
        list ht_capab 'RX-STBC1'
        option txpower '20'
        option country '00'

config wifi-iface
        option device 'radio0'
        option network 'lan'
        option mode 'ap'
        option ssid 'OpenWrt'
        option encryption 'psk-mixed+tkip+ccmp'
        option key 'dupadupa'

config wifi-device 'radio1'
        option type 'mac80211'
        option channel '11'
        option hwmode '11g'
        option macaddr '00:c0:ca:66:66:6a'
        option txpower '20'
        option country '00'
        option disabled '0'

config wifi-iface
        option network 'wwan'
        option ssid 'rl_aero2'
        option encryption 'psk2'
        option device 'radio1'
        option mode 'sta'
        option bssid '78:1D:BA:12:74:C8'
        option key 'xxxxxxxxxxx'


when the lan is set to bridge usualy there is such info during bring
up (openwrt trunk)

root@OpenWrt:/# ifup wwan
command failed: Device or resource busy (-16)
wpa_supplicant_setup_vif(
wlan0): Refusing to bridge sta mode interface
enable_mac80211(radio1): Failed to set up wpa_supplicant for interface wlan0




WEP
works sometimes


Open network  works and I am able to connect

iw comman shows

root@OpenWrt:~# iw phy0 info
Wiphy phy0
        Band 1:
                Frequencies:
                        * 2412 MHz [1] (30.0 dBm)
                        * 2417 MHz [2] (30.0 dBm)
                        * 2422 MHz [3] (30.0 dBm)
                        * 2427 MHz [4] (30.0 dBm)
                        * 2432 MHz [5] (30.0 dBm)
                        * 2437 MHz [6] (30.0 dBm)
                        * 2442 MHz [7] (30.0 dBm)
                        * 2447 MHz [8] (30.0 dBm)
                        * 2452 MHz [9] (30.0 dBm)
                        * 2457 MHz [10] (30.0 dBm)
                        * 2462 MHz [11] (30.0 dBm)
                        * 2467 MHz [12] (30.0 dBm)
                        * 2472 MHz [13] (30.0 dBm)
                        * 2484 MHz [14] (disabled)
                Bitrates (non-HT):
                        * 1.0 Mbps
                        * 2.0 Mbps
                        * 5.5 Mbps
                        * 11.0 Mbps
                        * 6.0 Mbps
                        * 9.0 Mbps
                        * 12.0 Mbps
                        * 18.0 Mbps
                        * 24.0 Mbps
                        * 36.0 Mbps
                        * 48.0 Mbps
                        * 54.0 Mbps
        max # scan SSIDs: 4
        max scan IEs length: 2285 bytes
        Fragmentation threshold: 2346
        RTS threshold: 2347
        Coverage class: 0 (up to 0m)
        Supported Ciphers:
                * WEP40 (00-0f-ac:1)
                * WEP104 (00-0f-ac:5)
                * TKIP (00-0f-ac:2)
                * CCMP (00-0f-ac:4)
        Available Antennas: TX 0 RX 0
        Supported interface modes:
                 * IBSS
                 * managed
                 * monitor
        software interface modes (can always be added):
                 * monitor
        interface combinations are not supported
        Supported commands:
                 * new_interface
                 * set_interface
                 * new_key
                 * start_ap
                 * new_station
                 * new_mpath
                 * set_mesh_config
                 * set_bss
                 * authenticate
                 * associate
                 * deauthenticate
                 * disassociate
                 * join_ibss
                 * join_mesh
                 * set_tx_bitrate_mask
                 * frame
                 * frame_wait_cancel
                 * set_wiphy_netns
                 * set_channel
                 * set_wds_peer
                 * probe_client
                 * set_noack_map
                 * register_beacons
                 * Unknown command (89)
                 * Unknown command (92)
                 * testmode
                 * connect
                 * disconnect
        Supported TX frame types:
                 * IBSS: 0x00 0x10 0x20 0x30 0x40 0x50 0x60 0x70 0x80
0x90 0xa0 0xb0 0xc0 0xd0 0xe0 0xf0
                 * managed: 0x00 0x10 0x20 0x30 0x40 0x50 0x60 0x70
0x80 0x90 0xa0 0xb0 0xc0 0xd0 0xe0 0xf0
                 * AP: 0x00 0x10 0x20 0x30 0x40 0x50 0x60 0x70 0x80
0x90 0xa0 0xb0 0xc0 0xd0 0xe0 0xf0
                 * AP/VLAN: 0x00 0x10 0x20 0x30 0x40 0x50 0x60 0x70
0x80 0x90 0xa0 0xb0 0xc0 0xd0 0xe0 0xf0
                 * mesh point: 0x00 0x10 0x20 0x30 0x40 0x50 0x60 0x70
0x80 0x90 0xa0 0xb0 0xc0 0xd0 0xe0 0xf0
                 * P2P-client: 0x00 0x10 0x20 0x30 0x40 0x50 0x60 0x70
0x80 0x90 0xa0 0xb0 0xc0 0xd0 0xe0 0xf0
                 * P2P-GO: 0x00 0x10 0x20 0x30 0x40 0x50 0x60 0x70
0x80 0x90 0xa0 0xb0 0xc0 0xd0 0xe0 0xf0
                 * (null): 0x00 0x10 0x20 0x30 0x40 0x50 0x60 0x70
0x80 0x90 0xa0 0xb0 0xc0 0xd0 0xe0 0xf0
        Supported RX frame types:
                 * IBSS: 0x40 0xb0 0xc0 0xd0
                 * managed: 0x40 0xd0
                 * AP: 0x00 0x20 0x40 0xa0 0xb0 0xc0 0xd0
                 * AP/VLAN: 0x00 0x20 0x40 0xa0 0xb0 0xc0 0xd0
                 * mesh point: 0xb0 0xc0 0xd0
                 * P2P-client: 0x40 0xd0
                 * P2P-GO: 0x00 0x20 0x40 0xa0 0xb0 0xc0 0xd0
                 * (null): 0x40 0xd0
        Device supports RSN-IBSS.
        HT Capability overrides:
                 * MCS: ff ff ff ff ff ff ff ff ff ff
                 * maximum A-MSDU length
                 * supported channel width
                 * short GI for 40 MHz
                 * max A-MPDU length exponent
                 * min MPDU start spacing
        Device supports TX status socket option.
        Device supports HT-IBSS.
