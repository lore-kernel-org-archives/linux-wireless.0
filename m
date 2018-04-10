Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:48604 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754055AbeDJOig (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 10 Apr 2018 10:38:36 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [1/3] wcn36xx: check for DMA mapping errors in
 wcn36xx_dxe_tx_frame()
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180403165154.18775-1-daniel@zonque.org>
References: <20180403165154.18775-1-daniel@zonque.org>
To: Daniel Mack <daniel@zonque.org>
Cc: linux-wireless@vger.kernel.org, wcn36xx@lists.infradead.org,
        loic.poulain@linaro.org, rfried@codeaurora.org,
        bjorn.andersson@linaro.org, Daniel Mack <daniel@zonque.org>
Message-Id: <20180410143836.48D4B60D81@smtp.codeaurora.org> (sfid-20180410_163846_647965_5446E6D1)
Date: Tue, 10 Apr 2018 14:38:36 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Daniel Mack <daniel@zonque.org> wrote:

> Bail out if the mapping fails. Even though this hasn't occured during
> tests, this unlikely case should still be handled.
> 
> Signed-off-by: Daniel Mack <daniel@zonque.org>
> Acked-by: Ramon Fried <rfried@codeaurora.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

3 patches applied to ath-next branch of ath.git, thanks.

7cae35199bee wcn36xx: check for DMA mapping errors in wcn36xx_dxe_tx_frame()
271f1e65ff38 wcn36xx: don't keep reference to skb if transmission failed
2edfcf2b303c wcn36xx: don't delete invalid bss indices

-- 
https://patchwork.kernel.org/patch/10321545/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
