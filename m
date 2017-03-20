Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:52048 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753172AbdCTRMO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 20 Mar 2017 13:12:14 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [4.12] bcma: drop unneeded check for CONFIG_OF_IRQ
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20170303103330.4914-1-zajec5@gmail.com>
References: <20170303103330.4914-1-zajec5@gmail.com>
To: =?utf-8?b?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
        Arnd Bergmann <arnd@arndb.de>
Message-Id: <20170320171125.294686076D@smtp.codeaurora.org> (sfid-20170320_181218_582484_4E72FDB5)
Date: Mon, 20 Mar 2017 17:11:25 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rafał Miłecki wrote:
> From: Rafał Miłecki <rafal@milecki.pl>
> 
> We already have the same check in bcma_of_get_irq which really calls
> symbols available with CONFIG_OF_IRQ only. It appears this duplicated
> check was accidentally added in commit c58d900cc96a ("bcma: fix building
> without OF_IRQ"). The rest of code in bcma_of_fill_device should work
> fine without CONFIG_OF_IRQ.
> 
> Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Acked-by: Arnd Bergmann <arnd@arndb.de>

Patch applied to wireless-drivers-next.git, thanks.

48d197765534 bcma: drop unneeded check for CONFIG_OF_IRQ

-- 
https://patchwork.kernel.org/patch/9602523/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
