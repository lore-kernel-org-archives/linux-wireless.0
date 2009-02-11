Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from india533.server4you.de ([85.25.151.41]:9311 "EHLO
	india533.server4you.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754592AbZBKS5i (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Feb 2009 13:57:38 -0500
Received: from [192.168.0.17] (pD95FE930.dip.t-dialin.net [217.95.233.48])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by india533.server4you.de (Postfix) with ESMTP id 7D65E770510
	for <linux-wireless@vger.kernel.org>; Wed, 11 Feb 2009 19:47:44 +0100 (CET)
Message-ID: <49931D52.90904@smash-net.org> (sfid-20090211_195742_743713_3AE76E31)
Date: Wed, 11 Feb 2009 19:47:46 +0100
From: =?ISO-8859-15?Q?Norman_Rie=DF?= <norman@smash-net.org>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Re: ath5k master (AP) mode
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

i pulled wireless-testing kernel today and installed hostapd-0.6.7,  but
it still does not work.


iwconfig wlan0 mode master
Error for wireless request "Set Mode" (8B06) :
    SET failed on device wlan0 ; Invalid argument.

hostapd v0.6.7
User space daemon for IEEE 802.11 AP management,
IEEE 802.1X/WPA/WPA2/EAP/RADIUS Authenticator
Copyright (c) 2002-2009, Jouni Malinen <j@w1.fi> and contributors


hostapd -dd /etc/hostapd/hostapd.conf
Configuration file: /etc/hostapd/hostapd.conf
ctrl_interface_group=0
Failed to set interface wlan0 to master mode.
nl80211 driver initialization failed.
wlan0: Unable to setup interface.
rmdir[ctrl_interface]: No such file or directory
ELOOP: remaining socket: sock=5 eloop_data=0x95f39e8 user_data=(nil)
handler=0x8075908


The card is Atheros Communications Inc. AR2413 802.11bg NIC (rev 01).

Regards,

Norman
