Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:47532 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934047AbeFNPMz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Jun 2018 11:12:55 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: ath10k: use dma_zalloc_coherent instead of allocator/memset
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180604123542.24336-1-yuehaibing@huawei.com>
References: <20180604123542.24336-1-yuehaibing@huawei.com>
To: YueHaibing <yuehaibing@huawei.com>
Cc: <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-wireless@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
Message-Id: <20180614151255.4FE53606DB@smtp.codeaurora.org> (sfid-20180614_171311_286441_ACDAB04B)
Date: Thu, 14 Jun 2018 15:12:55 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

YueHaibing <yuehaibing@huawei.com> wrote:

> Use dma_zalloc_coherent instead of dma_alloc_coherent
> followed by memset 0.
> 
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

9fb31b66b91f ath10k: use dma_zalloc_coherent instead of allocator/memset

-- 
https://patchwork.kernel.org/patch/10446535/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
