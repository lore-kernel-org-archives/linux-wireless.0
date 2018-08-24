Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:51970 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726513AbeHXPZD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 24 Aug 2018 11:25:03 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [PATCH] wcn36xx: use dma_zalloc_coherent instead of
 allocator/memset
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180724115211.19264-1-yuehaibing@huawei.com>
References: <20180724115211.19264-1-yuehaibing@huawei.com>
To: YueHaibing <yuehaibing@huawei.com>
Cc: <davem@davemloft.net>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-wireless@vger.kernel.org>,
        <wcn36xx@lists.infradead.org>, YueHaibing <yuehaibing@huawei.com>
Message-Id: <20180824115045.185996032D@smtp.codeaurora.org> (sfid-20180824_135057_279538_75CB6E6B)
Date: Fri, 24 Aug 2018 11:50:45 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

YueHaibing <yuehaibing@huawei.com> wrote:

> Use dma_zalloc_coherent instead of dma_alloc_coherent
> followed by memset 0.
> 
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

d410e28f3ae4 wcn36xx: use dma_zalloc_coherent instead of allocator/memset

-- 
https://patchwork.kernel.org/patch/10541939/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
