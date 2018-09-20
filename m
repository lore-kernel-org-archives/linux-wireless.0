Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:37178 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732526AbeITRyC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 20 Sep 2018 13:54:02 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [PATCH] brcm80211: remove redundant condition check before
 debugfs_remove_recursive
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1536414043-32146-1-git-send-email-zhongjiang@huawei.com>
References: <1536414043-32146-1-git-send-email-zhongjiang@huawei.com>
To: zhong jiang <zhongjiang@huawei.com>
Cc: <davem@davemloft.net>, <arend.vanspriel@broadcom.com>,
        <franky.lin@broadcom.com>, <hante.meuleman@broadcom.com>,
        <chi-hsien.lin@cypress.com>, <wright.feng@cypress.com>,
        <linux-wireless@vger.kernel.org>,
        <brcm80211-dev-list.pdl@broadcom.com>, <netdev@vger.kernel.org>
Message-Id: <20180920121051.0538960BF7@smtp.codeaurora.org> (sfid-20180920_141058_844654_51A8AED0)
Date: Thu, 20 Sep 2018 12:10:51 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

zhong jiang <zhongjiang@huawei.com> wrote:

> debugfs_remove_recursive has taken IS_ERR_OR_NULL into account. So just
> remove the condition check before debugfs_remove_recursive.
> 
> Signed-off-by: zhong jiang <zhongjiang@huawei.com>

Patch applied to wireless-drivers-next.git, thanks.

761cb7cdef1a brcm80211: remove redundant condition check before debugfs_remove_recursive

-- 
https://patchwork.kernel.org/patch/10593061/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
