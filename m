Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:44520 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751182AbeEPLmr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 16 May 2018 07:42:47 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: YueHaibing <yuehaibing@huawei.com>
Cc: <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH net-next] ath10k: Remove useless test before clk_disable_unprepare
References: <20180516105454.30212-1-yuehaibing@huawei.com>
Date: Wed, 16 May 2018 14:42:43 +0300
In-Reply-To: <20180516105454.30212-1-yuehaibing@huawei.com>
        (yuehaibing@huawei.com's message of "Wed, 16 May 2018 18:54:54 +0800")
Message-ID: <87d0xvyggc.fsf@purkki.adurom.net> (sfid-20180516_134255_291306_BF8D7F1E)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

YueHaibing <yuehaibing@huawei.com> writes:

> clk_disable_unprepare() already checks that the clock pointer is valid.
> No need to test it before calling it.
>
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Just a note that ath10k patches are applied to my ath.git tree, not to
net-next. So adding net-next to the subject is wrong, but no need to
resend just because of that.

-- 
Kalle Valo
