Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:48195 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755250AbcH3QIk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 30 Aug 2016 12:08:40 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Baoyou Xie <baoyou.xie@linaro.org>
Cc: =?utf-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>,
        Arend Van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "open list\:BROADCOM BRCM80211 IEEE802.11n WIRELESS DRIVER"
        <brcm80211-dev-list.pdl@broadcom.com>,
        Network Development <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, xie.baoyou@zte.com.cn
Subject: Re: [PATCH v4] brcmfmac: add missing header dependencies
References: <1472474375-29910-1-git-send-email-baoyou.xie@linaro.org>
        <CACna6rytnp7WsrdscwPOTvi=FajAtoF2V2ZKx34RUdjEOiZO1w@mail.gmail.com>
        <CA+DQWkxpoScXLNhScNpwmLnaMhgVHoGLrH72dAm7OiOX2nW2vA@mail.gmail.com>
Date: Tue, 30 Aug 2016 19:08:33 +0300
In-Reply-To: <CA+DQWkxpoScXLNhScNpwmLnaMhgVHoGLrH72dAm7OiOX2nW2vA@mail.gmail.com>
        (Baoyou Xie's message of "Tue, 30 Aug 2016 19:15:35 +0800")
Message-ID: <87twe244u6.fsf@kamboji.qca.qualcomm.com> (sfid-20160830_180844_933606_39260052)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Baoyou Xie <baoyou.xie@linaro.org> writes:

> On 29 August 2016 at 23:31, Rafał Miłecki <zajec5@gmail.com> wrote:
>
>     On 29 August 2016 at 14:39, Baoyou Xie <baoyou.xie@linaro.org> wrote:
>     > We get 1 warning when build kernel with W=1:
>     > drivers/net/wireless/broadcom/brcm80211/brcmfmac/tracepoint.c:23:6:
>     warning: no previous prototype for '__brcmf_err' [-Wmissing-prototypes]
>
>     building? I'm not native English, but I think so.
>    
>
>     > In fact, this function is declared in brcmfmac/debug.h, so this patch
>     > add missing header dependencies.
>
>     adds
>    
>
>     > Signed-off-by: Baoyou Xie <baoyou.xie@linaro.org>
>     > Acked-by: Arnd Bergmann <arnd@arndb.de>
>
>     Please don't resend patches just to add tags like that. This only
>     increases a noise and patchwork handles this just fine, see:
>     https://patchwork.kernel.org/patch/9303285/
>     https://patchwork.kernel.org/patch/9303285/mbox/
>
>
> Do I need to resend a patch that fixes two typos(build/add)? or you modify them
> on your way?

I can fix those when I commit the patch.

-- 
Kalle Valo
