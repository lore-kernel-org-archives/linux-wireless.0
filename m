Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:48702 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751941AbdF1SSy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Jun 2017 14:18:54 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: wl18xx: add checks on wl18xx_top_reg_write() return value
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20170626230619.GA14831@embeddedgus>
References: <20170626230619.GA14831@embeddedgus>
To: "Gustavo A. R. Silva" <garsilva@embeddedor.com>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <garsilva@embeddedor.com>
Message-Id: <20170628181853.7BFC460AD2@smtp.codeaurora.org> (sfid-20170628_201930_329874_FAC8D6C0)
Date: Wed, 28 Jun 2017 18:18:53 +0000 (UTC)
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

Patch applied to wireless-drivers-next.git, thanks.

059c98599b1a wl18xx: add checks on wl18xx_top_reg_write() return value

-- 
https://patchwork.kernel.org/patch/9810591/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
