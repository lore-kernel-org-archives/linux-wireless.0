Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:51380 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965332AbeEYKEL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 25 May 2018 06:04:11 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [net-next] ath10k: Remove useless test before
 clk_disable_unprepare
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180516105454.30212-1-yuehaibing@huawei.com>
References: <20180516105454.30212-1-yuehaibing@huawei.com>
To: YueHaibing <yuehaibing@huawei.com>
Cc: <kvalo@qca.qualcomm.com>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>, <linux-wireless@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
Message-Id: <20180525100410.B904160F91@smtp.codeaurora.org> (sfid-20180525_120444_162486_0C2194D6)
Date: Fri, 25 May 2018 10:04:07 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

YueHaibing <yuehaibing@huawei.com> wrote:

> clk_disable_unprepare() already checks that the clock pointer is valid.
> No need to test it before calling it.
> 
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

cf3c0ae6a32b ath10k: remove useless test before clk_disable_unprepare

-- 
https://patchwork.kernel.org/patch/10403597/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
