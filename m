Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:59312 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728443AbeICVUU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 3 Sep 2018 17:20:20 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [PATCH 2/2] ath10k: allow ATH10K_SNOC with COMPILE_TEST
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180612113907.15043-2-niklas.cassel@linaro.org>
References: <20180612113907.15043-2-niklas.cassel@linaro.org>
To: Niklas Cassel <niklas.cassel@linaro.org>
Cc: "David S. Miller" <davem@davemloft.net>,
        Niklas Cassel <niklas.cassel@linaro.org>,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Message-Id: <20180903165921.DAABA607F4@smtp.codeaurora.org> (sfid-20180903_190026_812840_91E61E57)
Date: Mon,  3 Sep 2018 16:59:21 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Niklas Cassel <niklas.cassel@linaro.org> wrote:

> ATH10K_SNOC builds just fine with COMPILE_TEST, so make that possible.
> 
> Signed-off-by: Niklas Cassel <niklas.cassel@linaro.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

f1908735f141 ath10k: allow ATH10K_SNOC with COMPILE_TEST

-- 
https://patchwork.kernel.org/patch/10460103/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
