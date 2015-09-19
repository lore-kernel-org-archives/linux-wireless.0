Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:49874 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754730AbbISOZs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Sep 2015 10:25:48 -0400
Message-ID: <55FD7069.2030002@broadcom.com> (sfid-20150919_162550_579121_D5B931FF)
Date: Sat, 19 Sep 2015 16:25:45 +0200
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Hauke Mehrtens <hauke@hauke-m.de>, <kvalo@codeaurora.org>
CC: <brudley@broadcom.com>, <frankyl@broadcom.com>,
	<meuleman@broadcom.com>, <linux-wireless@vger.kernel.org>,
	<brcm80211-dev-list@broadcom.com>
Subject: Re: [PATCH] brcmfmac: include linux/atomic.h
References: <1442659640-11835-1-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1442659640-11835-1-git-send-email-hauke@hauke-m.de>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/19/2015 12:47 PM, Hauke Mehrtens wrote:
> brcmfmac uses atomic_or() and other atomic_* functions, but does not
> include linux/atomic.h. This file gets included by some other header
> file so this normally does not cause problems.

Thanks, Hauke

Acked-by: Arend van Spriel <arend@broadcom.com>
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
> ---
>   drivers/net/wireless/brcm80211/brcmfmac/sdio.c | 1 +
>   1 file changed, 1 insertion(+)
>
> diff --git a/drivers/net/wireless/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/sdio.c
> index f990e3d..ea9150b 100644
> --- a/drivers/net/wireless/brcm80211/brcmfmac/sdio.c
> +++ b/drivers/net/wireless/brcm80211/brcmfmac/sdio.c
> @@ -15,6 +15,7 @@
>    */
>
>   #include <linux/types.h>
> +#include <linux/atomic.h>
>   #include <linux/kernel.h>
>   #include <linux/kthread.h>
>   #include <linux/printk.h>
>

