Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:34954 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751043AbbHRGJ0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Aug 2015 02:09:26 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: [v3] bcma: switch GPIO portions to use GPIOLIB_IRQCHIP
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1439504505-20314-1-git-send-email-hauke@hauke-m.de>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: linus.walleij@linaro.org, zajec5@gmail.com, nbd@openwrt.org,
	linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Message-Id: <20150818060926.6ECEB1403E6@smtp.codeaurora.org> (sfid-20150818_080929_988496_C7BBDCFA)
Date: Tue, 18 Aug 2015 06:09:26 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> From: Linus Walleij <linus.walleij@linaro.org>
> 
> This switches the BCMA GPIO driver to use GPIOLIB_IRQCHIP to
> handle its interrupts instead of rolling its own copy of the
> irqdomain handling etc.
> 
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>

Thanks, applied to wireless-drivers-next.git.

Kalle Valo
