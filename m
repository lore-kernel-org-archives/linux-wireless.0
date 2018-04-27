Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:56272 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751416AbeD0Lk0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 27 Apr 2018 07:40:26 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: ath10k: sdio: jump to correct label in error handling path
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180426123502.23962-1-niklas.cassel@linaro.org>
References: <20180426123502.23962-1-niklas.cassel@linaro.org>
To: Niklas Cassel <niklas.cassel@linaro.org>
Cc: Kalle Valo <kvalo@qca.qualcomm.com>,
        Niklas Cassel <niklas.cassel@linaro.org>,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Message-Id: <20180427114026.79F1F60767@smtp.codeaurora.org> (sfid-20180427_134043_530879_790818D9)
Date: Fri, 27 Apr 2018 11:40:26 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Niklas Cassel <niklas.cassel@linaro.org> wrote:

> Jump to the correct label in error handling path.
> At this point of execution create_singlethread_workqueue() has succeeded,
> so it should be properly destroyed.
> 
> Jump label was renamed in commit ec2c64e20257 ("ath10k: sdio: fix memory
> leak for probe allocations").
> However, the bug was originally introduced in commit d96db25d2025
> ("ath10k: add initial SDIO support").
> 
> Fixes: d96db25d2025 ("ath10k: add initial SDIO support")
> Signed-off-by: Niklas Cassel <niklas.cassel@linaro.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

e60a92590187 ath10k: sdio: jump to correct label in error handling path

-- 
https://patchwork.kernel.org/patch/10365901/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
