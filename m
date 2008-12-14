Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from webmail1.b-one.net ([195.47.247.29]:41725 "EHLO
	webmail1.one.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753126AbYLNQ2E (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Dec 2008 11:28:04 -0500
Received: from webmail01.one.com (localhost [127.0.0.1])
	by webmail1.one.com (Postfix) with ESMTP id B11C99047474
	for <linux-wireless@vger.kernel.org>; Sun, 14 Dec 2008 17:16:36 +0100 (CET)
Message-ID: <11d93ee1788b08efbe3aaab10c8d5395.squirrel@webmail01.one.com> (sfid-20081214_172815_044243_6F43ED8A)
Date: Sun, 14 Dec 2008 17:16:36 +0100 (CET)
Subject: Will DWA-556 AR5418+AR2133 get supported?
From: eirik@finvold.org
To: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello!

A while ago I bought a D-Link DWA-556 a/b/g/n PCI-E card, and have tried
to get it fully working since. It works with >2.6.27, but is really really
slow. At the most I get 7-800KBps, even with a link quality at aprox
60-70/100. If I place my laptop with iwlwifi ontop of my other machine, I
get the same link quality, but at least 10 times the speed.

I can see on your supported chipset page that AR5416-AR2133 is supported,
but not AR5418-AR2133 - as my dmesg reports my cards as.

My DWA-556 card got 3 antennas by the way..

My accesspoint (D-Link DIR-855) is set to 802.11n network only, with wpa2
and aes only, and 20MHz (if I select auto 20/40, my ath9k driver cannot
connect).

I'm currently running latest wireless-testing kernel.

Thanks in advance!

Some output:
-----------------
dmesg | grep phy0:
phy0: Selected rate control algorithm 'ath9k_rate_control'
Registered led device: ath9k-phy0:radio
Registered led device: ath9k-phy0:assoc
Registered led device: ath9k-phy0:tx
Registered led device: ath9k-phy0:rx
phy0: Atheros AR5418 MAC/BB Rev:2 AR2133 RF Rev:81:
mem=0xffffc20011160000, irq=17

-----------------
iwconfig wlan0:
wlan0     IEEE 802.11bgn  ESSID:"XXXX"
          Mode:Managed  Frequency:2.447 GHz  Access Point: 00:21:91:19:0C:4A
          Bit Rate=1 Mb/s   Tx-Power=27 dBm
          Retry min limit:7   RTS thr:off   Fragment thr=2352 B
          Encryption key:xxxx-xxxx-xxxx-xxxx-xxxx-xxxx-xxxx-xxxx [3]
Security mode:open
          Power Management:off
          Link Quality=59/100  Signal level:-68 dBm
          Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
          Tx excessive retries:0  Invalid misc:0   Missed beacon:0

-----------------
iw list:
Wiphy phy0
        Band 1:
                HT capabilities: 0x104e
                         * 20/40 MHz operation
                         * SM PS disabled
                         * 40 MHz short GI
                         * max A-MSDU len 3839
                         * DSSS/CCK 40 MHz
                HT A-MPDU factor: 0x0003 (65535 bytes)
                HT A-MPDU density: 0x0006 (8 usec)
                HT MCS set: ff ff 00 00 00 00 00 00 00 00 00 00 01 00 00 00
                Frequencies:
                        * 2412 MHz [1] (27.0 dBm)
                        * 2417 MHz [2] (27.0 dBm)
                        * 2422 MHz [3] (27.0 dBm)
                        * 2427 MHz [4] (27.0 dBm)
                        * 2432 MHz [5] (27.0 dBm)
                        * 2437 MHz [6] (27.0 dBm)
                        * 2442 MHz [7] (27.0 dBm)
                        * 2447 MHz [8] (27.0 dBm)
                        * 2452 MHz [9] (27.0 dBm)
                        * 2457 MHz [10] (27.0 dBm)
                        * 2462 MHz [11] (27.0 dBm)
                Bitrates:
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
        Supported interface modes:
                 * IBSS
                 * Station
                 * AP
                 * AP(VLAN)
                 * Monitor



