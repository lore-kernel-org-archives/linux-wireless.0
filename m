Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailout2.ltindia.com ([125.18.18.171]:8155 "EHLO
	mailout2.ltindia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752905Ab2DYQVy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Apr 2012 12:21:54 -0400
From: Girish Bn <Girish.BN@lnties.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: WiFi Direct - P2P Group Owner mode
Date: Wed, 25 Apr 2012 16:21:50 +0000
Message-ID: <45566970CF58C74CB52107862E0541CD1D13ABF6@POCITMSEXMB02.LntUniverse.com> (sfid-20120425_182157_601967_93045586)
Content-Type: text/plain; charset=US-ASCII
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Hi,
We are backporting the WL1271 driver from Compat Wireless-2.6(2012-02-22) to Linux 2.6.28.2 on LPC313X platform.
1.      Bootup the system and load all the driver modules
2.      Started the WPA Supplicant (#./wpa_supplicant -d -Dnl80211 -c /etc/wpa_supplicant.conf -iwlan0 -B)
3.      Start wpa_cli application
4.      Run the following commands
             a.      p2p_find
             b.      p2p_peers
             c.      p2p_group_add - Configure the System as Group Owner(GO)
             d.      wps_pbs - Work in Push Button Mode
5.      Note down the 8 digit passphrase
6.      Select the Wi-Fi network name from the iPad and enter the passphrase noted above.
7.      Check the IP address of the iPad. If the no IP is taken from DHCP, assign a static IP
8.      Exit the wpa_cli application
9.      Assign an IP address 169.254.50.100 to System
10.   Ping between the iPad and System

Please note that establishment of connection between System and iPad/iPhone fails may times and if you try again after waiting for 15 to 30mins, the connection happens successfully.
However, we are able establish the connection immediately to laptop.
Let us any steps we are missing to successfully establish the connection without waiting.

Thanks
Girish


Thanks & Regards,
Girish
L&T IES,
E-mail ID :Girish.BN@lnties.com
www.lnties.com

This mail is classified as :
(  ) L&T IES Proprietary
(  ) L&T IES Confidential
(X) L&T IES Internal Use
( ) L&T IES General Business

Larsen & Toubro Limited

www.larsentoubro.com<https://indmail.lntinfotech.com/owa/redir.aspx?C=2b4a0c51a57b47038127dd84059c7429&URL=http%3a%2f%2fwww.larsentoubro.com>

This Email may contain confidential or privileged information for the intended recipient (s). If you are not the intended recipient, please do not use or disseminate the information, notify the sender and delete it from your system.

 Earth Day. Every Day.
