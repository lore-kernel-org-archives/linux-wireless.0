Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:45546 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753149AbeDJOdM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 10 Apr 2018 10:33:12 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: ath9k: dfs: remove accidental use of stack VLA
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180330183401.GA16758@embeddedgus>
References: <20180330183401.GA16758@embeddedgus>
To: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc: QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Message-Id: <20180410143312.6267D6014B@smtp.codeaurora.org> (sfid-20180410_163338_928665_59BB87A0)
Date: Tue, 10 Apr 2018 14:33:12 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Gustavo A. R. Silva" <gustavo@embeddedor.com> wrote:

> In preparation to enabling -Wvla, remove accidental use of stack VLA.
> 
> This avoids an accidental stack VLA (since the compiler thinks
> the value of FFT_NUM_SAMPLES can change, even when marked
> "const"). This just replaces it with a #define.
> 
> Also, fixed as part of the directive to remove all VLAs from
> the kernel: https://lkml.org/lkml/2018/3/7/621
> 
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

9c27489a3454 ath9k: dfs: remove accidental use of stack VLA

-- 
https://patchwork.kernel.org/patch/10318271/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
