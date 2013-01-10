Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f45.google.com ([74.125.82.45]:55776 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751112Ab3AJJKZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Jan 2013 04:10:25 -0500
Received: by mail-wg0-f45.google.com with SMTP id dq12so134276wgb.12
        for <linux-wireless@vger.kernel.org>; Thu, 10 Jan 2013 01:10:24 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1357257085-11822-1-git-send-email-hauke@hauke-m.de>
References: <1357257085-11822-1-git-send-email-hauke@hauke-m.de>
Date: Thu, 10 Jan 2013 10:04:07 +0100
Message-ID: <CACna6rwPnx-PgNZ1QHczBTLKB5dmcJx1zpDYtbFtALBbvCNu9g@mail.gmail.com> (sfid-20130110_101031_419584_3415D7B4)
Subject: Re: [PATCH 0/6] bcma: some fixes for mips IRQ assignment
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	nlhintz@hotmail.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2013/1/4 Hauke Mehrtens <hauke@hauke-m.de>:
> This improves IRQ assignment to cores on a mips SoC.
>
> Hauke Mehrtens (6):
>   bcma: make bcma_find_core_unit() accessible
>   bcma: mips: explicit assign IRQ numbers
>   bcma: mips: make some info messages debug messages
>   bcma: mips: show also disabled IRQs
>   bcma: mips: remove assigned_irqs from structure
>   bcma: mips: rename oldirqflag to irqinitmask

OK, well, the patchset was applied... did someone at least tried to compile it?

  CC      drivers/bcma/driver_mips.o
drivers/bcma/driver_mips.c: In function 'bcma_core_mips_init':
drivers/bcma/driver_mips.c:302:4: error: implicit declaration of
function 'bcma_core_irq' [-Werror=implicit-function-declaration]
cc1: some warnings being treated as errors
make[6]: *** [drivers/bcma/driver_mips.o] Error 1

Am I missing something?

-- 
Rafał
