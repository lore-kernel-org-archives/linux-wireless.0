Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:50814 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753935AbeDJOkd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 10 Apr 2018 10:40:33 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: wcn36xx: Remove useless skb spinlock
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1523009488-15772-1-git-send-email-loic.poulain@linaro.org>
References: <1523009488-15772-1-git-send-email-loic.poulain@linaro.org>
To: Loic Poulain <loic.poulain@linaro.org>
Cc: linux-wireless@vger.kernel.org, wcn36xx@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, bjorn.andersson@linaro.org,
        Loic Poulain <loic.poulain@linaro.org>
Message-Id: <20180410144033.6541660AFB@smtp.codeaurora.org> (sfid-20180410_164042_067157_70734F18)
Date: Tue, 10 Apr 2018 14:40:33 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Loic Poulain <loic.poulain@linaro.org> wrote:

> Each DXE control block is associated to a specific channel.
> The channel lock is always taken before accessing a control block.
> There is no need to have an extra (useless) spinlock for the control
> block skb.
> 
> Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

6062546d9b7f wcn36xx: Remove useless skb spinlock

-- 
https://patchwork.kernel.org/patch/10325829/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
