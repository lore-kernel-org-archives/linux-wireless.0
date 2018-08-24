Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:32880 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726513AbeHXTYF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 24 Aug 2018 15:24:05 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [PATCH v2] wcn36xx: Use dma_zalloc_coherent instead of
 dma_alloc_coherent + memset
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1534761895-10457-1-git-send-email-zhongjiang@huawei.com>
References: <1534761895-10457-1-git-send-email-zhongjiang@huawei.com>
To: zhong jiang <zhongjiang@huawei.com>
Cc: <davem@davemloft.net>, <wcn36xx@lists.infradead.org>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Message-Id: <20180824154852.96B9760214@smtp.codeaurora.org> (sfid-20180824_174910_720144_2B5A81C5)
Date: Fri, 24 Aug 2018 15:48:52 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

zhong jiang <zhongjiang@huawei.com> wrote:

> dma_zalloc_coherent has implemented the dma_alloc_coherent() + memset(),
> We prefer to dma_zalloc_coherent instead of open-codeing.
> 
> Signed-off-by: zhong jiang <zhongjiang@huawei.com>

Doesn't apply as I had already applied similar patch:

https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git/commit/?h=ath-next&id=d410e28f3ae476e1572b8893c646ef44fae7bbbd

error: patch failed: drivers/net/wireless/ath/wcn36xx/dxe.c:174
error: drivers/net/wireless/ath/wcn36xx/dxe.c: patch does not apply
stg import: Diff does not apply cleanly

Patch set to Rejected.

-- 
https://patchwork.kernel.org/patch/10570243/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
