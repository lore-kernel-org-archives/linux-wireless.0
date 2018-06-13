Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:50008 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935188AbeFMLlA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 13 Jun 2018 07:41:00 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: ath10k: htt_tx: mark expected switch fall-throughs
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180524225928.GA19570@embeddedor.com>
References: <20180524225928.GA19570@embeddedor.com>
To: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc: Kalle Valo <kvalo@qca.qualcomm.com>,
        "David S. Miller" <davem@davemloft.net>,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Message-Id: <20180613114100.2365F6074D@smtp.codeaurora.org> (sfid-20180613_134156_115582_4DA3A72A)
Date: Wed, 13 Jun 2018 11:41:00 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Gustavo A. R. Silva" <gustavo@embeddedor.com> wrote:

> In preparation to enabling -Wimplicit-fallthrough, mark switch cases
> where we are expecting to fall through.
> 
> Notice that in this particular case, I replaced "pass through" with
> a proper "fall through" comment, which is what GCC is expecting
> to find.
> 
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

f1d270ae10ff ath10k: htt_tx: mark expected switch fall-throughs

-- 
https://patchwork.kernel.org/patch/10425691/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
