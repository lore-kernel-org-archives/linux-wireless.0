Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.130]:61283 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757045AbcH2JCh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 29 Aug 2016 05:02:37 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Baoyou Xie <baoyou.xie@linaro.org>
Cc: franky.lin@broadcom.com, hante.meuleman@broadcom.com,
        kvalo@codeaurora.org, linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, xie.baoyou@zte.com.cn
Subject: Re: [PATCH v3] brcmfmac: add missing header dependencies
Date: Mon, 29 Aug 2016 11:02:07 +0200
Message-ID: <6640253.GDmR9LxZA8@wuerfel> (sfid-20160829_110300_739349_20F438AD)
In-Reply-To: <1472458485-24499-1-git-send-email-baoyou.xie@linaro.org>
References: <1472458485-24499-1-git-send-email-baoyou.xie@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday, August 29, 2016 4:14:45 PM CEST Baoyou Xie wrote:
> We get 1 warning when biuld kernel with W=1:
> drivers/net/wireless/broadcom/brcm80211/brcmfmac/tracepoint.c:23:6: warning: no previous prototype for '__brcmf_err' [-Wmissing-prototypes]
> 
> In fact, this function is declared in brcmfmac/debug.h, so this patch
> add missing header dependencies.
> 
> Signed-off-by: Baoyou Xie <baoyou.xie@linaro.org>

Acked-by: Arnd Bergmann <arnd@arndb.de>
