Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:38908 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753231AbeGDPP0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 4 Jul 2018 11:15:26 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v2] atmel: using strlcpy() to avoid possible buffer overflows
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180630063341.9900-1-yuehaibing@huawei.com>
References: <20180630063341.9900-1-yuehaibing@huawei.com>
To: YueHaibing <yuehaibing@huawei.com>
Cc: <simon@thekelleys.org.uk>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-wireless@vger.kernel.org>,
        <davem@davemloft.net>, <andy.shevchenko@gmail.com>,
        YueHaibing <yuehaibing@huawei.com>
Message-Id: <20180704151525.62BF460B26@smtp.codeaurora.org> (sfid-20180704_171604_694990_EB53843D)
Date: Wed,  4 Jul 2018 15:15:25 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

YueHaibing <yuehaibing@huawei.com> wrote:

> 'firmware' is a module param which may been longer than firmware_id,
> so using strlcpy() to guard against overflows. Also priv is allocated
> with zeroed memory,no need to set firmware_id[0] to '\0'.
> 
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Patch applied to wireless-drivers-next.git, thanks.

f9cbaeb52930 atmel: using strlcpy() to avoid possible buffer overflows

-- 
https://patchwork.kernel.org/patch/10498009/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
