Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f178.google.com ([209.85.214.178]:56997 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753144Ab3G2UH2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Jul 2013 16:07:28 -0400
Received: by mail-ob0-f178.google.com with SMTP id ef5so2451526obb.23
        for <linux-wireless@vger.kernel.org>; Mon, 29 Jul 2013 13:07:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CACna6rzu4U+v1v1vj-+XyJHpReXMB3nscKP_C5jjbAAbKLQcKA@mail.gmail.com>
References: <1375124213-28051-1-git-send-email-Larry.Finger@lwfinger.net>
	<CACna6rzu4U+v1v1vj-+XyJHpReXMB3nscKP_C5jjbAAbKLQcKA@mail.gmail.com>
Date: Mon, 29 Jul 2013 22:07:27 +0200
Message-ID: <CACna6rxvnU_cwphP+Vvn_-CLuEcqMufEo4Zk7-Xqd63OA4Zmqg@mail.gmail.com> (sfid-20130729_220731_801203_DD6D0D4D)
Subject: Re: [PATCH V2] fwcutter: Add firmware 6.30.163.46
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: m@bues.ch, linux-wireless@vger.kernel.org,
	b43-dev@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2013/7/29 Rafał Miłecki <zajec5@gmail.com>:
> 2013/7/29 Larry Finger <Larry.Finger@lwfinger.net>:
>> This firmware version can be extracted from the GPL tarball for the ASUS
>> GPL code for the RT-AC66U 802.11ac Dual-Band Wireless-AC1750 Gigabit Router.
>>
>> I believe this to be the first instance of 802.11ac firmware for Broadcom
>> hardware. The firmware is version 784.2.
>>
>> Note: The http://www.lwfinger.com/broadcom-wl-6.30.163.46.tar.bz2 is the URL
>> of the extracted apsta binary. The full GPL package is at
>> http://dlcdnet.asus.com/pub/ASUS/wireless/RT-AC66U/GPL_RT_AC66U_3004372.zip.
>
> There is some (probably outdated) list of Broadcom 802.11ac routers:
> ASUS RT-AC66U
> Linksys EA6500
> Netgear R6300
>
> Did you compare wl.ko drivers from the 2 other firmwares? Is this the
> newest one?
>
> Did you start AC-PHY RE process?

In case you wonder, I have a MIPS router with BCM4331 + BCM4360,
unfrotunately there isn't mmiotrace available for MIPS, so I can't
start RE that way :(

I may think about buying PCE-AC66 at some point.

-- 
Rafał
