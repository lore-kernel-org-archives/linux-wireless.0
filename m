Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from forward20.mail.yandex.net ([95.108.253.145]:34140 "EHLO
	forward20.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750841Ab1FYOQP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Jun 2011 10:16:15 -0400
From: Misha Shnurapet <shnurapet@fedoraproject.org>
To: Community support for Fedora users <users@lists.fedoraproject.org>
Subject: AR9280 won't initialize
MIME-Version: 1.0
Message-Id: <152381309010939@web35.yandex.ru> (sfid-20110625_161632_321778_A13E668E)
Date: Sat, 25 Jun 2011 23:08:58 +0900
Content-Type: text/plain; charset=koi8-r
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi.

I have a little problem. I replaced the old BCM4312 card on my Dell mini 1011 (10v) with:
03:00.0 Network controller: Atheros Communications Inc. AR928X Wireless Network Adapter (PCI-Express) (rev 01)

But it won't work.

First it crashed Linux:
http://pastebin.com/YmEGcPK8

Then I installed a system update:
http://funkyimg.com/u2/879/849/2.png
http://pastebin.com/hWG6u7VJ

And now it is:

[ šš30.589243] ath9k 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[ šš30.589269] ath9k 0000:03:00.0: setting latency timer to 64
[ šš30.594884] ath: address test failed addr: 0x00008000 - wr:0xaaaaaaaa != rd:0xaaaa2aaa
[ šš30.594898] ath: Unable to initialize hardware; initialization status: -19
[ šš30.594913] ath9k 0000:03:00.0: Failed to initialize device
[ šš30.594991] ath9k 0000:03:00.0: PCI INT A disabled

lsusb:
http://pastebin.com/JHYZiDhr

Installing the latest stable compat-wireless from source didn't help (bleeding edge won't build).

I would appreciate if you help me.

--
Best regards,
Misha Shnurapet, Fedora Project Contributor
Email: shnurapet AT fedoraproject.org, IRC: misha on freenode
https://fedoraproject.org/wiki/shnurapet, GPG: 00217306
