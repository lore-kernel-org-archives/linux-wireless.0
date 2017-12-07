Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:54320 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755155AbdLGNtr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 7 Dec 2017 08:49:47 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v1] brcmfmac: Avoid build error with make W=1
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20171123155704.44878-1-andriy.shevchenko@linux.intel.com>
References: <20171123155704.44878-1-andriy.shevchenko@linux.intel.com>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Message-Id: <20171207134947.68BE5607EB@smtp.codeaurora.org> (sfid-20171207_145023_539450_FCD09EA2)
Date: Thu,  7 Dec 2017 13:49:47 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Andy Shevchenko <andriy.shevchenko@linux.intel.com> wrote:

> When I run make W=1 on gcc (Debian 7.2.0-16) 7.2.0 I got an error for
> the first run, all next ones are okay.
> 
>   CC [M]  drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.o
> drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c:2078: error: Cannot parse struct or union!
> scripts/Makefile.build:310: recipe for target 'drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.o' failed
> 
> Seems like something happened with W=1 and wrong kernel doc format.
> As a quick fix remove dubious /** in the code.
> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>

Patch applied to wireless-drivers.git, thanks.

51ef7925e106 brcmfmac: Avoid build error with make W=1

-- 
https://patchwork.kernel.org/patch/10073021/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
