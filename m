Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:46954 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751637AbdF1Qip (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Jun 2017 12:38:45 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: ti: wl18xx: add checks on wl18xx_top_reg_write() return value
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20170626230619.GA14831@embeddedgus>
References: <20170626230619.GA14831@embeddedgus>
To: "Gustavo A. R. Silva" <garsilva@embeddedor.com>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <garsilva@embeddedor.com>
Message-Id: <20170628163844.455B5605BD@smtp.codeaurora.org> (sfid-20170628_184116_987460_FDF12B61)
Date: Wed, 28 Jun 2017 16:38:44 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Gustavo A. R. Silva" <garsilva@embeddedor.com> wrote:

> Check return value from call to wl18xx_top_reg_write(),
> so in case of error jump to goto label out and return.
> 
> Also, remove unnecessary value check before goto label out.
> 
> Addresses-Coverity-ID: 1226938
> Signed-off-by: Gustavo A. R. Silva <garsilva@embeddedor.com>

The prefix should be "wl18xx:", I'll fix that.

-- 
https://patchwork.kernel.org/patch/9810591/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
