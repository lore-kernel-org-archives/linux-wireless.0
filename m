Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtaout01-winn.ispmail.ntl.com
 ([81.103.221.47]:30890 "EHLO	mtaout01-winn.ispmail.ntl.com"
 rhost-flags-OK-OK-OK-OK)	by vger.kernel.org with ESMTP id S1161037AbXBRBkk
 (ORCPT	<rfc822;linux-wireless@vger.kernel.org>); Sat,
 17 Feb 2007 20:40:40 -0500
Date: Sun, 18 Feb 2007 01:40:41 +0000 (GMT)
From: Daniel Drake <dsd@gentoo.org>
Subject: [PATCH] zd1211rw-d80211: Add ID for ZyXEL ZyAIR G-220 v2
Sender: linux-wireless-owner@vger.kernel.org
To: linville@tuxdriver.com
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org, kune@deine-taler.de
Message-id: <20070218014041.D25797B409F@zog.reactivated.net>
List-ID: <linux-wireless.vger.kernel.org>

Tested by Marijn Schouten
zd1211b chip 0586:340f v4810 high 00-13-49 AL2230_RF pa0 g---
FCC ID: I88G220V2

Signed-off-by: Daniel Drake <dsd@gentoo.org>
---
 drivers/net/wireless/d80211/zd1211rw/zd_usb.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/d80211/zd1211rw/zd_usb.c b/drivers/net/wireless/d80211/zd1211rw/zd_usb.c
index 1e8a45e..aaa055d 100644
--- a/drivers/net/wireless/zd1211rw/drivers/net/wireless/d80211/zd1211rw/zd_usb.c
+++ b/drivers/net/wireless/zd1211rw/drivers/net/wireless/d80211/zd1211rw/zd_usb.c
@@ -60,6 +60,7 @@ static struct usb_device_id usb_ids[] = {
 	{ USB_DEVICE(0x083a, 0x4505), .driver_info = DEVICE_ZD1211B },
 	{ USB_DEVICE(0x0471, 0x1236), .driver_info = DEVICE_ZD1211B },
 	{ USB_DEVICE(0x13b1, 0x0024), .driver_info = DEVICE_ZD1211B },
+	{ USB_DEVICE(0x0586, 0x340f), .driver_info = DEVICE_ZD1211B },
 	/* "Driverless" devices that need ejecting */
 	{ USB_DEVICE(0x0ace, 0x2011), .driver_info = DEVICE_INSTALLER },
 	{}
-- 
1.5.0

-
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
>From linux-wireless-owner@vger.kernel.org Sun Feb 18 06:13:42 2007
Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pop.hut.fi [130.233.228.132]
	by jm.kir.nu with POP3 (fetchmail-6.3.6)
	for <jm@localhost> (single-drop); Sat, 17 Feb 2007 20:13:42 -0800 (PST)
Received: from smtp02 (smtp02 [10.10.13.2])
 by mailstore2.hut-mail (iPlanet Messaging Server 5.2 HotFix 2.09 (built Nov 18
 2005)) with ESMTP id <0JDN00D2U4ZFQM@mailstore2.hut-mail> for
 jkmaline@cc.hut.fi; Sun, 18 Feb 2007 06:11:39 +0200 (EET)
Received: from smtp-3.hut.fi (smtp-3.hut.fi [130.233.228.93])
 by smtp02.hut-mail
 (iPlanet Messaging Server 5.2 HotFix 2.09 (built Nov 18 2005))
 with ESMTPS id <0JDN009SC4ZFKU@smtp02.hut-mail> for jkmaline@cc.hut.fi
 (ORCPT jkmaline@cc.hut.fi); Sun, 18 Feb 2007 06:11:39 +0200 (EET)
Received: from localhost (katosiko.hut.fi [130.233.228.115])
	by smtp-3.hut.fi (8.13.6/8.12.10) with ESMTP id l1I4BcSE017352	for
 <jkmaline@cc.hut.fi>; Sun, 18 Feb 2007 06:11:38 +0200
Received: from smtp-3.hut.fi ([130.233.228.93])
 by localhost (katosiko.hut.fi [130.233.228.115]) (amavisd-new, port 10024)
 with LMTP id 21085-47 for <jkmaline@cc.hut.fi>; Sun,
 18 Feb 2007 06:11:38 +0200 (EET)
Received: from vger.kernel.org (vger.kernel.org [209.132.176.167])
	by smtp-3.hut.fi (8.13.6/8.12.10) with ESMTP id l1I49eFn017253	for
 <jkmaline@cc.hut.fi>; Sun, 18 Feb 2007 06:09:41 +0200
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand	id
 S932240AbXBREJk (ORCPT <rfc822;jkmaline@cc.hut.fi>); Sat,
 17 Feb 2007 23:09:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932400AbXBREJk
	(ORCPT <rfc822;linux-wireless-outgoing>); Sat, 17 Feb 2007 23:09:40 -0500
Received: from smtp116.iad.emailsrvr.com
 ([207.97.245.116]:42995 "EHLO	smtp116.iad.emailsrvr.com"
 rhost-flags-OK-OK-OK-OK) by vger.kernel.org	with ESMTP id S932240AbXBREJj
 (ORCPT	<rfc822;linux-wireless@vger.kernel.org>); Sat,
 17 Feb 2007 23:09:39 -0500
Received: from [192.168.1.100]
 (c-24-34-179-5.hsd1.ma.comcast.net [24.34.179.5])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)	(Authenticated sender: ddrake@brontes3d.com)
	by relay1.r1.iad.emailsrvr.com (SMTP Server) with ESMTP id 2D81E44C0C5; Sat,
 17 Feb 2007 22:40:20 -0500 (EST)
Date: Sat, 17 Feb 2007 22:41:13 -0500
From: Daniel Drake <dsd@gentoo.org>
Subject: Re: IPW2200 monitoring FW broken
In-reply-to: <200702151840.16963.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
To: Michael Buesch <mb@bu3sch.de>
Cc: linux-wireless@vger.kernel.org, James Ketrenos <jketreno@linux.intel.com>
Message-id: <45D7CAD9.5030602@gentoo.org>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
Precedence: bulk
User-Agent: Thunderbird 2.0b2 (X11/20070208)
X-Greylist: delayed 1759 seconds by postgrey-1.27 at vger.kernel.org; Sat,
 17 Feb 2007 23:09:39 EST
X-Spam-Checker-Version: SpamAssassin 2.64 (2004-01-11) on katosiko.hut.fi
X-TKK-Virus-Scanned: by amavisd-new-2.1.2-hutcc at katosiko.hut.fi
References: <200702151840.16963.mb@bu3sch.de>
X-Mailing-List: linux-wireless@vger.kernel.org
Original-recipient: rfc822;jkmaline@cc.hut.fi
Status: RO
Content-Length: 840
Lines: 22

Michael Buesch wrote:
> Is IPW2200 monitoring FW still broken?
> I miss huge amounts of packets when I try to monitor
> some traffic.

I had the same problem with ipw2200 once. I lost the hardware before I 
had a chance to dig into it, but then noticed ipw3945 on my laptop doing 
the same thing.

I've now narrowed it down a bit further: if i load ipw3945/ipw3945d and 
associate to a network in managed mode before switching to monitor mode, 
  then when monitoring I only see about 1/4 of all traffic.

But, if I load the driver and go straight into monitor mode, things are 
peachy. Maybe the same thing is happening for ipw2200?

Daniel

