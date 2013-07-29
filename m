Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:43613 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755464Ab3G2VPx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Jul 2013 17:15:53 -0400
Message-ID: <51F6DB65.4000302@hauke-m.de> (sfid-20130729_231558_754187_A15552F0)
Date: Mon, 29 Jul 2013 23:15:17 +0200
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org,
	m@bues.ch
Subject: Re: [PATCH V2] fwcutter: Add firmware 6.30.163.46
References: <1375124213-28051-1-git-send-email-Larry.Finger@lwfinger.net> <CACna6rzu4U+v1v1vj-+XyJHpReXMB3nscKP_C5jjbAAbKLQcKA@mail.gmail.com> <CACna6rxvnU_cwphP+Vvn_-CLuEcqMufEo4Zk7-Xqd63OA4Zmqg@mail.gmail.com>
In-Reply-To: <CACna6rxvnU_cwphP+Vvn_-CLuEcqMufEo4Zk7-Xqd63OA4Zmqg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/29/2013 10:07 PM, Rafał Miłecki wrote:
> 2013/7/29 Rafał Miłecki <zajec5@gmail.com>:
>> 2013/7/29 Larry Finger <Larry.Finger@lwfinger.net>:
>>> This firmware version can be extracted from the GPL tarball for the ASUS
>>> GPL code for the RT-AC66U 802.11ac Dual-Band Wireless-AC1750 Gigabit Router.
>>>
>>> I believe this to be the first instance of 802.11ac firmware for Broadcom
>>> hardware. The firmware is version 784.2.
>>>
>>> Note: The http://www.lwfinger.com/broadcom-wl-6.30.163.46.tar.bz2 is the URL
>>> of the extracted apsta binary. The full GPL package is at
>>> http://dlcdnet.asus.com/pub/ASUS/wireless/RT-AC66U/GPL_RT_AC66U_3004372.zip.
>>
>> There is some (probably outdated) list of Broadcom 802.11ac routers:
>> ASUS RT-AC66U
>> Linksys EA6500
>> Netgear R6300
>>
>> Did you compare wl.ko drivers from the 2 other firmwares? Is this the
>> newest one?
>>
>> Did you start AC-PHY RE process?
> 
> In case you wonder, I have a MIPS router with BCM4331 + BCM4360,
> unfrotunately there isn't mmiotrace available for MIPS, so I can't
> start RE that way :(
> 
> I may think about buying PCE-AC66 at some point.
> 
Hi Rafał,

I have a Netgear R6250 (BCM4708 ARM Contex-A9) router with BCM4331 +
BCM4360 and I am currently adding support for it to OpenWrt and mainline
Linux kernel, could mmiotrace work on this CPU?

Hauke
