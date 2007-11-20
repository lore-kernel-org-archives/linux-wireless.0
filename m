Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:52446 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752113AbXKTPJa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Nov 2007 10:09:30 -0500
Message-ID: <4742F8A7.6070903@lwfinger.net> (sfid-20071120_150931_984337_6300E402)
Date: Tue, 20 Nov 2007 09:09:27 -0600
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: Andreas Schwab <schwab@suse.de>
CC: Stefano Brivio <stefano.brivio@polimi.it>,
	"Rafael J. Wysocki" <rjw@sisk.pl>, linux-wireless@vger.kernel.org,
	bcm43xx-dev@lists.berlios.de, mb@bu3sch.de
Subject: Re: [PATCH v3] remove bcm43xx
References: <20071119202121.6ad3fa70@morte> <200711192300.12183.rjw@sisk.pl>	<20071119231935.535674ba@morte> <jehcjheubn.fsf@sykes.suse.de>	<20071120001329.3524494a@morte> <jed4u5esbo.fsf@sykes.suse.de>	<20071120011549.6b04bb4d@morte> <jeir3xdyqu.fsf@sykes.suse.de>
In-Reply-To: <jeir3xdyqu.fsf@sykes.suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Andreas Schwab wrote:
> Stefano Brivio <stefano.brivio@polimi.it> writes:
> 
>> --- drivers/net/wireless/b43/main.c.orig        2007-11-20 01:12:12.186524483 +0100
>> +++ drivers/net/wireless/b43/main.c     2007-11-20 01:12:34.922702865 +0100
>> @@ -947,7 +947,7 @@
>>
>>         while (1) {
>>                 v0 = b43_read32(dev, B43_MMIO_XMITSTAT_0);
>> -               if (!(v0 & 0x00000001))
>> +               if (!v0)
>>                         break;
>>                 v1 = b43_read32(dev, B43_MMIO_XMITSTAT_1);
>>
>> (probably it's not the solution, I just want to see what happens then).
> 
> That didn't change anything.
> 
>> BTW, what firmware are you using?
> 
> It's 410.2160 from wl_ap.o.

Please try version 351.126 from http://downloads.openwrt.org/sources/broadcom-wl-4.80.53.0.tar.bz2,
which is the officially supported version.

Larry
