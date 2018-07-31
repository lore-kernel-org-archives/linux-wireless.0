Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:34590 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727071AbeGaJHE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 31 Jul 2018 05:07:04 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [PATCH] rt2x00: remove redundant functions
 rt2x00mac_sta_{add/remove}
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180727130549.12980-1-yuehaibing@huawei.com>
References: <20180727130549.12980-1-yuehaibing@huawei.com>
To: YueHaibing <yuehaibing@huawei.com>
Cc: <davem@davemloft.net>, <sgruszka@redhat.com>,
        <helmut.schaa@googlemail.com>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-wireless@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
Message-Id: <20180731072807.A69D760714@smtp.codeaurora.org> (sfid-20180731_092844_893471_7C5508D8)
Date: Tue, 31 Jul 2018 07:28:07 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

YueHaibing <yuehaibing@huawei.com> wrote:

> Only rt2800 subdriver of rt2x00 implement sta_add() and sta_remove(),
> rt2x00mac_sta_add and rt2x00mac_sta_remove has no callers after
> commit 9c87758cf089 ("rt2x00: call sta_add/remove directly in rt2800").
> So can be removed.
> 
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> Acked-by: Stanislaw Gruszka <sgruszka@redhat.com>

Patch applied to wireless-drivers-next.git, thanks.

24ebfcbdd1ba rt2x00: remove redundant functions rt2x00mac_sta_{add/remove}

-- 
https://patchwork.kernel.org/patch/10547141/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
