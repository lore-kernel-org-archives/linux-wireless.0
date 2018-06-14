Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:50812 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755033AbeFNPTo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Jun 2018 11:19:44 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: ath10k: Skip data calibration for non-bmi target
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1528866215-24754-1-git-send-email-svishnoi@codeaurora.org>
References: <1528866215-24754-1-git-send-email-svishnoi@codeaurora.org>
To: Surabhi Vishnoi <svishnoi@codeaurora.org>
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        Surabhi Vishnoi <svishnoi@codeaurora.org>
Message-Id: <20180614151944.53D11602FC@smtp.codeaurora.org> (sfid-20180614_171947_875895_CBCFB06C)
Date: Thu, 14 Jun 2018 15:19:44 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Surabhi Vishnoi <svishnoi@codeaurora.org> wrote:

> In non-bmi target ex. WCN3990, data calibration
> is handled via QMI.
> 
> Skip data calibration in debug routine to enable ath10k
> debugfs for non bmi targets.
> 
> Signed-off-by: Surabhi Vishnoi <svishnoi@codeaurora.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

5db98aee93cd ath10k: skip data calibration for non-bmi target

-- 
https://patchwork.kernel.org/patch/10461559/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
