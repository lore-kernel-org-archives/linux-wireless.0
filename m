Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:57589 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751127AbcICKLE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 3 Sep 2016 06:11:04 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v4] brcmfmac: add missing header dependencies
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1472474375-29910-1-git-send-email-baoyou.xie@linaro.org>
To: Baoyou Xie <baoyou.xie@linaro.org>
Cc: arend.vanspriel@broadcom.com, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com, linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, arnd@arndb.de, baoyou.xie@linaro.org,
        xie.baoyou@zte.com.cn
Message-Id: <20160903101035.74BDC6201D@smtp.codeaurora.org> (sfid-20160903_121206_632289_AC7D4F1B)
Date: Sat,  3 Sep 2016 10:10:35 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Baoyou Xie <baoyou.xie@linaro.org> wrote:
> We get 1 warning when building kernel with W=1:
> 
> drivers/net/wireless/broadcom/brcm80211/brcmfmac/tracepoint.c:23:6: warning: no previous prototype for '__brcmf_err' [-Wmissing-prototypes]
> 
> In fact, this function is declared in brcmfmac/debug.h, so this patch
> adds missing header dependencies.
> 
> Signed-off-by: Baoyou Xie <baoyou.xie@linaro.org>
> Acked-by: Arnd Bergmann <arnd@arndb.de>

Thanks, 1 patch applied to wireless-drivers-next.git:

8af92af3f2d5 brcmfmac: add missing header dependencies

-- 
Sent by pwcli
https://patchwork.kernel.org/patch/9303939/
