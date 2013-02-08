Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pikachu.3ti.be ([188.40.111.73]:40892 "EHLO pikachu.3ti.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759777Ab3BHBGw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Feb 2013 20:06:52 -0500
Received: from localhost (localhost [127.0.0.1])
	by pikachu.3ti.be (Postfix) with ESMTP id 71D8621263
	for <linux-wireless@vger.kernel.org>; Fri,  8 Feb 2013 02:06:50 +0100 (CET)
Received: from pikachu.3ti.be ([127.0.0.1])
	by localhost (pikachu.3ti.be [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id 1faKcuR19n1H for <linux-wireless@vger.kernel.org>;
	Fri,  8 Feb 2013 02:06:50 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by pikachu.3ti.be (Postfix) with ESMTP id 0EEF921263
	for <linux-wireless@vger.kernel.org>; Fri,  8 Feb 2013 02:06:50 +0100 (CET)
Date: Fri, 8 Feb 2013 02:06:50 +0100 (CET)
From: Dag Wieers <dag@wieers.com>
To: linux-wireless@vger.kernel.org
Subject: Re: BCM4321 (b43) on AppleTV (1st gen)
In-Reply-To: <alpine.LRH.2.02.1302072238200.2736@pikachu.3ti.be>
Message-ID: <alpine.LRH.2.02.1302080206020.2736@pikachu.3ti.be> (sfid-20130208_020657_458315_636A1575)
References: <alpine.LRH.2.02.1302072238200.2736@pikachu.3ti.be>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 8 Feb 2013, Dag Wieers wrote:

> For the OpenELEC project I am looking into getting better performance out of 
> the b43 driver on the AppleTV (1st gen) device . The website reports the 
> driver can do 802.11n (albeit on 2.4Ghz only), however using kernel 3.7.5 
> (and earlier) I cannot get more than 3 MB/sec out of it (usually much less).

I wanted to add the kernel boot messages:

----
root ~ # dmesg | grep b43
[    2.902696] b43-phy0: Broadcom 4321 WLAN found (core revision 12)
[    2.976740] b43-phy0: Found PHY: Analog 5, Type 4 (N), Revision 2
[    2.976772] b43-phy0 debug: Found Radio: Manuf 0x17F, Version 0x2055, Revision 4
[    3.038609] Registered led device: b43-phy0::tx
[    3.040268] Registered led device: b43-phy0::rx
[    3.040433] Registered led device: b43-phy0::radio
[    4.736728] b43-phy0: Loading firmware version 508.1084 (2009-01-14 01:32:01)
[    4.807784] b43-phy0 debug: Chip initialized
[    4.808074] b43-phy0 debug: 64-bit DMA initialized
[    4.808142] b43-phy0 debug: QoS enabled
[    4.833456] b43-phy0 debug: Wireless interface started
[    4.833526] b43-phy0 debug: Adding Interface type 2
[    7.837659] b43-phy0 debug: Using hardware based encryption for keyidx: 0, mac: 74:44:01:8d:90:5e
[    7.838009] b43-phy0 debug: Using hardware based encryption for keyidx: 1, mac: ff:ff:ff:ff:ff:ff
----

Kind regards,
-- 
-- dag wieers, dag@wieers.com, http://dag.wieers.com/
-- dagit linux solutions, info@dagit.net, http://dagit.net/

[Any errors in spelling, tact or fact are transmission errors]
