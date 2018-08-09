Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:46958 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731793AbeHIRko (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 9 Aug 2018 13:40:44 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [PATCH] rtlwifi: btcoex: Fix if == else warnings in
 halbtc8723b2ant.c
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180806045440.11920-1-yuehaibing@huawei.com>
References: <20180806045440.11920-1-yuehaibing@huawei.com>
To: YueHaibing <yuehaibing@huawei.com>
Cc: <pkshih@realtek.com>, <Larry.Finger@lwfinger.net>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <davem@davemloft.net>, <colin.king@canonical.com>,
        <linux-wireless@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
Message-Id: <20180809151521.C033760B7E@smtp.codeaurora.org> (sfid-20180809_171531_038002_8A59290D)
Date: Thu,  9 Aug 2018 15:15:21 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

YueHaibing <yuehaibing@huawei.com> wrote:

> Fix following coccinelle warning:
> 
> ./drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c:2952:2-4: WARNING: possible condition with no effect (if == else)
> ./drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c:2961:2-4: WARNING: possible condition with no effect (if == else)
> ./drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c:3011:2-4: WARNING: possible condition with no effect (if == else)
> ./drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c:3020:2-4: WARNING: possible condition with no effect (if == else)
> ./drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c:3439:2-4: WARNING: possible condition with no effect (if == else)
> ./drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c:3448:2-4: WARNING: possible condition with no effect (if == else)
> ./drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c:3339:2-4: WARNING: possible condition with no effect (if == else)
> ./drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c:3348:2-4: WARNING: possible condition with no effect (if == else)
> ./drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c:3074:2-4: WARNING: possible condition with no effect (if == else)
> ./drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c:3083:2-4: WARNING: possible condition with no effect (if == else)
> ./drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c:3192:2-4: WARNING: possible condition with no effect (if == else)
> ./drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c:3201:2-4: WARNING: possible condition with no effect (if == else)
> ./drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c:3267:2-4: WARNING: possible condition with no effect (if == else)
> ./drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c:3276:2-4: WARNING: possible condition with no effect (if == else)
> ./drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c:3124:2-4: WARNING: possible condition with no effect (if == else)
> ./drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c:3133:2-4: WARNING: possible condition with no effect (if == else)
> ./drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c:2821:2-4: WARNING: possible condition with no effect (if == else)
> ./drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c:2830:2-4: WARNING: possible condition with no effect (if == else)
> 
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> Acked-by: Ping-Ke Shih <pkshih@realtek.com>

Patch applied to wireless-drivers-next.git, thanks.

ad2e6d23bdad rtlwifi: btcoex: Fix if == else warnings in halbtc8723b2ant.c

-- 
https://patchwork.kernel.org/patch/10556487/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
