Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:39010 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750838AbeAYFg4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 25 Jan 2018 00:36:56 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v2] wcn36xx: release resources in case of error
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180123152013.18257-1-rfried@codeaurora.org>
References: <20180123152013.18257-1-rfried@codeaurora.org>
To: Ramon Fried <rfried@codeaurora.org>
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        bjorn.andersson@linaro.org, wcn36xx@lists.infradead.org,
        k.eugene.e@gmail.com, Ramon Fried <rfried@codeaurora.org>
Message-Id: <20180125053656.2ADDF60A60@smtp.codeaurora.org> (sfid-20180125_063704_433764_78EADC8E)
Date: Thu, 25 Jan 2018 05:36:56 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ramon Fried <rfried@codeaurora.org> wrote:

> wcn36xx_dxe_init() doesn't check for the return value of
> wcn36xx_dxe_init_descs(), release the resources in case an error ocurred.
> 
> Signed-off-by: Ramon Fried <rfried@codeaurora.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

d0bb950b9f5f wcn36xx: release DMA memory in case of error

-- 
https://patchwork.kernel.org/patch/10180503/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
