Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bl2nam02on0089.outbound.protection.outlook.com ([104.47.38.89]:42816
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726761AbeIKR62 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 11 Sep 2018 13:58:28 -0400
Date: Tue, 11 Sep 2018 15:58:54 +0300
From: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To: YueHaibing <yuehaibing@huawei.com>
Cc: Igor Mitsyanko <imitsyanko@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>,
        Sergey Matyukevich <smatyukevich@quantenna.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sergei Maksimenko <smaksimenko@quantenna.com>,
        Vasily Ulyanov <vulyanov@quantenna.com>,
        Andrey Shevchenko <ashevchenko@quantenna.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] qtnfmac: remove set but not used variable 'vif'
Message-ID: <20180911125853.2j7cflclfhkbpgct@bars> (sfid-20180911_145922_314285_9047B8EE)
References: <1536668904-13110-1-git-send-email-yuehaibing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1536668904-13110-1-git-send-email-yuehaibing@huawei.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Fixes gcc '-Wunused-but-set-variable' warning:
> 
> drivers/net/wireless/quantenna/qtnfmac/cfg80211.c: In function 'qtnf_dump_survey':
> drivers/net/wireless/quantenna/qtnfmac/cfg80211.c:694:19: warning:
>  variable 'vif' set but not used [-Wunused-but-set-variable]
> 
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Thanks !

Reviewed-by: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>

Regards,
Sergey
