Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f173.google.com ([209.85.223.173]:34347 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753214AbbGWAYm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jul 2015 20:24:42 -0400
Received: by iebmu5 with SMTP id mu5so179745783ieb.1
        for <linux-wireless@vger.kernel.org>; Wed, 22 Jul 2015 17:24:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1437512677-6153-1-git-send-email-linus.walleij@linaro.org>
References: <1437512677-6153-1-git-send-email-linus.walleij@linaro.org>
Date: Thu, 23 Jul 2015 02:24:42 +0200
Message-ID: <CACna6rxkPVPz9N6ueOeuxwrDuQ8rRU9XZS9FdTZP1Yqd5=4+QQ@mail.gmail.com> (sfid-20150723_022445_808352_B5DC6DBA)
Subject: Re: [PATCH] bcma: switch GPIO portions to use GPIOLIB_IRQCHIP
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Felix Fietkau <nbd@openwrt.org>, Kalle Valo <kvalo@codeaurora.org>,
	Hauke Mehrtens <hauke@hauke-m.de>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 21 July 2015 at 23:04, Linus Walleij <linus.walleij@linaro.org> wrote:
> This switches the BCMA GPIO driver to use GPIOLIB_IRQCHIP to
> handle its interrupts instead of rolling its own copy of the
> irqdomain handling etc.
>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
> Hi BCMA people,
>
> if we can figure this out it would be great if you can test this
> and merge it through whatever GIT tree handles BCMA patches.
> Alternatively I can merge it into the GPIO tree with your ACK.
>
> This is not even compiled, I don't have the right cross compilers
> but the conversion is done like all other GPIOLIB_IRQCHIP conversions
> I've done, so it shouldn't be very far off. Maybe you can get it
> in shape in accordance with my idea if I screwed up? Thanks.

I'm away one my holidays, won't be able to check it anytime soon.
Unless someone else willing to test it appears, I guess we should hold
it for now, sorry :( I'll for sure handle this after my holidays (late
august).
