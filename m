Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:61012 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751666Ab0IOIAp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Sep 2010 04:00:45 -0400
MIME-Version: 1.0
In-Reply-To: <AANLkTikAFCd+3ggZKhQXY=+bG==KgLkv3qNVdEGa=GBX@mail.gmail.com>
References: <1283376410-9999-1-git-send-email-ohad@wizery.com>
 <1283376410-9999-4-git-send-email-ohad@wizery.com> <AANLkTi=goLEUqM1XQ__PrGu4=Erw2utaNP4qFmSgRta2@mail.gmail.com>
 <20100906120716.GE20903@n2100.arm.linux.org.uk> <AANLkTikAFCd+3ggZKhQXY=+bG==KgLkv3qNVdEGa=GBX@mail.gmail.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Wed, 15 Sep 2010 10:00:22 +0200
Message-ID: <AANLkTinM8vY7CygEN6DBR35WLkU-QOBwuiaRrpfwF6Mz@mail.gmail.com>
Subject: Re: [PATCH v5 3/7] wireless: wl12xx: add platform data passing support
To: =?ISO-8859-2?Q?Micha=B3_Miros=B3aw?= <mirqus@gmail.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
	linux-wireless@vger.kernel.org, linux-mmc@vger.kernel.org,
	linux-omap@vger.kernel.org, Kalle Valo <kalle.valo@iki.fi>,
	Nicolas Pitre <nico@fluxnic.net>,
	Tony Lindgren <tony@atomide.com>,
	Mark Brown <broonie@opensource.wolfsonmicro.com>,
	Roger Quadros <roger.quadros@nokia.com>,
	Ido Yariv <ido@wizery.com>, San Mehat <san@google.com>,
	Chikkature Rajashekar Madhusudhan <madhu.cr@ti.com>,
	Luciano Coelho <luciano.coelho@nokia.com>,
	akpm@linux-foundation.org, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-2
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2010/9/6 Micha³ Miros³aw <mirqus@gmail.com>:
> W dniu 6 wrze¶nia 2010 14:07 u¿ytkownik Russell King - ARM Linux
> <linux@arm.linux.org.uk> napisa³:
>> On Sat, Sep 04, 2010 at 02:23:19PM +0200, Micha³ Miros³aw wrote:
>>> 2010/9/1 Ohad Ben-Cohen <ohad@wizery.com>:
>>> > Add a simple mechanism to pass platform data to the
>>> > SDIO instances of wl12xx.
> [cut patch]
>>> Why do you need all that copying? Isn't the data constant?
>>
>> The first copy is to allow platforms to have their data marked with
>> __initdata.  The second copy probably isn't necessary, but avoids
>> problems where the driver may decide to modify the platform data.
>
> Sorry for pushing at this, but why would you mark data that's meant to
> be used after init phase as __initdata?

I can remove the first copying as well if Russell is ok with it.

Both ways work for us.

>
> Best Regards,
> Micha³ Miros³aw
>
