Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:28373 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757587AbbJWBeS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Oct 2015 21:34:18 -0400
Message-ID: <56298F43.7000909@atmel.com> (sfid-20151023_033434_902658_41234129)
Date: Fri, 23 Oct 2015 10:37:07 +0900
From: glen lee <glen.lee@atmel.com>
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: <linux-wireless@vger.kernel.org>,
	Rachel Kim <rachel.kim@atmel.com>,
	<devel@driverdev.osuosl.org>, Chris Park <chris.park@atmel.com>,
	<gregkh@linuxfoundation.org>,
	Stanislav Kholmanskikh <kholmanskikh.s.s@gmail.com>,
	Johnny Kim <johnny.kim@atmel.com>,
	<linux-kernel@vger.kernel.org>, Tony Cho <tony.cho@atmel.com>,
	Leo Kim <leo.kim@atmel.com>
Subject: Re: [PATCH 00/19] staging/wilc1000 cleanups
References: <1445381258-1455986-1-git-send-email-arnd@arndb.de> <562763BC.5030107@atmel.com> <4948909.qZ1ebjqtXf@wuerfel>
In-Reply-To: <4948909.qZ1ebjqtXf@wuerfel>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On 2015년 10월 22일 21:23, Arnd Bergmann wrote:
> On Wednesday 21 October 2015 19:06:52 glen lee wrote:
>> Hi arnd,
>>
>> Thanks for the all the patches.
>> About the patch ( use proper naming for global symbols ),
>> We are planning to use this driver not only for wilc1000 but also for
>> other atmel wireless driver. I'd appreciate if you could use wl instead of wilc1000.
>>
>> And the global variable g_linux_wlan will be placed in netdevice private data
>> and finally it will be removed. I already posted some of those patches.
> I couldn't find the patches anywhere, but I've updated my series now
> to rename the symbols to wilc_* and to remove most but not all references to
> g_linux_wlan (or wilc_dev after my rename). Do you want me to post those
> so you can integrate them, or should I have a look at what you sent first
> (please send me a copy then).

Hi arnd,

I have tested with all the patches you have posted but it does not works. firmware start timed out
in the function wilc1000_start_firmware.
I also have tested with all the patched without last one, [RFC] one, but it shows
Segmentation fault when insmod driver.
For now, I can't rebase the patches. I'd appreciate if you could help us.

The title of my first patch is,
[PATCH 01/13] staging: wilc1000: add wilc to netdev private data structure
and also refer to [PATCH 00/12] WILC1000 V2 for the g_linux_wlan
( The patches posted by tony.cho@atmel.com )

By the way, deleting feature COMPLEMENT_BOOT patch already posted but not yet accepted.

Thank you.
Glen.

> 	Arnd

