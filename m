Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:37340 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726669AbeITRyi (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 20 Sep 2018 13:54:38 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [PATCH] brcmfmac: remove set but not used variables 'sfdoff' and
 'pad_size'
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180911032404.14536-1-yuehaibing@huawei.com>
References: <20180911032404.14536-1-yuehaibing@huawei.com>
To: YueHaibing <yuehaibing@huawei.com>
Cc: <davem@davemloft.net>, <arend.vanspriel@broadcom.com>,
        <franky.lin@broadcom.com>, <hante.meuleman@broadcom.com>,
        <chi-hsien.lin@cypress.com>, <wright.feng@cypress.com>,
        <pieter-paul.giesberts@broadcom.com>, <ian@mnementh.co.uk>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-wireless@vger.kernel.org>,
        <brcm80211-dev-list.pdl@broadcom.com>,
        <brcm80211-dev-list@cypress.com>,
        YueHaibing <yuehaibing@huawei.com>
Message-Id: <20180920121126.70BE1602A7@smtp.codeaurora.org> (sfid-20180920_141147_916367_671A1720)
Date: Thu, 20 Sep 2018 12:11:26 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

YueHaibing <yuehaibing@huawei.com> wrote:

> Fixes gcc '-Wunused-but-set-variable' warning:
> 
> drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c: In function 'brcmf_sdio_rxglom':
> drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c:1466:11: warning:
>  variable 'sfdoff' set but not used [-Wunused-but-set-variable]
> 
> drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c: In function 'brcmf_sdio_bus_preinit':
> drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c:3408:7: warning:
>  variable 'pad_size' set but not used [-Wunused-but-set-variable]
> 
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Patch applied to wireless-drivers-next.git, thanks.

a8254fa4ba60 brcmfmac: remove set but not used variables 'sfdoff' and 'pad_size'

-- 
https://patchwork.kernel.org/patch/10595033/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
