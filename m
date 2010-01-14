Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from llsa736-a03.servidoresdns.net ([82.223.190.27]:60924 "EHLO
	llsa736-a03.servidoresdns.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757342Ab0ANRtk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Jan 2010 12:49:40 -0500
Received: from [192.168.0.195] (unknown [77.230.28.199])
	by smtp-03.servidoresdns.net (Postfix) with ESMTP id C72C624E1C6
	for <linux-wireless@vger.kernel.org>; Thu, 14 Jan 2010 18:49:36 +0100 (CET)
Subject: ath9k/AR9285 - incompatibility with bluetooth
From: Alberto =?ISO-8859-1?Q?Jos=E9_Rodr=EDguez_?=
	 =?ISO-8859-1?Q?Rodr=EDguez?= <ajrodriguez@blulabs.es>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 14 Jan 2010 18:49:35 +0000
Message-Id: <1263494975.4643.15.camel@eclipse>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hellow,
	I have a ZOTAC MAG ION and I'm having problems with wireless
connections

Distribution: Ubuntu 9.10
Kernel version: 2.6.31-16
Device: 04:00.0 Network controller: Atheros Communications Inc. AR9285 Wireless Network Adapter (PCI-Express) (rev 01)
Problem Description:
    - Low signal strength
    - Cannot connect to wireless networks
Using linux-backports-modules-karmic:
    - Low signal strength persists
    - Can connect to WPA networks but signal strengh is low and unstable, also when using at the same time a Bluetooth USB dongle (continuously inquiring) the wireless connection is lost.
    - Cannot connect to WEP networks, although the WEP key is set correctly and the device is associated to the AP
Using latest linux-wireless snapshot (20100113):
    - Can connect to WEP networks but when I use at the same time a Bluetooth USB dongle (continuously inquiring) the speed of the wireless connection becomes very slow.
    - Can connect to WPA networks but when I use at the same time a Bluetooth USB dongle (continuously inquiring) the wireless connection is lost.

If you need more info, please do not hesitate to inquire.
Thanks in advance,

-- 
Alberto José Rodríguez Rodríguez <ajrodriguez@blulabs.es>
BluLabs, S.L.

