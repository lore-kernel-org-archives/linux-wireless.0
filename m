Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:34894 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726669AbeITRuU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 20 Sep 2018 13:50:20 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [PATCH] brcm80211: remove redundant condition check before
 debugfs_remove_recursive
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1536761412-24932-1-git-send-email-zhongjiang@huawei.com>
References: <1536761412-24932-1-git-send-email-zhongjiang@huawei.com>
To: zhong jiang <zhongjiang@huawei.com>
Cc: <davem@davemloft.net>, <hante.meuleman@broadcom.com>,
        <franky.lin@broadcom.com>, <arend.vanspriel@broadcom.com>,
        <linux-wireless@vger.kernel.org>,
        <brcm80211-dev-list.pdl@broadcom.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Message-Id: <20180920120709.A603560BE3@smtp.codeaurora.org> (sfid-20180920_140740_056820_5023A4C8)
Date: Thu, 20 Sep 2018 12:07:09 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

zhong jiang <zhongjiang@huawei.com> wrote:

> debugfs_remove_recursive has taken IS_ERR_OR_NULL into account. So just
> remove the condition check before debugfs_remove_recursive.
> 
> Signed-off-by: zhong jiang <zhongjiang@huawei.com>

It seems you already submitted an identical patch four days earlier:

https://patchwork.kernel.org/patch/10593061/

Why the duplicate? Please ALWAYS add a changelog and increase the version number:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches#changelog_missing

-- 
https://patchwork.kernel.org/patch/10597627/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
