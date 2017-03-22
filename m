Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f180.google.com ([209.85.128.180]:35054 "EHLO
        mail-wr0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1759168AbdCVTkG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 22 Mar 2017 15:40:06 -0400
Received: by mail-wr0-f180.google.com with SMTP id u1so795204wra.2
        for <linux-wireless@vger.kernel.org>; Wed, 22 Mar 2017 12:38:44 -0700 (PDT)
Subject: Re: [PATCH] brcmfmac: update BRCMFMAC symbol description
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>
References: <20170321144339.1709-1-zajec5@gmail.com>
Cc: Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Franky Lin <frankyl@broadcom.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <90f2fa7c-4bb7-7f1a-0641-19ff1e21e64c@broadcom.com> (sfid-20170322_204210_277130_4A935816)
Date: Wed, 22 Mar 2017 20:38:41 +0100
MIME-Version: 1.0
In-Reply-To: <20170321144339.1709-1-zajec5@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 21-3-2017 15:43, Rafał Miłecki wrote:
> From: Rafał Miłecki <rafal@milecki.pl>
> 
> For quite some time now brcmfmac supports 802.11ac chipsets and it's
> not limited to embedded devices only. There are even standalone PCIe
> cards based on BCM43602 or BCM4366.

minor comments below.

Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
> ---
>  drivers/net/wireless/broadcom/brcm80211/Kconfig | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/net/wireless/broadcom/brcm80211/Kconfig b/drivers/net/wireless/broadcom/brcm80211/Kconfig
> index d93561f6ef97..817cb28f518f 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/Kconfig
> +++ b/drivers/net/wireless/broadcom/brcm80211/Kconfig
> @@ -18,14 +18,14 @@ config BRCMSMAC
>  	  module, the driver will be called brcmsmac.ko.
>  
>  config BRCMFMAC
> -	tristate "Broadcom IEEE802.11n embedded FullMAC WLAN driver"
> +	tristate "Broadcom IEEE802.11n WLAN driver"

You still mention 11n. Let's drop the 'n' here or IEEE802.11n entirely
like below. Would like to keep the term FullMAC though.

Regards,
Arend
