Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f51.google.com ([209.85.219.51]:43702 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755551Ab3G2VXo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Jul 2013 17:23:44 -0400
Received: by mail-oa0-f51.google.com with SMTP id h2so2072817oag.38
        for <linux-wireless@vger.kernel.org>; Mon, 29 Jul 2013 14:23:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <51F6DB65.4000302@hauke-m.de>
References: <1375124213-28051-1-git-send-email-Larry.Finger@lwfinger.net>
	<CACna6rzu4U+v1v1vj-+XyJHpReXMB3nscKP_C5jjbAAbKLQcKA@mail.gmail.com>
	<CACna6rxvnU_cwphP+Vvn_-CLuEcqMufEo4Zk7-Xqd63OA4Zmqg@mail.gmail.com>
	<51F6DB65.4000302@hauke-m.de>
Date: Mon, 29 Jul 2013 23:23:43 +0200
Message-ID: <CACna6ryQTWhyFtrWaKc_E-Zx_O16qb78uYRCwHT6x6n3pQzkVw@mail.gmail.com> (sfid-20130729_232348_045515_AD202EA9)
Subject: Re: [PATCH V2] fwcutter: Add firmware 6.30.163.46
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org,
	m@bues.ch
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2013/7/29 Hauke Mehrtens <hauke@hauke-m.de>:
> On 07/29/2013 10:07 PM, Rafał Miłecki wrote:
>> 2013/7/29 Rafał Miłecki <zajec5@gmail.com>:
>>> 2013/7/29 Larry Finger <Larry.Finger@lwfinger.net>:
>>>> This firmware version can be extracted from the GPL tarball for the ASUS
>>>> GPL code for the RT-AC66U 802.11ac Dual-Band Wireless-AC1750 Gigabit Router.
>>>>
>>>> I believe this to be the first instance of 802.11ac firmware for Broadcom
>>>> hardware. The firmware is version 784.2.
>>>>
>>>> Note: The http://www.lwfinger.com/broadcom-wl-6.30.163.46.tar.bz2 is the URL
>>>> of the extracted apsta binary. The full GPL package is at
>>>> http://dlcdnet.asus.com/pub/ASUS/wireless/RT-AC66U/GPL_RT_AC66U_3004372.zip.
>>>
>>> There is some (probably outdated) list of Broadcom 802.11ac routers:
>>> ASUS RT-AC66U
>>> Linksys EA6500
>>> Netgear R6300
>>>
>>> Did you compare wl.ko drivers from the 2 other firmwares? Is this the
>>> newest one?
>>>
>>> Did you start AC-PHY RE process?
>>
>> In case you wonder, I have a MIPS router with BCM4331 + BCM4360,
>> unfrotunately there isn't mmiotrace available for MIPS, so I can't
>> start RE that way :(
>>
>> I may think about buying PCE-AC66 at some point.
>>
> Hi Rafał,
>
> I have a Netgear R6250 (BCM4708 ARM Contex-A9) router with BCM4331 +
> BCM4360 and I am currently adding support for it to OpenWrt and mainline
> Linux kernel, could mmiotrace work on this CPU?

mmiotrace is x86/x86_64 only at this point :(

-- 
Rafał
