Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:51712 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726513AbeHXPYH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 24 Aug 2018 11:24:07 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [PATCH] wcn36xx: Use kmemdup instead of duplicating it in
 wcn36xx_smd_process_ptt_msg_rsp
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180724114317.18580-1-yuehaibing@huawei.com>
References: <20180724114317.18580-1-yuehaibing@huawei.com>
To: YueHaibing <yuehaibing@huawei.com>
Cc: <davem@davemloft.net>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-wireless@vger.kernel.org>,
        <wcn36xx@lists.infradead.org>, YueHaibing <yuehaibing@huawei.com>
Message-Id: <20180824114949.A3212604BE@smtp.codeaurora.org> (sfid-20180824_135002_810725_744FA3F8)
Date: Fri, 24 Aug 2018 11:49:49 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

YueHaibing <yuehaibing@huawei.com> wrote:

> Replace calls to kmalloc followed by a memcpy with a direct call to
> kmemdup.
> 
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

3f96556f639e wcn36xx: Use kmemdup instead of duplicating it in wcn36xx_smd_process_ptt_msg_rsp

-- 
https://patchwork.kernel.org/patch/10541903/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
