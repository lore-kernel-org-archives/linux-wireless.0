Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f50.google.com ([209.85.218.50]:35582 "EHLO
	mail-oi0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751381AbbHMLSk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Aug 2015 07:18:40 -0400
Received: by oiew67 with SMTP id w67so6057475oie.2
        for <linux-wireless@vger.kernel.org>; Thu, 13 Aug 2015 04:18:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1438538405-9133-1-git-send-email-hauke@hauke-m.de>
References: <1437512677-6153-1-git-send-email-linus.walleij@linaro.org>
	<1438538405-9133-1-git-send-email-hauke@hauke-m.de>
Date: Thu, 13 Aug 2015 13:18:40 +0200
Message-ID: <CACRpkdbprBcAajO=uggd5nQ27NFnZgrPf_JfUpBuzP8fYuL5dA@mail.gmail.com> (sfid-20150813_131845_074265_F620E0E2)
Subject: Re: [PATCH v2] bcma: switch GPIO portions to use GPIOLIB_IRQCHIP
From: Linus Walleij <linus.walleij@linaro.org>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: Kalle Valo <kvalo@codeaurora.org>,
	=?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	Felix Fietkau <nbd@openwrt.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Aug 2, 2015 at 8:00 PM, Hauke Mehrtens <hauke@hauke-m.de> wrote:

> From: Linus Walleij <linus.walleij@linaro.org>
>
> This switches the BCMA GPIO driver to use GPIOLIB_IRQCHIP to
> handle its interrupts instead of rolling its own copy of the
> irqdomain handling etc.
>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
> ---
>
> I fixed some bugs in the original patch, some of them are compile
> errors and others caused some runtime problems. This patch worked on my
> BCM4708 based device, I was able to receive an IRQ for a GPIO change
> (button press).

Thanks a *LOT* for spending the effort of fixing up my
uglyhack.

> I think this should go through the wireless tree.
>
> @Linus could you please check if the changes I did are correct?

LooksGoodToMe(TM)

Yours,
Linus Walleij
