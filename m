Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:61709 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750887AbbL1OCz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Dec 2015 09:02:55 -0500
Received: from [192.168.2.102] ([109.47.192.50]) by mail.gmx.com (mrgmx102)
 with ESMTPSA (Nemesis) id 0LzHZ7-1a900d0cgj-014Vus for
 <linux-wireless@vger.kernel.org>; Mon, 28 Dec 2015 15:02:54 +0100
Message-ID: <5681410A.7090709@gmx.de> (sfid-20151228_150258_893753_4F50E0F2)
Date: Mon, 28 Dec 2015 15:02:50 +0100
From: Erik Schanze <schanzi_usenet@gmx.de>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: How to set geography on ipw2200?
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

[Please keep me in CC:, I'm not subscribed yet.]

I have a Notebook with ipw2200bg card an use it in Germany.
Unfortunately the kernel module drives it as US device:

[    8.130591] ipw2200: Detected geography ZZM (11 802.11bg channels, 0
802.11a channels)

Now I noticed, I cannot access a router on channel 13 (it is fixed, no
change to 1-11 possible).

I found some web sites describing to patch the Linux driver for a fixed
different geography (not easy for end user) or to alter the cards EEPROM
values (not possible for end user an dangerous).

I wonder if there is no easy way to configure geography via kernel
module parameter.
If set it would use this value instead from EEPROM.

Was it already discussed previously? (I found nothing in archive.)
Would a patch makes sense and would it be considered in further versions?



Best regards,

Erik
