Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mta-out.inet.fi ([195.156.147.13]:58107 "EHLO kirsi1.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753277Ab2KYTK4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Nov 2012 14:10:56 -0500
Subject: Re: Atheros AR3012 problem in Ubuntu 12.04LTS
From: Jukka Kivari <jukka.kivari@pohjolantietotekniikka.fi>
Reply-To: jukka.kivari@pohjolantietotekniikka.fi
To: Kalle Valo <kvalo@adurom.com>
Cc: mcgrof@qca.qualcomm.com, linux-wireless@vger.kernel.org
In-Reply-To: <87a9u5wraw.fsf@purkki.adurom.net>
References: <1353859765.3743.14.camel@EDAnovaSRV1>
	 <87a9u5wraw.fsf@purkki.adurom.net>
Content-Type: text/plain
Date: Sun, 25 Nov 2012 21:10:47 +0200
Message-Id: <1353870648.2973.9.camel@EDAnovaSRV1> (sfid-20121125_201058_358765_746C0401)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Thanks for quick response.

We are using standard Ubuntu release. We don't have access to Dell
pre-installed version (yet) as it's not available/supported in Finland.
I have asked it from Dell but let's see if we get it or not.

BT isn't working on standard 11.10 Ubuntu either, nor in 12.10.

We haven't tried manual binding yet. We'll check it.


-- 

-Jukka


****************
Powered by Linux
****************




-----Original Message-----
From: Kalle Valo <kvalo@adurom.com>
To: jukka.kivari@pohjolantietotekniikka.fi
Cc: mcgrof@qca.qualcomm.com, linux-wireless@vger.kernel.org
Subject: Re: Atheros AR3012 problem in Ubuntu 12.04LTS
Date: Sun, 25 Nov 2012 19:00:55 +0200

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


