Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:46990 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754927AbeFNPL5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Jun 2018 11:11:57 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v2] ath10k: fix incorrect size of dma_free_coherent in
 ath10k_ce_alloc_src_ring_64
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180601112548.22592-1-yuehaibing@huawei.com>
References: <20180601112548.22592-1-yuehaibing@huawei.com>
To: YueHaibing <yuehaibing@huawei.com>
Cc: <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <ath10k@lists.infradead.org>,
        <linux-wireless@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
Message-Id: <20180614151157.32C1D60116@smtp.codeaurora.org> (sfid-20180614_171215_105370_5C5F83E1)
Date: Thu, 14 Jun 2018 15:11:57 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

YueHaibing <yuehaibing@huawei.com> wrote:

> sizeof(struct ce_desc) should be a copy-paste mistake
> just use sizeof(struct ce_desc_64) to avoid mem leak
> 
> Fixes: b7ba83f7c414 ("ath10k: add support for shadow register for WNC3990")
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

5a211627004e ath10k: fix incorrect size of dma_free_coherent in ath10k_ce_alloc_src_ring_64

-- 
https://patchwork.kernel.org/patch/10443063/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
