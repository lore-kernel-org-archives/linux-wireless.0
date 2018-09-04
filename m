Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:48658 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726094AbeIDMl1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 4 Sep 2018 08:41:27 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [PATCH v4] rsi: remove set but not used variables 'header_size'
 and 'tx_params'
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1535788107-171830-1-git-send-email-yuehaibing@huawei.com>
References: <1535788107-171830-1-git-send-email-yuehaibing@huawei.com>
To: YueHaibing <yuehaibing@huawei.com>
Cc: Pavani Muthyala <pavani.muthyala@redpinesignals.com>,
        Kees Cook <keescook@chromium.org>,
        Colin Ian King <colin.king@canonical.com>,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>,
        Sushant Kumar Mishra <sushant.mishra@redpinesignals.com>,
        YueHaibing <yuehaibing@huawei.com>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>
Message-Id: <20180904081725.9B421603D2@smtp.codeaurora.org> (sfid-20180904_101729_436584_D372BFC9)
Date: Tue,  4 Sep 2018 08:17:25 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

YueHaibing <yuehaibing@huawei.com> wrote:

> Fixes gcc '-Wunused-but-set-variable' warning:
> 
> drivers/net/wireless/rsi/rsi_91x_hal.c: In function 'rsi_send_data_pkt':
> drivers/net/wireless/rsi/rsi_91x_hal.c:288:5: warning:
>  variable 'header_size' set but not used [-Wunused-but-set-variable]
> 
> 'tx_params' only used for 'header_size' dereferenced,so also
> can be removed.
> 
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Patch applied to wireless-drivers-next.git, thanks.

ec7eccf7ad1c rsi: remove set but not used variables 'header_size' and 'tx_params'

-- 
https://patchwork.kernel.org/patch/10584631/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
