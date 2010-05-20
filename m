Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server.heaven-czfree.net ([78.108.102.201]:41839 "EHLO
	smtp.heaven-czfree.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751146Ab0ETHXW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 May 2010 03:23:22 -0400
Received: from [10.23.202.43] (unknown [10.23.202.43])
	by smtp.heaven-czfree.net (Postfix) with ESMTP id 6F11F147682
	for <linux-wireless@vger.kernel.org>; Thu, 20 May 2010 09:00:11 +0200 (CEST)
From: "Jaroslav Fojtik" <jafojtik@seznam.cz>
To: linux-wireless@vger.kernel.org
Date: Thu, 20 May 2010 08:00:08 +0200
MIME-Version: 1.0
Subject: How to scan APs with ATH5k?
Message-ID: <4BF4CFE8.10182.FA668@jafojtik.seznam.cz>
In-reply-to: <201005200852.03136.helmut.schaa@googlemail.com>
References: <1274296671-13596-1-git-send-email-gwingerde@gmail.com>, <201005200852.03136.helmut.schaa@googlemail.com>
Content-type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dears,

I have a problem with AP scanning:

root@dvouramenna:/tmp# iwlist "wlan0" scanning
wlan0     Interface doesn't support scanning : Operation not supported

root@dvouramenna:/tmp# iwlist "wlan1" scanning
wlan1     Failed to read scan data : Resource temporarily unavailable

I am testing "compat-wireless-2.6.34-rc4".

I hope that this is a defect and should be reported somewhere into bugzilla.

regards
   Jara

PS: this is my wireless devices:
02:08.0 Ethernet controller: Atheros Communications Inc. AR2413 802.11bg NIC (rev 01)
        Subsystem: Atheros Communications Inc. TP-Link TL-WN510G Wireless CardBus Adapter
        Flags: bus master, medium devsel, latency 168, IRQ 17
        Memory at fdef0000 (32-bit, non-prefetchable) [size=64K]
        Capabilities: [44] Power Management version 2

02:0a.0 Ethernet controller: Atheros Communications Inc. AR5212/AR5213 Multiprotocol MAC/baseband processor (rev 01)
        Subsystem: Wistron NeWeb Corp. CM9 Wireless a/b/g MiniPCI Adapter
        Flags: bus master, medium devsel, latency 168, IRQ 19
        Memory at fdee0000 (32-bit, non-prefetchable) [size=64K]
        Capabilities: [44] Power Management version 2


