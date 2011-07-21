Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f42.google.com ([209.85.210.42]:48544 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750852Ab1GUWaM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jul 2011 18:30:12 -0400
Received: by pzk37 with SMTP id 37so2566977pzk.1
        for <linux-wireless@vger.kernel.org>; Thu, 21 Jul 2011 15:30:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1310835342-18877-1-git-send-email-hauke@hauke-m.de>
References: <1310835342-18877-1-git-send-email-hauke@hauke-m.de>
Date: Fri, 22 Jul 2011 00:30:11 +0200
Message-ID: <CACna6ryjYGuLc5c88eke=gjgwQyVD+A9afM6zCRhqV1THHgWvA@mail.gmail.com> (sfid-20110722_003016_370563_DD7D1ADA)
Subject: Re: [PATCH v2 00/11] bcma: add support for embedded devices like bcm4716
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: ralf@linux-mips.org, linux-wireless@vger.kernel.org,
	linux-mips@linux-mips.org, jonas.gorski@gmail.com, mb@bu3sch.de,
	george@znau.edu.ua, arend@broadcom.com,
	b43-dev@lists.infradead.org, bernhardloos@googlemail.com,
	arnd@arndb.de, julian.calaby@gmail.com, sshtylyov@mvista.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2011/7/16 Hauke Mehrtens <hauke@hauke-m.de>:
> This patch series adds support for embedded devices like bcm47xx to
> bcma. Bcma is used on bcm4716 and bcm4718 SoCs as the system bus and
> replaced ssb used on older devices. With these patches my bcm4716
> device boots up till it tries to access the flash, because the serial
> flash chip is unsupported for now, this will be my next task. This adds
> support for MIPS cores, interrupt configuration and the serial console.
>
> These patches are not containing all functions needed to get the SoC to
> fully work and support every feature, but it is a good start.
> These patches are now integrated in OpenWrt for everyone how wants to
> test them.
>
> This was tested with a BCM4704 device (SoC with ssb bus), a BCM4716
> device and a pcie wireless card supported by bcma.
>
>
> @Rafał: If you are fine with the bcma patches could you please give
> your Signed-off on them.
>
> @Ralf: Could you please merger this into the mips tree so that it will be in linux-3.1.

ML for bcma is linux-wireless. Should we pass that patches "via" Ralf
or John? Using linux-wireless (and John's tree) makes more sense to
me, as we will work on the same tree and will get less merge
conflicts. However don't take me as Linux development style guru, just
my POV.

-- 
Rafał
