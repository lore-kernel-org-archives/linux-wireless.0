Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:53316 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751995Ab3JGURx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Oct 2013 16:17:53 -0400
Received: from [192.168.2.100] ([93.218.71.155]) by mail.gmx.com (mrgmx002)
 with ESMTPSA (Nemesis) id 0MSv6D-1VLOzy31AD-00RuC5 for
 <linux-wireless@vger.kernel.org>; Mon, 07 Oct 2013 22:17:51 +0200
Message-ID: <525316EF.6070102@rempel-privat.de> (sfid-20131007_221757_018196_8A02CC00)
Date: Mon, 07 Oct 2013 22:17:51 +0200
From: Oleksij Rempel <linux@rempel-privat.de>
MIME-Version: 1.0
To: =?UTF-8?B?QWxleGFuZGVyIE3DvGxsZXI=?= <Alexander.Mueller@jambit.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: WIFI USB-Stick for P2P
References: <E8A6515F57A7AE4EA65BED3559D774CE1B151ABF@exc1.jambit.com>
In-Reply-To: <E8A6515F57A7AE4EA65BED3559D774CE1B151ABF@exc1.jambit.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am 07.10.2013 11:08, schrieb Alexander Müller:
> Hello linux-wireless,
> 
> I'm wondering if there is a list of usb wifi devices having a good and stable p2p support for wifi direct. We are currently using an AVM Fritz wifi stick that is supported by the carl9170 driver, but it is experiencing random failures and stalls which require a hardware reset. The p2p howto page at http://wireless.kernel.org/en/developers/p2p/howto suggests that there may be other devices and drivers supporting p2p, but I haven't figured out exactly which devices work best.
> 
> Can you give me a hint?

You can try ath9k_htc based device. It should be able to support P2P,
but right now i was not able to transfer any data. p2p_find and
p2p_connect seems to work.

If you wont to do some more testing with ath9k_htc, please contact me.
-- 
Regards,
Oleksij
