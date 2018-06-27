Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:48984 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934909AbeF0QG2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 27 Jun 2018 12:06:28 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: atmel: use memdup_user to simplify the code
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180604103210.23984-1-yuehaibing@huawei.com>
References: <20180604103210.23984-1-yuehaibing@huawei.com>
To: YueHaibing <yuehaibing@huawei.com>
Cc: <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-wireless@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
Message-Id: <20180627160628.1ECF660AFF@smtp.codeaurora.org> (sfid-20180627_180714_526002_4C0FB5DB)
Date: Wed, 27 Jun 2018 16:06:28 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

YueHaibing <yuehaibing@huawei.com> wrote:

> use existing memdup_user() helper function instead of open-coding
> 
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Patch applied to wireless-drivers-next.git, thanks.

8668f9a57c8c atmel: use memdup_user to simplify the code

-- 
https://patchwork.kernel.org/patch/10446299/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
