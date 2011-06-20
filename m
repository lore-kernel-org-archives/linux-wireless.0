Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:63338 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750717Ab1FTAle convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Jun 2011 20:41:34 -0400
Received: by pzk9 with SMTP id 9so3080324pzk.19
        for <linux-wireless@vger.kernel.org>; Sun, 19 Jun 2011 17:41:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1308520209-668-1-git-send-email-hauke@hauke-m.de>
References: <1308520209-668-1-git-send-email-hauke@hauke-m.de>
Date: Mon, 20 Jun 2011 02:41:34 +0200
Message-ID: <BANLkTim5R1ukc5OJQRRpF6EsmzeoL=SUoA@mail.gmail.com> (sfid-20110620_024138_008642_12FAFD6C)
Subject: Re: [RFC v2 00/12] bcma: add support for embedded devices like bcm4716
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: linux-wireless@vger.kernel.org, linux-mips@linux-mips.org,
	mb@bu3sch.de, george@znau.edu.ua, arend@broadcom.com,
	b43-dev@lists.infradead.org, bernhardloos@googlemail.com,
	arnd@arndb.de, julian.calaby@gmail.com, sshtylyov@mvista.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hey Hauke,

2011/6/19 Hauke Mehrtens <hauke@hauke-m.de>:
> This patch series adds support for embedded devices like bcm47xx to
> bcma. Bcma is used on bcm4716 and bcm4718 SoCs. With these patches my
> bcm4716 device boots up till it tries to access the flash, because the
> serial flash chip is unsupported for now, this will be my next task.
> This adds support for MIPS cores, interrupt configuration and the
> serial console.
>
> These patches are based on ssb code, some patches by George Kashperko
> and Bernhard Loos and parts of the source code release by ASUS and
> Netgear for their devices.
>
> This was tested on a Netgear WNDR3400, but did not work fully because
> of serial flash.
>
> This is bases on linux-next next-20110616, to which subsystem
> maintainer should I send these patches later, as it is based on the
> most recent version of bcma and bcm47xx?
> I do not have any normal PCIe based wireless device using this bus, so
> I have not tested it with such a device, it will be nice to hear if it
> is still working on them.
> The parallel flash should work so it could be that it will boot on an
> Asus rt-n16, I have not tested that.

I'm glad you are still working on it!
Unfortunately it's really late right now and I'm leaving tomorrow
(well, today as we passed midnight) for the whole week :( I'm not sure
if I'll get a chance to review this, not to mention testing against
any of my PCIe card.


> An Ethernet driver is not included because the Braodcom source code
> available is not licensed under a GPL compatible license and building a
> new driver on that based is not possible.

I wonder if you could write specs for that core, so I could write
GPL/any driver for it? Is that driver really big?

-- 
Rafał
