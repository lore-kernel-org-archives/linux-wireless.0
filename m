Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:52018 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750831AbeE2HUg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 29 May 2018 03:20:36 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: atmel: Add missing call to pci_disable_device()
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180523103445.8372-1-yuehaibing@huawei.com>
References: <20180523103445.8372-1-yuehaibing@huawei.com>
To: YueHaibing <yuehaibing@huawei.com>
Cc: <simon@thekelleys.org.uk>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>, <linux-wireless@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
Message-Id: <20180529072036.802216060A@smtp.codeaurora.org> (sfid-20180529_092047_548332_9EC56064)
Date: Tue, 29 May 2018 07:20:36 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

YueHaibing <yuehaibing@huawei.com> wrote:

> add pci_disable_device in error handling while init_atmel_card failed.
> 
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Patch applied to wireless-drivers-next.git, thanks.

88027c8ff0a3 atmel: Add missing call to pci_disable_device()

-- 
https://patchwork.kernel.org/patch/10420905/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
