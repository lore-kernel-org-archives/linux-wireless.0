Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:26979 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753319AbcKWN7m (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 23 Nov 2016 08:59:42 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: ath9k: fix ath9k_hw_gpio_get() to return 0 or 1 on success
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <44116a7bca8524a187083916bdea535145e7a23a.1479232041.git.mschiffer@universe-factory.net>
References: <44116a7bca8524a187083916bdea535145e7a23a.1479232041.git.mschiffer@universe-factory.net>
To: Matthias Schiffer <mschiffer@universe-factory.net>
CC: <kvalo@codeaurora.org>, <ath9k-devel@qca.qualcomm.com>,
        <linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>,
        <miaoqing@codeaurora.org>
Message-ID: <6ca850dc4e5c49f280f482c38b601456@euamsexm01a.eu.qualcomm.com> (sfid-20161123_145945_015661_6D54615F)
Date: Wed, 23 Nov 2016 14:58:44 +0100
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Matthias Schiffer <mschiffer@universe-factory.net> wrote:
> Commit b2d70d4944c1 ("ath9k: make GPIO API to support both of WMAC and
> SOC") refactored ath9k_hw_gpio_get() to support both WMAC and SOC GPIOs,
> changing the return on success from 1 to BIT(gpio). This broke some callers
> like ath_is_rfkill_set().
> 
> Instead of fixing all callers, change ath9k_hw_gpio_get() back to only
> return 0 or 1.
> 
> Fixes: b2d70d4944c1 ("ath9k: make GPIO API to support both of WMAC and SOC")
> Cc: <stable@vger.kernel.org> # v4.7+
> Signed-off-by: Matthias Schiffer <mschiffer@universe-factory.net>

Patch applied to ath-next branch of ath.git, thanks.

91851cc7a939 ath9k: fix ath9k_hw_gpio_get() to return 0 or 1 on success

-- 
https://patchwork.kernel.org/patch/9430247/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
