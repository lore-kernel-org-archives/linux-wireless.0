Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:35080 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755985AbcH2PcV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 29 Aug 2016 11:32:21 -0400
MIME-Version: 1.0
In-Reply-To: <1472474375-29910-1-git-send-email-baoyou.xie@linaro.org>
References: <1472474375-29910-1-git-send-email-baoyou.xie@linaro.org>
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Date: Mon, 29 Aug 2016 17:31:50 +0200
Message-ID: <CACna6rytnp7WsrdscwPOTvi=FajAtoF2V2ZKx34RUdjEOiZO1w@mail.gmail.com> (sfid-20160829_173308_962402_644BA0BE)
Subject: Re: [PATCH v4] brcmfmac: add missing header dependencies
To: Baoyou Xie <baoyou.xie@linaro.org>
Cc: Arend Van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "open list:BROADCOM BRCM80211 IEEE802.11n WIRELESS DRIVER"
        <brcm80211-dev-list.pdl@broadcom.com>,
        Network Development <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, xie.baoyou@zte.com.cn
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 29 August 2016 at 14:39, Baoyou Xie <baoyou.xie@linaro.org> wrote:
> We get 1 warning when build kernel with W=1:
> drivers/net/wireless/broadcom/brcm80211/brcmfmac/tracepoint.c:23:6: warning: no previous prototype for '__brcmf_err' [-Wmissing-prototypes]

building? I'm not native English, but I think so.


> In fact, this function is declared in brcmfmac/debug.h, so this patch
> add missing header dependencies.

adds


> Signed-off-by: Baoyou Xie <baoyou.xie@linaro.org>
> Acked-by: Arnd Bergmann <arnd@arndb.de>

Please don't resend patches just to add tags like that. This only
increases a noise and patchwork handles this just fine, see:
https://patchwork.kernel.org/patch/9303285/
https://patchwork.kernel.org/patch/9303285/mbox/
