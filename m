Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:49587 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753237Ab2KYRA5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Nov 2012 12:00:57 -0500
From: Kalle Valo <kvalo@adurom.com>
To: jukka.kivari@pohjolantietotekniikka.fi
Cc: mcgrof@qca.qualcomm.com, linux-wireless@vger.kernel.org
Subject: Re: Atheros AR3012 problem in Ubuntu 12.04LTS
References: <1353859765.3743.14.camel@EDAnovaSRV1>
Date: Sun, 25 Nov 2012 19:00:55 +0200
In-Reply-To: <1353859765.3743.14.camel@EDAnovaSRV1> (Jukka Kivari's message of
	"Sun, 25 Nov 2012 18:09:25 +0200")
Message-ID: <87a9u5wraw.fsf@purkki.adurom.net> (sfid-20121125_180104_997013_91F4F654)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Moro,

Jukka Kivari <jukka.kivari@pohjolantietotekniikka.fi> writes:

> We have found out the Device is AR3012, VID/PID 0cf3:a003. It seems Dell
> has some special driver for this in pre-installed Ubuntu
> 11.10 

So the driver works with the pre-installed version?

Are the sources for this pre-installed Ubuntu publically available
somewhere or is it just a stock Ubuntu release? Being able to see kernel
sources from that release would help.

> My current analysis of the problem is:
>
> 1) BT device is recognized correctly (PID=e003)
> 2) Ubuntu 12.04 has all drivers and firmaware available

I didn't quite get this 2) part. How do you know that all drivers and
firmware are available? Earlier you mentioned about some special driver.

> 3) driver/firmaware loading fails, there is no PID e003 in btusb.c or
> ath3k.c

Have you tried to manually bind the device to those drivers? With very
good luck it might work (but I doubt it).

http://lwn.net/Articles/143397/

Also did you file a bug to Ubuntu? If the driver works in 11.10 but not
in 12.04 that's a regression.

-- 
Kalle Valo
