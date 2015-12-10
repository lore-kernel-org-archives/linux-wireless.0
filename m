Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f174.google.com ([209.85.213.174]:38904 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751201AbbLJHlx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Dec 2015 02:41:53 -0500
MIME-Version: 1.0
In-Reply-To: <1449668633-5547-1-git-send-email-linus.walleij@linaro.org>
References: <1449668633-5547-1-git-send-email-linus.walleij@linaro.org>
Date: Thu, 10 Dec 2015 08:41:52 +0100
Message-ID: <CACna6rzNy_SjXqTbTB66_hCTWpO1eK25LQ7L9qw_kQQYw1DEPQ@mail.gmail.com> (sfid-20151210_084157_543147_47404E1B)
Subject: Re: [PATCH 153/182] bcma: gpio: use gpiochip data pointer
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
	Johan Hovold <johan@kernel.org>,
	Alexandre Courbot <acourbot@nvidia.com>,
	Michael Welling <mwelling@ieee.org>,
	Markus Pargmann <mpa@pengutronix.de>,
	Hauke Mehrtens <hauke@hauke-m.de>,
	Kalle Valo <kvalo@codeaurora.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 9 December 2015 at 14:43, Linus Walleij <linus.walleij@linaro.org> wrote:
> This makes the driver use the data pointer added to the gpio_chip
> to store a pointer to the state container instead of relying on
> container_of().
>
> Cc: Rafał Miłecki <zajec5@gmail.com>
> Cc: Hauke Mehrtens <hauke@hauke-m.de>
> Cc: Kalle Valo <kvalo@codeaurora.org>
> Cc: linux-wireless@vger.kernel.org
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
> BCMA maintainers: please ACK this so I can take it through the
> GPIO tree.

Acked-by: Rafał Miłecki <zajec5@gmail.com>
